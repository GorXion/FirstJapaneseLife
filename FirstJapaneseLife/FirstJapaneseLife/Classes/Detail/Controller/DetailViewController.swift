//
//  DetailViewController.swift
//  FirstJapaneseLife
//
//  Created by G-Xi0N on 2017/12/14.
//  Copyright © 2017年 G-Xi0N. All rights reserved.
//

import UIKit
import Agrume
import SDCycleScrollView

class DetailViewController: BaseViewController {

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = UITableViewAutomaticDimension
        tableView.register(ServiceChildTextCell.self, forCellReuseIdentifier: "ServiceChildTextCell")
        tableView.register(DetailMapCell.self, forCellReuseIdentifier: "DetailMapCell")
        tableView.register(DetailAddressCell.self, forCellReuseIdentifier: "DetailAddressCell")
        return tableView
    }()
    
    lazy var images: [UIImage] = {
        var images = [UIImage]()
        if let imgs = detailModel.images {
            for name in imgs {
                images.append(UIImage(named: name)!)
            }
        }
        return images
    }()
    
    var detailModel = DetailModel()

    // MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        ay_navigationItem.title = detailModel.name
        disableAdjustsScrollViewInsets(tableView)
        ay_navigationBar.alpha = 0

        addSubviews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func languageWillChange(sender: Notification) {
        ay_navigationItem.title = detailModel.name
        tableView.reloadData()
    }

    // MARK: - private
    private func addSubviews() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        setupTableHeaderView()
    }

    private func setupTableHeaderView() {
        guard let images = detailModel.images else { return }
        let headerView = SDCycleScrollView(frame: CGRect(x: 0, y: 0, width: UIScreen.width, height: 240), imageNamesGroup: images)
        headerView?.delegate = self as SDCycleScrollViewDelegate
        tableView.tableHeaderView = headerView
    }
}

// MARK: - UITableViewDataSource
extension DetailViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 1:
            return 3
        default:
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch indexPath.section {
        case 0:
            let cell: ServiceChildTextCell = tableView.dequeueReusableCell(withIdentifier: "ServiceChildTextCell") as! ServiceChildTextCell
            cell.textView.text = detailModel.desc
            return cell
        case 1:
            let cell: DetailAddressCell = tableView.dequeueReusableCell(withIdentifier: "DetailAddressCell") as! DetailAddressCell
            cell.leftLabel.text = ["地址", "电话", "营业时间"][indexPath.row]
            switch indexPath.row {
            case 0:
                cell.rightLabel.text = detailModel.address
            case 1:
                cell.rightLabel.text = detailModel.telphone
            default:
                cell.rightLabel.text = detailModel.open_time
            }
            return cell
        default:
            let cell: DetailMapCell = tableView.dequeueReusableCell(withIdentifier: "DetailMapCell") as! DetailMapCell
            cell.address = detailModel.jaddress
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension DetailViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = TitleHeaderView()
        let iconImgs = ["detail_header_intro", "detail_header_address", "detail_header_map"]
        header.iconView.image = UIImage(named: iconImgs[section])
        header.titleLabel.text = ["介绍", "位置", "地图"][section]
        return header
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            var frame = CGRect.zero
            if let desc = detailModel.desc as NSString? {
                frame = desc.boundingRect(with: CGSize(width: UIScreen.width - 30, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)], context: nil)
            }
            return frame.height + 20
        case 1:
            guard indexPath.row > 0 else {
                var frame = CGRect.zero
                if let address = detailModel.address as NSString? {
                    frame = address.boundingRect(with: CGSize(width: UIScreen.width - 115, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)], context: nil)
                }
                return frame.height + 28
            }
            return 44
        default:
            return 240
        }
    }
}

// MARK: - UIScrollViewDelegate
extension DetailViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 0 {
            let alpha = scrollView.contentOffset.y / CGFloat(176)
            ay_navigationBar.alpha = alpha
        } else {
            let alpha = -scrollView.contentOffset.y / ay_navigationBar.frame.maxY
            ay_navigationBar.alpha = alpha
        }
    }
}

extension DetailViewController: SDCycleScrollViewDelegate {
    func cycleScrollView(_ cycleScrollView: SDCycleScrollView!, didSelectItemAt index: Int) {
        let agrume = Agrume(images: images, startIndex: index, backgroundBlurStyle: .dark)
        agrume.statusBarStyle = .lightContent
        agrume.showFrom(self)
    }
}
