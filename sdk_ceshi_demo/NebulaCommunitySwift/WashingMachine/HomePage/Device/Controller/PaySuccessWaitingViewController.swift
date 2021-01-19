//
//  PaySuccessWaitingViewController.swift
//  WashingMachine
//
//  Created by Harious on 2017/12/21.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

import UIKit
import SwiftGifOrigin

class PaySuccessWaitingViewController: BaseViewController {

    var order: OrderDetailsModel?
    var timer: Timer?
    var isCanRequest: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.makeUI()
        self.makeTimer()
    }

    fileprivate func makeTimer() {
        timer = Timer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: .common)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
        self.timer?.invalidate()
        self.timer = nil
    }
    
    @objc fileprivate func timerAction() {
        guard self.isCanRequest else {
            return
        }
        self.isCanRequest = false
        OrderViewModel.inquiryOrder(self.order?.id?.stringValue ?? "") { (order, message, error) in
            self.isCanRequest = true
            guard let orderModel = order else {
                return
            }
            if orderModel.isExistPassword {
                
                self.timer?.invalidate()
                self.timer = nil
                
                let blowerOrderVC = BlowerOrderDetailsViewController(orderId: orderModel.id?.stringValue ?? "")
                blowerOrderVC.removeControllerCount = 1
                blowerOrderVC.hidesBottomBarWhenPushed = true
                self.pushViewController(blowerOrderVC)
            }
        }
    }
    
    fileprivate func makeUI() {
        let waitView = UIImageView()
        waitView.loadGif(name: "wait")
        self.view.addSubview(waitView)
        waitView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(waitView.snp.width).multipliedBy(493.0/658.0)
        }
        
        let waitLabel = UILabel()
        waitLabel.text = "请勿离开，验证码获取中..."
        waitLabel.numberOfLines = 0
        waitLabel.textAlignment = .center
        waitLabel.font = UIFont.systemFont(ofSize: 16)
        self.view.addSubview(waitLabel)
        waitLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.equalTo(waitView.snp.bottom).offset(15)
        }
        
        let waitLabel1 = UILabel()
        waitLabel1.text = "等待跳转中"
        waitLabel1.numberOfLines = 0
        waitLabel1.textAlignment = .center
        waitLabel1.layer.cornerRadius = 7
        waitLabel1.textColor = UIColor_0x(0xaaaaaa)
        waitLabel1.layer.borderColor = UIColor_0x(0xcccccc).cgColor
        waitLabel1.layer.borderWidth = 0.5
        waitLabel1.clipsToBounds = true
        waitLabel1.font = UIFont.boldSystemFont(ofSize: 18)
        self.view.addSubview(waitLabel1)
        waitLabel1.snp.makeConstraints { (make) in
            make.bottom.equalTo(-20)
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.height.equalTo(50)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
