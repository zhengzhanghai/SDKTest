//
//  AuthTradingAccountViewController.swift
//  WashingMachine
//
//  Created by zzh on 2017/9/6.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

import UIKit

class AuthTradingAccountViewController: BaseViewController {
    
    fileprivate let titles = ["微信", "支付宝"]
    fileprivate let icons = ["binding_wx", "binding_alipay"]
    
    fileprivate var contentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "绑定账号"
        self.view.backgroundColor = UIColor(rgb: 0xf9f9f9)
        self.makeUI()
        
    }
    
    @objc func clickItem(_ btn: UIButton) {
        let str = ""
        ZZPrint(str.md5())
        if btn.tag == 0 { //微信
            WeChatManager.sendAuthRequest({ (authResult) in
                if authResult.type == .startCallBack {
                    self.showWaitingView(appRootView ?? self.view)
                } else {
                    self.hiddenWaitingView()
                    if authResult.type == .success {
                        ZZPrint("sfsdf")
                    } else {
                        showError(authResult.desp, superView: self.view, afterHidden: 2)
                    }
                }
            })
        } else {
            NCAlipayManger.authInfo()
        }
    }
    
    fileprivate func makeUI() {
        contentView = UIView()
        contentView.backgroundColor = UIColor.white
        view.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
        }
        let itemHeight: CGFloat = 65
        let sepLineHeight: CGFloat = 0.5
        for (index, title) in titles.enumerated() {
            let btn = UIButton(type: .custom)
            btn.tag = index;
            btn.addTarget(self, action: #selector(clickItem(_:)), for: .touchUpInside)
            contentView.addSubview(btn)
            btn.snp.makeConstraints({ (make) in
                make.left.right.equalToSuperview()
                make.top.equalTo(CGFloat(index)*(itemHeight+sepLineHeight))
                make.height.equalTo(itemHeight)
                if index == self.titles.count-1 {
                    make.bottom.equalToSuperview()
                }
            })
            
            let icon = UIImageView()
            icon.image = UIImage(named: icons[index])
            btn.addSubview(icon)
            icon.snp.makeConstraints({ (make) in
                make.left.equalToSuperview().offset(15)
                make.centerY.equalToSuperview()
                make.width.height.equalTo(35)
            })
            
            let titleLabel = UILabel()
            titleLabel.text = title
            btn.addSubview(titleLabel)
            titleLabel.snp.makeConstraints({ (make) in
                make.left.equalTo(icon.snp.right).offset(10)
                make.centerY.equalToSuperview()
            })
            
            let enterIcon = UIImageView()
            enterIcon.image = UIImage(named: "enter")
            btn.addSubview(enterIcon)
            enterIcon.snp.makeConstraints({ (make) in
                make.right.equalTo(-15)
                make.centerY.equalToSuperview()
                make.width.height.equalTo(20)
            })
            
            if index < titles.count-1 {
                let sepLine = UIView()
                sepLine.backgroundColor = UIColor(rgb: 0xbbbbbb)
                contentView.addSubview(sepLine)
                sepLine.snp.makeConstraints({ (make) in
                    make.left.equalTo(15)
                    make.right.equalTo(-15)
                    make.top.equalTo(btn.snp.bottom)
                    make.height.equalTo(sepLineHeight)
                })
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
