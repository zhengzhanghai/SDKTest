//
//  PayFailureViewController.swift
//  WashingMachine
//
//  Created by zzh on 17/3/9.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

import UIKit

class PayFailureViewController: BaseViewController {
    
    var orderModel: OrderDetailsModel!
    fileprivate var isImmediateUse: Bool = false
    /// 支付成功后，重新请求订单状态，如果状态还是未支付，该变量+1，并重新请求订单状态
    fileprivate var payRequestStatusCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.addOrderFailureView()
        self.addBottomBtn()
        if self.orderModel.orderFrom == 1 {
            isImmediateUse = true
        } else {
            isImmediateUse = false
        }
    }
    
    // 将支付确认页添加到视图上
    fileprivate func addImmediatePayView() {
        self.immediateUseView.refreshUI(payMoney: String(format: "%.02f", (self.orderModel.spend?.floatValue ?? 0)/100.0), typeName: self.orderModel.showedPackageName)
        if orderModel.processPattern == .onewayCommunication {
            let str = self.orderModel.dType == .condensateBeads ? "请在3分钟内完成支付，付款成功后尽快取走商品！" : "请在3分钟内完成支付，获得验证码可启动设备"
            let attstr = NSMutableAttributedString(string: str)
            attstr.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.red],
                                 range: NSMakeRange(2, 3))
            self.immediateUseView.despLabel.attributedText = attstr
        } else {
            let str = "请在3分钟内完成支付，支付成功后洗衣机将自动启动，请确认衣服已放入桶内"
            let attstr = NSMutableAttributedString(string: str)
            attstr.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.red],
                                 range: NSMakeRange(2, 3))
            self.immediateUseView.despLabel.attributedText = attstr
        }
        
        self.immediateUseView.closeClourse = { [weak self] in
            self?.immediateUseView.removeFromSuperViewAnimation(nil)
        }
        self.immediateUseView.payClourse = { [weak self] payWay in
            self?.alipayOrWxPay(payWay, orderWay: .immediated)
        }
        self.immediateUseView.walletBalanceLabel.text = "余额" + UserBalanceManager.share.balanceStr + "元"
        appRootView?.addSubview(self.immediateUseView)
        if let balance = UserBalanceManager.share.balance, let spend = self.orderModel?.spend?.floatValue, balance < spend/100 {
            immediateUseView.choose(payWay: .alipay)
        }
        self.immediateUseView.showAnimation(nil)
    }
    
    // 将支付确认页添加到视图上
    fileprivate func addAppointPayView() {
        self.appointUseView.refreshUI(payMoney: String(format: "%.02f", (self.orderModel.spend?.floatValue ?? 0)/100.0), typeName: self.orderModel.showedPackageName)
        self.appointUseView.closeClourse = { [weak self] in
            self?.appointUseView.removeFromSuperViewAnimation(nil)
        }
        self.appointUseView.payClourse = { [weak self] payWay in
            self?.alipayOrWxPay(payWay, orderWay: .appoint)
        }
        self.appointUseView.walletBalanceLabel.text = "余额" + UserBalanceManager.share.balanceStr + "元"
        appRootView?.addSubview(self.appointUseView)
        if let balance = UserBalanceManager.share.balance, let spend = self.orderModel?.spend?.floatValue, balance < spend/100 {
            appointUseView.choose(payWay: .alipay)
        }
        self.appointUseView.showAnimation(nil)
    }
    
    // 点击确定支付按钮
    fileprivate func alipayOrWxPay(_ payWay: PayWay, orderWay: OrderWay) {
        
        guard IS_FORMAL_PAY else {
            integralPay()
            return
        }
        
        func sendPay() {
            removePayView()
            
            showWaitingView(nc_appdelegate?.window ?? self.view)
            let payMessage = NCPayMessage(order: self.orderModel, payWay: payWay)
            
            NCPayManager.sendPay(payMessage,
                                 businessOrderId: orderModel.id?.stringValue ?? "",
                                 checkBeforeOrder: orderModel.isCheckBeforePay,
                                 { (payResult) in
                                    self.hiddenWaitingView()
                                    
                                    if payWay == .nebula {
                                        UserBalanceManager.share.asynRefreshBalance()
                                        if payResult.type == .success {
                                            DeviceViewModel.pushPaySuccessVC(self.orderModel, self, 1)
                                        } else {
                                            showError(payResult.desp, superView: keyWindow)
                                            DeviceViewModel.pushPayFailureVC(self.orderModel!, self, 1)
                                        }
                                    } else {
                                        // 支付回调
                                        self.dealPayCallBackResult(payResult)
                                    }
                                    
            })
        }
        
        if payWay == .nebula {
            guard let spend = self.orderModel.spend?.floatValue else { return }
            let spendY = spend/100
            
            let isEnoughWallet = (spendY <= (UserBalanceManager.share.balance ?? 0))
            let alertVC = UIAlertController(title:isEnoughWallet ? "确定支付吗" : "亲，您的余额不足",
                                            message:isEnoughWallet ? "钱包消费¥\(spendY.string(decimalPlaces: 2))元,确定支付码？" : "",
                                            preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            let sureAction = UIAlertAction(title:isEnoughWallet ? "确定支付" : "充值", style: .default, handler: { (_) in
                if isEnoughWallet {
                    sendPay()
                } else {
                    self.removePayView()
                    self.pushViewController(StarCoinsRechargeViewController())
                }
            })
            alertVC.addAction(cancelAction)
            alertVC.addAction(sureAction)
            
            self.present(alertVC, animated: true, completion: nil)
        } else {
            sendPay()
        }

    }

    /// 处理支付回调
    ///
    /// - Parameter result: 支付结果
    private func dealPayCallBackResult(_ result: NCPayResult) {
        NCPayManager.dealPayResult(result, self, success: {
            self.orderDetails(true)
        }) { (message) in
            showError(message, superView: self.view)
        }
    }
    
    // 移除支付界面
    fileprivate func removePayView() {
        if isImmediateUse {
            self.immediateUseView.removeFromSuperViewAnimation(nil)
        } else {
            self.appointUseView.removeFromSuperViewAnimation(nil)
        }
    }
    
    fileprivate lazy var immediateUseView:ImmediatedUseView = {
        let view = ImmediatedUseView(frame: CGRect(x: 0, y: 0, width: BOUNDS_WIDTH, height: BOUNDS_HEIGHT))
        return view
    }()
    
    fileprivate lazy var appointUseView:AppointUseView = {
        let view = AppointUseView(frame: CGRect(x: 0, y: 0, width: BOUNDS_WIDTH, height: BOUNDS_HEIGHT))
        return view
    }()
    
    fileprivate func addOrderFailureView() {
        
        let failureIcon = UIImageView(frame: CGRect(x: 0, y: 31, width: 81, height: 81))
        view.addSubview(failureIcon)
        failureIcon.image = UIImage(named: "payError")
        failureIcon.snp.makeConstraints { (make) in
            make.top.equalTo(STATUSBAR_HEIGHT + NAVIGATIONBAR_HEIGHT + 40)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(120)
        }
        
        let payCountLabel = UILabel()
        view.addSubview(payCountLabel)
        payCountLabel.textAlignment = .center
        payCountLabel.textColor = UIColor(rgb: 0x666666)
        payCountLabel.font = font_PingFangSC_Medium(20)
        payCountLabel.text = "支付失败"
        payCountLabel.snp.makeConstraints { (make) in
            make.top.equalTo(failureIcon.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.height.equalTo(28)
        }
    }
    
    fileprivate func addBottomBtn() {
        let btnWidth: CGFloat = 155
        
        let cancelButton = UIButton()
        self.view.addSubview(cancelButton)
        cancelButton.titleLabel?.font = font_PingFangSC_Regular(14)
        cancelButton.setTitle("取消", for: .normal)
        cancelButton.setTitleColor(UIColor(rgb: 0x333333), for: .normal)
        cancelButton.layer.cornerRadius = 20
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor(rgb: 0xDBDBDB).cgColor
        cancelButton.addTarget(self, action: #selector(clickCancel), for: .touchUpInside)
        cancelButton.snp.makeConstraints { (make) in
            make.right.equalTo(view.snp.centerX).offset(-9)
            make.width.equalTo(btnWidth)
            make.height.equalTo(40)
            make.bottom.equalTo(-BOTTOM_SAFE_HEIGHT-12)
        }
        
        let rePayButton = UIButton()
        self.view.addSubview(rePayButton)
        rePayButton.titleLabel?.font = font_PingFangSC_Medium(14)
        rePayButton.setTitle("重新支付", for: .normal)
        rePayButton.backgroundColor = UIColor(rgb: 0x3399FF)
        rePayButton.setTitleColor(.white, for: .normal)
        rePayButton.layer.cornerRadius = 20
        rePayButton.addTarget(self, action: #selector(clickRePay), for: .touchUpInside)
        rePayButton.snp.makeConstraints { (make) in
            make.left.equalTo(view.snp.centerX).offset(9)
            make.bottom.width.height.equalTo(cancelButton)
        }
    }
    
    @objc fileprivate func clickCancel() {
        cancelOrder()
    }
    
    @objc fileprivate func clickRePay() {
        if isImmediateUse {
            addImmediatePayView()
        } else {
            addAppointPayView()
        }
    }
}


//MARK: __________network
extension PayFailureViewController {
    // 获取订单详情
    fileprivate func orderDetails(_ isRefresh: Bool) {
        if self.payRequestStatusCount == 0 {
            self.showWaitingView(keyWindow)
        }
        OrderViewModel.inquiryOrder(orderModel.id?.stringValue ?? "") { (model, message, error) in
            guard let orModel = model else {
                if self.payRequestStatusCount == 7 {
                    self.payRequestStatusCount = 0
                    self.hiddenWaitingView()
                    self.alertSurePrompt(message: message)
                } else {
                    // 没有返回成功状态，重复几次（可能解决服务器与支付平台回调延迟问题以及网络问题）
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1, execute: {
                        self.orderDetails(true)
                    })
                    self.payRequestStatusCount += 1
                }
                return
            }
            self.orderModel = orModel
            switch self.orderModel.status ?? -1 {
            case 0:
                print("")
            case 1,2: // 支付失败,
                if self.payRequestStatusCount == 7 {
                    self.payRequestStatusCount = 0
                    self.hiddenWaitingView()
                } else {
                    // 没有返回成功状态，重复几次（可能解决服务器与支付平台回调延迟问题）
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1, execute: {
                        self.orderDetails(true)
                    })
                    self.payRequestStatusCount += 1
                }
            case 3, 4, 5:
                self.hiddenWaitingView()
                DeviceViewModel.pushPaySuccessVC(self.orderModel,
                                                 self,
                                                 1)
            default:
                self.hiddenWaitingView()
                self.navigationController?.popToRootViewController(animated: false)
            }
        }
    }
    
    // 取消订单
    fileprivate func cancelOrder() {
        self.showWaitingView(nc_appdelegate?.window ?? view, "")
        OrderViewModel.cancel(getUserId(), self.orderModel.orderNo ?? "") { (isSuccess, message) in
            ZZPrint("取消订单: "+message)
            self.hiddenWaitingView()
            if isSuccess {
                postNotication(RefreshOrderListNotifation, nil, nil)
                self.navigationController?.popToRootViewController(animated: true)
                showSucccess("已取消订单", superView: keyWindow)
            } else {
                showError(message, superView: self.view)
            }
        }
    }
    
    fileprivate func integralPay() {
        self.showWaitingView(keyWindow)
        IntegralPayViewModel.pay(self.orderModel, getUserId()) { (isSuccess, message ,error) in
            self.hiddenWaitingView()
            if isSuccess {
                DeviceViewModel.pushPaySuccessVC(self.orderModel,
                                                 self,
                                                 1)
            } else {
                if error != nil {
                    showError(message, superView: self.view, afterHidden: 2)
                } else {
                    DeviceViewModel.pushPayFailureVC(self.orderModel, self, 1)
                }
            }
        }
    }
}


