//
//  WashingDetailsViewController.swift
//  WashingMachine
//
//  Created by zzh on 17/3/7.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

import UIKit

// 支付方式（微信、支付宝等）
public enum PayWay : Int {
    case nebula  // 余额支付
    case wx      // 微信支付
    case alipay  // 支付宝支付
}
// 下单方式（预约或立即支付）
public enum OrderWay : Int {
    case appoint
    case immediated
}

let RePayNotifation = "rePayNotifation"

class WashingDetailsViewController: BaseViewController {

    var machineModel: WashingModel?
    var bottomButtonView: AppointAndPayView!
    /** 洗衣套餐 */
    fileprivate lazy var packageArray = [PackageModel]()
    /** 订单详情 */
    fileprivate var orderModel: OrderDetailsModel!

    fileprivate var isImmediateUse: Bool = false // 是立即使用还是预约使用
    /// 支付成功后，重新请求订单状态，如果状态还是未支付，该变量+1，并重新请求订单状态
    fileprivate var payRequestStatusCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = BACKGROUNDCOLOR
        self.navigationItem.title = "洗衣"
        
        self.addSubView()
        self.washingPackage(machineModel?.id?.stringValue ?? "")
        
        if #available(iOS 11.0, *) {
            self.additionalSafeAreaInsets = UIEdgeInsets(top: 20, left: 0, bottom: 100, right: 0)
        }
    }
    
    fileprivate func addSubView() {
        self.addTopBgView()
        self.addBottomButtomView()
        self.view.addSubview(self.machineBaseView)
        self.view.addSubview(self.washingChooseView)
        self.machineBaseView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
        }
        self.washingChooseView.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.top.equalTo(self.machineBaseView.snp.bottom).offset(16)
            make.width.equalTo(BOUNDS_WIDTH-32)
        }
        
        if machineModel != nil {
            machineBaseView.refreshUI(model: machineModel!)
        }
    }
    
    fileprivate lazy var machineBaseView: WashingMachineBaseView = {
        return WashingMachineBaseView()
    }()
    
    fileprivate lazy var washingChooseView: DetailsChoosePatternView = { [unowned self] in
        let view = DetailsChoosePatternView(frame: CGRect(x: 16, y: self.machineBaseView.frame.maxY+5, width: BOUNDS_WIDTH-32, height: 80))
        return view
    }()
    
    fileprivate func addTopBgView() {
        let blueView = UIView(frame: CGRect(x: 0, y: 0, width: BOUNDS_WIDTH, height: 30))
        blueView.backgroundColor = .white
        self.view.addSubview(blueView)
    }
    
    fileprivate func addBottomButtomView() {
        bottomButtonView = AppointAndPayView()
        self.view.addSubview(bottomButtonView)
        bottomButtonView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.width.equalTo(BOUNDS_WIDTH)
            make.height.equalTo(64 + BOTTOM_SAFE_HEIGHT)
            make.bottom.equalToSuperview()
        }
        bottomButtonView.appointOrPayClourse = { [weak self] index in
            self?.appointOrPay(index: index)
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
    
    // 点击预约或立即支付
    fileprivate func appointOrPay(index: Int) {
        if index == 0 {
            self.isImmediateUse = false
            self.appointment()
        } else if index == 1 {
            self.isImmediateUse = true
            self.order()
        }
    }
    
    // 立即下单成功后，将支付确认页添加到视图上
    fileprivate func addImmediatePayView() {
        self.immediateUseView.refreshUI(payMoney: String(format: "%.02f", (self.orderModel.spend?.floatValue ?? 0)/100.0), typeName:self.orderModel.showedPackageName)
        self.immediateUseView.closeClourse = { [weak self] in
            self?.immediateUseView.removeFromSuperViewAnimation(nil)
            self?.cancelOrder()
        }
        self.immediateUseView.payClourse = { [weak self] payWay in
            self?.alipayOrWxPay(payWay, orderWay: .immediated)
        }
        self.immediateUseView.walletBalanceLabel.text = "余额" + UserBalanceManager.share.balanceStr + "元"
        appRootView?.addSubview(self.immediateUseView)
        if let balance = UserBalanceManager.share.balance, let spend = self.orderModel.spend?.floatValue, balance < spend/100 {
            immediateUseView.choose(payWay: .alipay)
        }
        self.immediateUseView.showAnimation(nil)
    }
    
    // 预约下单成功后，将支付确认页添加到视图上
    fileprivate func addAppointPayView() {
        self.appointUseView.refreshUI(payMoney: String(format: "%.02f", (self.orderModel.spend?.floatValue ?? 0)/100.0), typeName: self.orderModel.showedPackageName)
        self.appointUseView.closeClourse = { [weak self] in
            self?.appointUseView.removeFromSuperViewAnimation(nil)
            self?.cancelOrder()
        }
        self.appointUseView.payClourse = { [weak self] payWay in
            self?.alipayOrWxPay(payWay, orderWay: .appoint)
        }
        self.appointUseView.walletBalanceLabel.text = "余额" + UserBalanceManager.share.balanceStr + "元"
        appRootView?.addSubview(self.appointUseView)
        if let balance = UserBalanceManager.share.balance, let spend = self.orderModel.spend?.floatValue, balance < spend/100 {
            appointUseView.choose(payWay: .alipay)
        }
        self.appointUseView.showAnimation(nil)
    }

    fileprivate lazy var immediateUseView:ImmediatedUseView = {
        let view = ImmediatedUseView(frame: CGRect(x: 0, y: 0, width: BOUNDS_WIDTH, height: BOUNDS_HEIGHT))
        return view
    }()
    
    fileprivate lazy var appointUseView:AppointUseView = {
        let view = AppointUseView(frame: CGRect(x: 0, y: 0, width: BOUNDS_WIDTH, height: BOUNDS_HEIGHT))
        return view
    }()
    
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
                                            DeviceViewModel.pushPayFailureVC(self.orderModel, self, 1)
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
            DeviceViewModel.pushPayFailureVC(self.orderModel, self, 1)
            showError(message, superView: self.view)
        }
    }
    
    // 获取当前支付页面（确保在弹出确认支付页面调用）
    fileprivate func currenPayView() -> UIView {
        if isImmediateUse {
            return self.immediateUseView
        } else {
            return self.appointUseView
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension WashingDetailsViewController {
    // 获取订单详情
    fileprivate func orderDetails(_ isRefresh: Bool) {
        if self.payRequestStatusCount == 0 {
            self.showWaitingView(keyWindow)
        }
        OrderViewModel.inquiryOrder(orderModel.id?.stringValue ?? "") { (model, message, error) in
            if let orModel = model {
                self.orderModel = orModel
                switch self.orderModel.status ?? -1 {
                case 0:
                    print("")
                case 1,2: // 支付失败,
                    if self.payRequestStatusCount == 7 {
                        self.hiddenWaitingView()
                        DeviceViewModel.pushPayFailureVC(orModel, self, 1)
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
            } else {
                if self.payRequestStatusCount == 7 {
                    self.hiddenWaitingView()
                    self.alertSurePrompt(message: message)
                } else {
                    // 没有返回成功状态，重复几次（可能解决服务器与支付平台回调延迟问题以及网络问题）
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1, execute: {
                        self.orderDetails(true)
                    })
                    self.payRequestStatusCount += 1
                }
            }
        }
    }

    // 获取洗衣方式列表
    fileprivate func washingPackage(_ productId: String) {
        self.showWaitingView(self.view)
        DeviceViewModel.loadPackage(productId) { (packages, message) in
            self.hiddenWaitingView()
            if let models = packages {
                self.packageArray = models
                self.washingChooseView.configUI(self.packageArray)
            }
        }
    }
    
    // 业务下单
    fileprivate func order() {
        if !isLogin() {
            showError("请先登录", superView: self.view)
            return
        }
        if machineModel == nil {
            return
        }
        if packageArray.count == 0 {
            return
        }
        self.showWaitingView(appRootView ?? self.view)
        OrderViewModel.order(getUserId(), machineModel?.id?.stringValue ?? "", washingChooseView.currentPackageId()) { (order, message) in
            self.hiddenWaitingView()
            if let orModel = order {
                self.orderModel = orModel
                self.addImmediatePayView()
            } else {
                showError(message, superView: self.view)
            }
        }
    }
    
    // 预约
    fileprivate func appointment() {
        if !isLogin() {
            showError("请先登录", superView: self.view)
            return
        }
        if machineModel == nil {
            return
        }
        if packageArray.count == 0 {
            return
        }
        self.showWaitingView(appRootView ?? self.view)
        OrderViewModel.appointOrder(getUserId(), machineModel?.id?.stringValue ?? "", washingChooseView.currentPackageId()) { (order, message) in
            self.hiddenWaitingView()
            if let orModel = order {
                self.orderModel = orModel
                self.addAppointPayView()
            } else {
                showError(message, superView: self.view)
            }
        }
    }
    
    fileprivate func integralPay() {
        self.showWaitingView(keyWindow)
        IntegralPayViewModel.pay(self.orderModel, getUserId()) { (isSuccess, message, error) in
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
    
    // 取消订单
    fileprivate func cancelOrder() {
        self.showWaitingView(nc_appdelegate?.window ?? view, "")
        OrderViewModel.cancel(getUserId(), self.orderModel.orderNo ?? "") { (isSuccess, message) in
            postNotication(RefreshOrderListNotifation, nil, nil)
            ZZPrint("取消订单: "+message)
            self.hiddenWaitingView()
            if !isSuccess {
                
            }
        }
    }
}
