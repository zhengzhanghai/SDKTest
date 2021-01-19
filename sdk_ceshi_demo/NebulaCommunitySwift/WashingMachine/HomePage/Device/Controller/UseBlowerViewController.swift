//
//  UseBlowerViewController.swift
//  WashingMachine
//
//  Created by zzh on 2017/7/13.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

import UIKit

class UseBlowerViewController: BaseViewController {
    
    var contentView: UseBlowerContentView!
    var surePayView: ImmediatedUseView!
    var deviceModel: WashingModel!
    var packages: [PackageModel]!
    var orderModel: OrderDetailsModel?
    /// 支付成功后，重新请求订单状态，如果状态还是未支付，该变量+1，并重新请求订单状态
    fileprivate var payRequestStatusCount: Int = 0
    
    convenience init(_ deviceModel: WashingModel) {
        self.init()
        self.deviceModel = deviceModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = deviceModel.deviceTypeStr
        
        // 获取使用套餐
        self.showWaitingView(self.view)
        DeviceViewModel.loadPackage(self.deviceModel.id?.stringValue ?? "") { (packages, message) in
            self.hiddenWaitingView()
            if let models = packages {
                self.packages = models
                self.configContentView()
            } else {
                showError(message, superView: self.view)
            }
        }
    }
    
    private func configContentView() {
        
        contentView = UseBlowerContentView(deviceModel: self.deviceModel, packages: self.packages)
        // 点击立即使用回调
        contentView.startClourse = { [weak self] index in
            // 业务下单
            self?.showWaitingView(keyWindow)
            OrderViewModel.order(getUserId(),
                                 self?.deviceModel?.id?.stringValue ?? "",
                                 self?.packages[index].id?.stringValue ?? "")
            { (order, message) in
                self?.hiddenWaitingView()
                if let orModel = order {
                    self?.orderModel = orModel
                    // 业务下单成功后,弹出支付弹窗
                    self?.createSurePayView(account: self?.packages[index].spend ?? 0,
                                            toSuperView: appRootView!)
                    self?.surePayView.showAnimation(nil)
                } else {
                    showError(message, superView: self?.view)
                }
            }
        }
        view.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
    }
    
    /// 创建并动画弹出确认支付视图页面
    private func createSurePayView(account: NSNumber, toSuperView: UIView) {
        if surePayView != nil {
            surePayView.removeAllSubView()
            surePayView = nil
        }
        surePayView = ImmediatedUseView()
        let str = deviceModel.deviceType == .condensateBeads ? "请在3分钟内完成支付，付款成功后尽快取走商品！" : "请在3分钟内完成支付，获得验证码可启动设备"
        let attstr = NSMutableAttributedString(string: str)
        attstr.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.red],
                             range: NSMakeRange(2, 3))
        surePayView.despLabel.attributedText = attstr
        // 点击支付弹窗上确认支付后回调闭包
        surePayView.payClourse = { [weak self] payType in
//            self?.surePayView.removeFromSuperViewAnimation(nil)
            self?.goToPay(payType: payType)
        }
        if let balance = UserBalanceManager.share.balance, let spend = self.orderModel?.spend?.floatValue, balance < spend/100 {
            surePayView.choose(payWay: .alipay)
        }
        // 点击支付弹窗上关闭后回调闭包
        surePayView.closeClourse = { [weak self] in
            self?.surePayView.removeFromSuperViewAnimation(nil)
            // 调用取消订单接口
            self?.showWaitingView(keyWindow)
            OrderViewModel.cancel(getUserId(), self?.orderModel?.orderNo ?? "") { (isSuccess, message) in
                self?.hiddenWaitingView()
                postNotication(RefreshOrderListNotifation, nil, nil)
                ZZPrint("取消订单: "+message)
                self?.hiddenWaitingView()
                
                if !isSuccess {
                }
            }
        }
        surePayView.refreshUI(payMoney: (account.floatValue/100).twoDecimalPlaces, typeName: self.orderModel?.showedPackageName ?? "")
        toSuperView.addSubview(surePayView)
        surePayView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        surePayView.showAnimation(nil)
    }
    
    fileprivate func order() {
        
    }
    
    //TODO: 前往支付
    fileprivate func goToPay(payType: PayWay) {
        
        guard IS_FORMAL_PAY else {
            return
        }
        
        func sendPay() {
            self.surePayView.removeFromSuperViewAnimation(nil)
            self.showWaitingView(keyWindow)
            let payMessage = NCPayMessage(order: self.orderModel!, payWay: payType)
            
            NCPayManager.sendPay(payMessage,
                                 businessOrderId: self.orderModel?.id?.stringValue ?? "",
                                 checkBeforeOrder: orderModel?.isCheckBeforePay ?? true,
                                 { (payResult) in
                                    self.hiddenWaitingView()
                                    
                                    if payType == .nebula {
                                        UserBalanceManager.share.asynRefreshBalance()
                                        if payResult.type == .success {
                                            DeviceViewModel.pushPaySuccessVC(self.orderModel, self, 1)
                                        } else {
                                            showError(payResult.desp, superView: keyWindow)
                                            DeviceViewModel.pushPayFailureVC(self.orderModel!, self, 1)
                                        }
                                    } else {
                                        // 支付回调
                                        NCPayManager.dealPayResult(payResult, self, success: {
                                            self.orderDetails()
                                        }) { (message) in
                                            DeviceViewModel.pushPayFailureVC(self.orderModel!, self, 1)
                                            showError(message, superView: self.view)
                                        }
                                    }
                                    
            })
        }
        
        if payType == .nebula {
            guard let spend = self.orderModel?.spend?.floatValue else { return }
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
                    self.surePayView.removeFromSuperViewAnimation(nil)
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
    
    /// 支付成功后，调用此接口查新订单状况
    fileprivate func orderDetails() {
        if self.payRequestStatusCount == 0 {
            self.showWaitingView(keyWindow)
        }
        OrderViewModel.inquiryOrder(self.orderModel?.id?.stringValue ?? "") { (model, message, error) in
            if let orModel = model {
                self.orderModel = orModel
                switch self.orderModel?.status ?? -1 {
                case 0:
                    print("")
                case 1,2: // 支付失败,
                    if self.payRequestStatusCount == 7 {
                        self.hiddenWaitingView()
                        DeviceViewModel.pushPayFailureVC(orModel, self, 1)
                    } else {
                        // 没有返回成功状态，重复几次（可能解决服务器与支付平台回调延迟问题）
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1, execute: {
                            self.orderDetails()
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
            } else {
                if self.payRequestStatusCount == 7 {
                    self.hiddenWaitingView()
                    self.alertSurePrompt(message: message)
                } else {
                    // 没有返回成功状态，重复几次（可能解决服务器与支付平台回调延迟问题以及网络问题）
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1, execute: {
                        self.orderDetails()
                    })
                    self.payRequestStatusCount += 1
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

