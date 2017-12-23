//
//  ServiceChildViewController.swift
//  FirstJapaneseLife
//
//  Created by G-Xi0N on 2017/12/13.
//  Copyright © 2017年 G-Xi0N. All rights reserved.
//

import UIKit
import AVFoundation
import Agrume

class ServiceChildViewController: BaseViewController {

    var serviceModel = ServiceListModel()

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.separatorColor = UIColor.hairline
        tableView.register(ServiceChildListCell.self, forCellReuseIdentifier: "ServiceChildListCell")
        tableView.register(ServiceChildReadyCell.self, forCellReuseIdentifier: "ServiceChildReadyCell")
        tableView.register(ServiceChildTextCell.self, forCellReuseIdentifier: "ServiceChildTextCell")
        return tableView
    }()
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        disableAdjustsScrollViewInsets(tableView)
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(ay_navigationBar.snp.bottom)
            make.left.bottom.right.equalToSuperview()
        }
        setupTableFooterView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func languageWillChange(sender: Notification) {
        ay_navigationItem.title = serviceModel.name
        tableView.reloadData()
    }
    
    // MARK: - private
    private func setupTableFooterView() {

        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.width, height: 70))
        let playBtn = GlobalButton(title: "播放")
        playBtn.addTarget(self, action: #selector(playButtonAction), for: .touchUpInside)
        footerView.addSubview(playBtn)
        playBtn.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: UIScreen.width - 30, height: 36))
        }
        tableView.tableFooterView = footerView
    }
    
    // MARK: - action
    @objc private func playButtonAction() {
        #if arch(i386) || arch(x86_64)
            return
        #endif
        VoiceSpeaker.speak(serviceModel.chat!)
    }
}

// MARK: - UITableViewDataSource
extension ServiceChildViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return serviceModel.list.count
        default:
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch indexPath.section {
        case 0:
            let cell: ServiceChildListCell = tableView.dequeueReusableCell(withIdentifier: "ServiceChildListCell") as! ServiceChildListCell
            let model = serviceModel.list[indexPath.row]
            cell.titleLabel.text = model.name
            return cell
        case 2:
            let cell: ServiceChildReadyCell = tableView.dequeueReusableCell(withIdentifier: "ServiceChildReadyCell") as! ServiceChildReadyCell
            guard let readyImages = serviceModel.ready_images else {
                return cell
            }
            cell.images = readyImages
            var images = [UIImage]()
            for name in readyImages {
                images.append(UIImage(named: name)!)
            }
            cell.didSelectItemHandler = { (index) in
                let agrume = Agrume(images: images, startIndex: index, backgroundBlurStyle: .dark)
                agrume.statusBarStyle = .lightContent
                agrume.showFrom(self)
            }
            return cell

        default:
            let cell: ServiceChildTextCell = tableView.dequeueReusableCell(withIdentifier: "ServiceChildTextCell") as! ServiceChildTextCell
            if indexPath.section == 1 {
                cell.textView.text = serviceModel.flow
            } else {
                cell.textView.text = serviceModel.chat
            }
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension ServiceChildViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard indexPath.section == 0 else {
            return
        }
        let detailVC = DetailViewController()
        let model = serviceModel.list[indexPath.row]
        detailVC.detailModel = model
        navigationController?.pushViewController(detailVC, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 44
        case 1:
            var frame = CGRect.zero
            if let flow = serviceModel.flow as NSString? {
                frame = flow.boundingRect(with: CGSize(width: UIScreen.width - 30, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)], context: nil)
            }
            return frame.height + 20
        case 2:
            return UIScreen.width / 2
        default:
            var frame = CGRect.zero
            if let chat = serviceModel.chat as NSString? {
                frame = chat.boundingRect(with: CGSize(width: UIScreen.width - 30, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)], context: nil)
            }
            return frame.height + 20
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = TitleHeaderView()
        let iconImgs = ["service_child_site", "service_child_flow", "service_child_ready", "service_child_chat"]
        header.iconView.image = UIImage(named: iconImgs[section])
        header.titleLabel.textColor = UIColor(hex: "#8a8a8a")
        header.titleLabel.text = ["场所", "流程", "准备", "对话例"][section]
        return header
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
}
