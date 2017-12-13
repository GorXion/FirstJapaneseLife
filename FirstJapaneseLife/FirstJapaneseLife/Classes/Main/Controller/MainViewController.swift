//
//  MainViewController.swift
//  FirstJapaneseLife
//
//  Created by G-Xi0N on 2017/12/13.
//  Copyright © 2017年 G-Xi0N. All rights reserved.
//

import UIKit

var kScreenWidth = UIScreen.main.bounds.width
var kScreenHeight = UIScreen.main.bounds.height

class MainViewController: UIViewController {
    
    lazy var facilityButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("施設", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(self, action: #selector(facilityButtonAction), for: .touchUpInside)
        return btn
    }()
    
    lazy var serviceButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("サービス", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(self, action: #selector(serviceButtonAction), for: .touchUpInside)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationController?.navigationBar.barTintColor = .global
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        navigationItem.title = "初めての日本生活"
        
        addSubviews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - private
    func addSubviews() {
        view.addSubview(facilityButton)
        view.addSubview(serviceButton)
        
        facilityButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(self.view.snp.centerY).offset(-30)
            make.size.equalTo(CGSize(width: kScreenWidth - 60, height: 30))
        }
        
        serviceButton.snp.makeConstraints { (make) in
            make.top.equalTo(facilityButton.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: kScreenWidth - 60, height: 30))
        }
    }

    // MARK: - action
    @objc func facilityButtonAction() {
        navigationController?.pushViewController(FacilityViewController(), animated: true)
    }
    
    @objc func serviceButtonAction() {
        navigationController?.pushViewController(ServiceViewController(), animated: true)
    }
}