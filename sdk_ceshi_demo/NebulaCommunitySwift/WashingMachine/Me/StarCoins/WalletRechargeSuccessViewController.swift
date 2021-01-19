//
//  WalletRechargeSuccessViewController.swift
//  WashingMachine
//
//  Created by Harious on 2018/4/9.
//  Copyright © 2018年 Eteclabeteclab. All rights reserved.
//

import UIKit

class WalletRechargeSuccessViewController: BaseViewController {
    /// 充值金额，单位元
    var nebulaCoins: Float = 0
    /// 充值话费人民币。单位元
    var spendRMB: Float = 0
    /// 订单号
    var orderNo: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = BACKGROUNDCOLOR
        self.navigationItem.title = "余额充值"
        
        showWaitingView(self.view)
        UserBalanceManager.share.asynRefreshBalance { (isSuccess, amount) in
            self.hiddenWaitingView()
            self.setUpUI(totalNebulaCoins: amount)
        }
    }
    
    fileprivate func setUpUI(totalNebulaCoins: Float) {
        let contentView = ContentView(nebulaCoins: nebulaCoins, spendRMB: spendRMB, totalNebulaCoins: totalNebulaCoins, orderNo: orderNo)
        contentView.backgroundColor = UIColor.white
        self.view.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
        }
        
        contentView.backWalletClosure = {
            guard let vcs = self.navigationController?.viewControllers else { return }
            guard vcs.count >= 3 else { return }
            self.navigationController?.popToViewController(vcs[vcs.count-3], animated: true)
        }
    }

}


extension WalletRechargeSuccessViewController {
    
    class ContentView: UIView {
        
        var backWalletClosure: (() -> ())?
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        @objc fileprivate func clickBackWallet() {
            backWalletClosure?()
        }
        
        init(nebulaCoins: Float, spendRMB: Float, totalNebulaCoins: Float, orderNo: String) {
            super.init(frame: CGRect.zero)
            
            let successsIcon = UIImageView(image: #imageLiteral(resourceName: "success_green"))
            self.addSubview(successsIcon)
            successsIcon.snp.makeConstraints { (make) in
                make.top.equalTo(30)
                make.centerX.equalToSuperview()
                make.width.height.equalTo(64)
            }
            
            let successLabel = createLabel("充值成功",
                                           textColor: UIColor_0x(0x4a4a4a),
                                           font: font_PingFangSC_Regular(15),
                                           superView: self)
            successLabel.snp.makeConstraints { (make) in
                make.top.equalTo(successsIcon.snp.bottom).offset(20)
                make.centerX.equalToSuperview()
            }
            
            let sepline = UIView()
            sepline.backgroundColor = UIColor_0x(0xe8e8e8)
            self.addSubview(sepline)
            sepline.snp.makeConstraints { (make) in
                make.top.equalTo(successLabel.snp.bottom).offset(35)
                make.left.equalTo(12)
                make.right.equalTo(-12)
                make.height.equalTo(0.5)
            }
            
            let titles = ["充值金额", "支付金额", "当前余额", "订单号"]
            
            for (i, title) in titles.enumerated() {
                let titleLabel = createLabel(title, textColor: UIColor_0x(0x969696), font: font_PingFangSC_Regular(12), superView: self)
                titleLabel.snp.makeConstraints({ (make) in
                    make.top.equalTo(sepline.snp.bottom).offset(5 + CGFloat(i)*25)
                    make.left.equalTo(24)
                })
                
                let valueLabel = createLabel(title, textColor: UIColor_0x(0x969696), font: font_PingFangSC_Regular(12), superView: self)
                valueLabel.snp.makeConstraints({ (make) in
                    make.centerY.equalTo(titleLabel)
                    make.right.equalTo(-24)
                    make.width.lessThanOrEqualTo(BOUNDS_WIDTH*0.65)
                })
                
                switch i {
                case 0:
                    valueLabel.text = nebulaCoins >= 1 ? Int(nebulaCoins).stringValue : nebulaCoins.string(decimalPlaces: 2)
                case 1:
                    valueLabel.text = "¥\(spendRMB.string(decimalPlaces: 2))"
                case 2:
                    valueLabel.text = totalNebulaCoins.string(decimalPlaces: 2)
                case 3:
                    valueLabel.text = orderNo
                default:
                    ZZPrint("")
                }
            }
            
            let backWalletBtn = UIButton(type: .custom)
            backWalletBtn.backgroundColor = UIColor_0x(0xf6f6f6)
            backWalletBtn.setTitle("返回钱包", for: .normal)
            backWalletBtn.setTitleColor(UIColor_0x(0x6d6d6d), for: .normal)
            backWalletBtn.titleLabel?.font = font_PingFangSC_Regular(12)
            backWalletBtn.layer.cornerRadius = 16
            backWalletBtn.layer.borderWidth = 0.5
            backWalletBtn.layer.borderColor = UIColor_0x(0xdddddd).cgColor
            backWalletBtn.addTarget(self, action: #selector(clickBackWallet), for: .touchUpInside)
            self.addSubview(backWalletBtn)
            backWalletBtn.snp.makeConstraints { (make) in
                make.top.equalTo(sepline.snp.bottom).offset(5 + CGFloat(titles.count)*25 + 50)
                make.centerX.equalToSuperview()
                make.width.equalTo(140)
                make.height.equalTo(32)
                make.bottom.equalTo(-33)
            }
        }
        
        
    }
}
