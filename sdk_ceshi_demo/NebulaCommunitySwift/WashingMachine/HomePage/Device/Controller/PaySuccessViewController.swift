//
//  PaySuccessViewController.swift
//  WashingMachine
//
//  Created by zzh on 17/3/9.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

import UIKit

class PaySuccessViewController: BaseViewController {

    var order: OrderDetailsModel?
    fileprivate var timer: Timer!
    fileprivate var countDownTime: Int = 3
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.addOrderSuccessView()
        self.addReturnHomeButton()
        self.createTimer()
    }
    
    // 创建进入订单详情页的计时器
    fileprivate func createTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.timerAction), userInfo: nil, repeats: true)
        RunLoop.current.add(self.timer!, forMode: .common)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.destoryTimer()
    }
    
    @objc fileprivate func timerAction() {
        self.countDownTime -= 1
        if self.countDownTime == 0 {
            self.destoryTimer()
            // 进入订单详情页（可能是吹风机，可能是洗衣机）
            self.enterOrderDetails()
        }
    }
    
    // 销毁Timer
    fileprivate func destoryTimer() {
        if self.timer != nil {
            self.timer.invalidate()
            self.timer = nil
        }
    }
    
    fileprivate func addOrderSuccessView() {
        let successIcon = UIImageView()
        view.addSubview(successIcon)
        successIcon.image = UIImage(named: "paySuccess")
        successIcon.snp.makeConstraints { (make) in
            make.top.equalTo(STATUSBAR_ABSOLUTE_HEIGHT+NAVIGATIONBAR_HEIGHT+40)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(120)
        }
        
        let payCountLabel = UILabel()
        view.addSubview(payCountLabel)
        payCountLabel.textAlignment = .center
        payCountLabel.textColor = UIColor(rgb: 0x666666)
        payCountLabel.font = font_PingFangSC_Medium(20)
        payCountLabel.text = String(format: "成功支付%.02f元", (self.order?.spend?.floatValue ?? 0.0)/100.0)
        payCountLabel.snp.makeConstraints { (make) in
            make.top.equalTo(successIcon.snp.bottom).offset(16)
            make.height.equalTo(28)
            make.centerX.equalToSuperview()
        }
        
        let despLabel = UILabel()
        view.addSubview(despLabel)
        despLabel.numberOfLines = 0
        despLabel.textAlignment = .center
        despLabel.textColor = UIColor(rgb: 0xAAAAAA)
        despLabel.font = font_PingFangSC_Regular(14)
        despLabel.snp.makeConstraints { (make) in
            make.top.equalTo(payCountLabel.snp.bottom).offset(16)
            make.left.equalTo(16)
            make.right.equalTo(-16)
        }

        if self.order!.processPattern == .onewayCommunication  {
            if self.order!.dType == .condensateBeads {
                despLabel.text = "洗衣凝珠尽快取走哦！"
            } else {
                despLabel.text = "将“订单详情”中的验证码输入在设备上就可以启动\(self.order?.deviceTypeStr ?? "")呦！"
            }
        } else if order?.isImmediateUse ?? true {
            despLabel.text = "你的洗衣任务已启动，请耐心等待！"
        } else {
            despLabel.text = "带上待洗的衣物，去找到你预定号码的洗衣机吧"
        }
        
        let lookOrderBtn = UIButton()
        view.addSubview(lookOrderBtn)
        lookOrderBtn.titleLabel?.font = font_PingFangSC_Medium(12)
        lookOrderBtn.setTitle("查看订单", for: .normal)
        lookOrderBtn.setTitleColor(UIColor(rgb: 0x3399FF), for: .normal)
        lookOrderBtn.addTarget(self, action: #selector(clickLookOrder), for: .touchUpInside)
        lookOrderBtn.snp.makeConstraints { (make) in
            make.top.equalTo(despLabel.snp.bottom).offset(28)
            make.centerX.equalToSuperview()
            make.height.equalTo(16)
        }
        
        let enterIcon = UIImageView(image: UIImage(named: "enter"))
        enterIcon.tintColor = UIColor(rgb: 0x3399FF)
        view.addSubview(enterIcon)
        enterIcon.snp.makeConstraints { (make) in
            make.left.equalTo(lookOrderBtn.snp.right)
            make.centerY.equalTo(lookOrderBtn)
            make.width.height.equalTo(13)
        }
    }
    
    fileprivate func addReturnHomeButton() {
        let returnHomeButton = UIButton()
        view.addSubview(returnHomeButton)
        returnHomeButton.titleLabel?.font = font_PingFangSC_Regular(14)
        returnHomeButton.setTitle("返回首页", for: .normal)
        returnHomeButton.layer.cornerRadius = 24
        returnHomeButton.layer.borderWidth = 1
        returnHomeButton.layer.borderColor = UIColor(rgb: 0xDBDBDB).cgColor
        returnHomeButton.setTitleColor(UIColor(rgb: 0x333333), for: .normal)
        returnHomeButton.addTarget(self, action: #selector(clickReturnHomeBtn), for: .touchUpInside)
        returnHomeButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-BOTTOM_SAFE_HEIGHT - 16)
            make.width.equalTo(280)
            make.height.equalTo(48)
        }
    }
    
    @objc fileprivate func clickLookOrder() {
        self.enterOrderDetails()
    }
    
    /// 进入订单详情页(可能是吹风机，可能是洗衣机)
    fileprivate func enterOrderDetails() {
        
        if self.order!.processPattern == .onewayCommunication {
            // 当设备类型是通过验证码方式开启
            if self.order!.dType != .condensateBeads && !self.order!.isExistPassword {
                // 如果还没有动态密码，跳转到等待页，等待动态密码刷新
                let waitVC = PaySuccessWaitingViewController()
                waitVC.removeControllerCount = 1
                waitVC.order = self.order
                self.pushViewController(waitVC)
            } else {
                // 如果已经有了动态密码直接跳转到订单详情页
                let blowerOrderVC = BlowerOrderDetailsViewController(orderId: self.order?.id?.stringValue ?? "")
                blowerOrderVC.removeControllerCount = 1
                blowerOrderVC.hidesBottomBarWhenPushed = true
                self.pushViewController(blowerOrderVC)
            }
        } else {
            // 设备类型是自动开启
            let orderDetailVC = DealDetailViewController()
            orderDetailVC.orderId = self.order?.id
            orderDetailVC.hidesBottomBarWhenPushed = true
            orderDetailVC.removeControllerCount = 1
            self.navigationController?.pushViewController(orderDetailVC, animated: true)
        }
    }
    
    @objc fileprivate func clickReturnHomeBtn() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    deinit {
        self.destoryTimer()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

}
