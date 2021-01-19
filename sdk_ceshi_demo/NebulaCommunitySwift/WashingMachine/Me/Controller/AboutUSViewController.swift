//
//  AboutUSViewController.swift
//  WashingMachine
//
//  Created by 张丹丹 on 16/11/2.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

import UIKit
import SnapKit

class AboutUSViewController: BaseViewController {

    fileprivate var verson:UILabel?
    fileprivate var contentTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationItem.title = "关于我们"
        self.view.backgroundColor = UIColor.white
        
        self.makeUI()
        self.aboutUS()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    fileprivate func aboutUS() {
        let url = SERVICE_BASE_ADDRESS + API_GET_APP_ABOUT
        NetworkEngine.get(url, parameters: nil) { (result) in
            if result.isSuccess {
                if let dict = result.dataObj as? [String: AnyObject] {
                    let data = dict["data"] as? String ?? ""
                    self.contentTextView.text = data
                }
            }
        }
    }

    fileprivate func makeUI() {
        
        let logo = UIImageView()
        logo.image = UIImage(named: "logo")
        self.view.addSubview(logo)
        logo.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(24)
            make.height.width.equalTo(BOUNDS_WIDTH*4/15)
        }
        
        let label = UILabel()
        label.text = "Copyright ©2016 北京时代星云科技有限公司 版权所有"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.init(red: 102/255.0, green: 102/255.0, blue: 102/255.0, alpha: 1)
        self.view.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-16)
            make.left.equalToSuperview().offset(35)
            make.right.equalToSuperview().offset(-35)
        }
        
        let line = UIView()
        line.backgroundColor = UIColor.black
        self.view.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalTo(label.snp.top).offset(-16)
            make.height.equalTo(0.5)
        }
        
        
        verson = UILabel()
        verson?.text = "版本号  " + HZApp.appVersion
        verson?.font = UIFont.systemFont(ofSize: 16)
        verson?.textColor = THEMEGRAYCOLOR
        self.view.addSubview(verson!)
        verson?.snp.makeConstraints({ (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(line.snp.top).offset(-24);
        })
     
        let centerV = UIView()
        centerV.backgroundColor = UIColor(rgb:0xF3F8FB)
        centerV.layer.masksToBounds = true
        centerV.layer.cornerRadius = 4
        self.view.addSubview(centerV)
        centerV.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.top.equalTo(logo.snp.bottom).offset(24)
            make.bottom.equalTo((self.verson?.snp.top)!).offset(-37)
        }
     
        let titleLabel = UITextView()
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.isEditable = false
        titleLabel.textColor = UIColor.init(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1)
        centerV.addSubview(titleLabel)
        self.contentTextView = titleLabel
        titleLabel.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview().offset(10)
            make.right.bottom.equalToSuperview().offset(-10)
        }
    }
}
