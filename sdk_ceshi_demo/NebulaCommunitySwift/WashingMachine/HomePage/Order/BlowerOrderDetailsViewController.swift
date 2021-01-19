//
//  BlowerOrderDetailsViewController.swift
//  WashingMachine
//
//  Created by zzh on 2017/7/24.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

import UIKit

class BlowerOrderDetailsViewController: BaseViewController {
    fileprivate var contentView: BlowerOrderDetailsContentView?
    fileprivate var orderId: String!
    fileprivate var orderModel: OrderDetailsModel?
    fileprivate var surePayView: ImmediatedUseView?
    /// 支付成功后，重新请求订单状态，如果状态还是未支付，该变量+1，并重新请求订单状态
    fileprivate var payRequestStatusCount = 0
    
    ///之行广告平台广告视图
    fileprivate lazy var bannerADSView: BannerADSView = {
        let view = BannerADSView()
        return view
    }()
    
    convenience init(orderId: String) {
        self.init()
        self.orderId = orderId
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "订单详情"
        view.backgroundColor = BACKGROUNDCOLOR
        self.loadOrderDetails()
        addNoticationObserver(self, #selector(applicationWillEnterForeground), UIApplication.willEnterForegroundNotification, nil)
        loadAndShowCurrentPageADS()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor = BACKGROUNDCOLOR
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.barTintColor = .white
    }
    
    // 添加或者移除导航栏右边的按钮
    fileprivate func addOrRemoveNaviBtn(isAdd: Bool) {
        if !isAdd {
            self.navigationItem.rightBarButtonItem = nil
        } else {
            
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "three_point_white"), style: .plain, target: self, action: #selector(clickNaviRightBtn))
        }
    }
    
    //MARK: ------ ➡️ ----- 点击导航栏右上角按钮 ------------------
    @objc func clickNaviRightBtn() {
        let alertVC = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let refundAction = UIAlertAction(title: "申请退款", style: .default) { (action) in
            self.showWaitingView(keyWindow)
            NetworkEngine.get(API_GET_ORDER_REFUND_CHECK, parameters: ["orderId": self.orderId ?? ""], completionClourse: { (result) in
                self.hiddenWaitingView()
                if result.isSuccess {
                    let vc = RefundResonViewController()
                    vc.orderId = self.orderId
                    vc.hidesBottomBarWhenPushed = true
                    vc.isNeedImage = self.orderModel?.isNeedImageWhenRefund ?? false
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    showError(result.message, superView: self.view, afterHidden: 3)
                }
            })
        }
        alertVC.addAction(cancelAction)
        alertVC.addAction(refundAction)
        self.present(alertVC, animated: true) {
            
        }
    }
    
    /// 当从后台进入前台，刷新订单页
    @objc fileprivate func applicationWillEnterForeground() {
        self.loadOrderDetails()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !self.isFirstViewDidAppear {
            self.loadOrderDetails()
        }
    }
    
    func makeContentView(_ order: OrderDetailsModel) {
        if self.contentView != nil {
            self.contentView?.removeFromSuperview()
            self.contentView = nil
        }
        self.contentView = BlowerOrderDetailsContentView(order: order)
        // 倒计时结束回调
        self.contentView?.endCountDownClourse = { [weak self] in
            self?.loadOrderDetails()
        }
        // 点击底部按钮回调
        self.contentView?.bottomBtnActionClourse = { [unowned self] action in
            switch action {
            case .cancel:
                ZZPrint("取消")
            case .cancelOrder:
                ZZPrint("去取消订单")
                self.promptCancelOrder()
            case .backHome:
                ZZPrint("回到首页")
                self.navigationController?.popToRootViewController(animated: true)
            case .startWork:
                ZZPrint("启动, 理论上吹风机不会出现，如果出现就是BUG")
            case .pay:
                ZZPrint("去支付")
                self.makeAndPopSurePayView()
            case .applyRefund:
                ZZPrint("申请退款, 进入到退款界面")
                let vc = RefundResonViewController()
                vc.orderId = self.orderId
                vc.hidesBottomBarWhenPushed = true
                vc.isNeedImage = self.orderModel?.isNeedImageWhenRefund ?? false
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        // 点击退款图片回调
        self.contentView?.didSelectedRefundImageClourse = { [weak self] (index, imageViews) in
            ZZPrint("点击了第\(index)张退款图片")
            let vc = PhotoBrowser(showByViewController: self!, delegate: self!)
            vc.pageControlDelegate = PhotoBrowserDefaultPageControlDelegate(numberOfPages: self?.orderModel?.refundImageModels?.count ?? 0)
            vc.show(index: index)
        }
        self.view.insertSubview(contentView!, at: 0)
        self.contentView?.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
    }
    
    /// 创建并弹出确认支付视图
    fileprivate func makeAndPopSurePayView() {
        if self.surePayView != nil {
            self.surePayView?.removeAllSubView()
            self.surePayView = nil
        }
        self.surePayView = ImmediatedUseView()
        let str = self.orderModel!.dType == .condensateBeads ? "请在3分钟内完成支付，付款成功后尽快取走商品！" : "请在3分钟内完成支付，获得验证码可启动设备"
        let attstr = NSMutableAttributedString(string: str)
        attstr.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.red],
                             range: NSMakeRange(2, 3))
        self.surePayView?.despLabel.attributedText = attstr
        self.surePayView?.refreshUI(payMoney: String(format: "%.02f", (self.orderModel?.spend?.floatValue)!/100.0), typeName: self.orderModel?.showedPackageName ?? "")
        // 弹出的确认支付视图关闭按钮点击回调
        self.surePayView?.closeClourse = { [weak self] in
            // 移除确认支付页面
            self?.surePayView?.removeFromSuperViewAnimation(nil)
        }
        // 弹出的确认支付视图确认支付按钮点击回调
        self.surePayView?.payClourse = { [weak self] payWay in
            // 去支付
            self?.alipayOrWxPay(payWay, orderWay: .immediated)
        }
        appRootView?.addSubview(self.surePayView!)
        if let balance = UserBalanceManager.share.balance, let spend = self.orderModel?.spend?.floatValue, balance < spend/100 {
            surePayView?.choose(payWay: .alipay)
        }
        self.surePayView?.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        self.surePayView?.showAnimation(nil)
    }
    
    /// 点击弹出的确认支付页面的确认支付按钮
    fileprivate func alipayOrWxPay(_ payWay: PayWay, orderWay: OrderWay) {
        
        guard IS_FORMAL_PAY else {
            // 使用积分支付
            self.showWaitingView(keyWindow)
            IntegralPayViewModel.pay(self.orderModel ?? OrderDetailsModel(), getUserId()) { (isSuccess, message, error) in
                self.hiddenWaitingView()
                if isSuccess {
                    DeviceViewModel.pushPaySuccessVC(self.orderModel,
                                                     self,
                                                     1)
                } else {
                    if error != nil {
                        showError(message, superView: self.view, afterHidden: 2)
                    } else {
                        DeviceViewModel.pushPayFailureVC(self.orderModel ?? OrderDetailsModel(), self, 1)
                    }
                }
            }
            return
        }
        
        func sendPay() {
            self.surePayView?.removeFromSuperViewAnimation(nil)
            // 使用微信支付宝支付或者星币支付
            self.showWaitingView(nc_appdelegate?.window ?? self.view)
            let payMessage = NCPayMessage(order: self.orderModel!, payWay: payWay)
            
            NCPayManager.sendPay(payMessage,
                                 businessOrderId: orderId,
                                 checkBeforeOrder: orderModel?.isCheckBeforePay ?? true,
                                 { (payResult) in
                                    // 支付回调
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
                                        // 处理支付回调
                                        NCPayManager.dealPayResult(payResult, self, success: {
                                            // 回调结果成功,再去查看订单状态是否改变
                                            self.loadOrderDetails(isPayCheck: true)
                                        }) { (message) in
                                            DeviceViewModel.pushPayFailureVC(self.orderModel ?? OrderDetailsModel(), self)
                                        }
                                    }
            })
        }
        
        if payWay == .nebula {
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
                    self.surePayView?.removeFromSuperViewAnimation(nil)
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
    
    /// 获取订单详情
    fileprivate func loadOrderDetails(isPayCheck: Bool = false) {
        if !isPayCheck {
            self.showWaitingView(keyWindow)
        } else if self.payRequestStatusCount == 0 {
            self.showWaitingView(keyWindow)
        }
        OrderViewModel.inquiryOrder(orderId) { (model, message, error) in
            guard let orModel = model else {
                
                if !isPayCheck {
                    self.hiddenWaitingView()
                    showError(message, superView: self.view, afterHidden: 2.5)
                    self.contentView?.removeFromSuperview()
                    return
                }
                // 如果是支付后刷新订单状态
                if self.payRequestStatusCount == 7 {
                    self.payRequestStatusCount = 0
                    self.hiddenWaitingView()
                    self.alertSurePrompt(message: message)
                } else {
                    // 没有返回成功状态，重复几次（可能解决服务器与支付平台回调延迟问题以及网络问题）
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1, execute: {
                        self.loadOrderDetails(isPayCheck: isPayCheck)
                    })
                    self.payRequestStatusCount += 1
                }
                return
            }
            
            if self.orderModel?.status != orModel.status {
                // 如果订单状态改变，刷新当前页面
                self.makeContentView(orModel)
            }
            
            self.orderModel = orModel
            
            // 添加或者移除导航栏右侧的按钮(通过是否允许退款判断)
            self.addOrRemoveNaviBtn(isAdd: orModel.isAllowRefund)
            
            if !isPayCheck {
                // 如果不是支付刷新，重置removeControllerCount，隐藏加载等待视图,不再往下面执行
                self.hiddenWaitingView()
                self.removeControllerCount = 0
                return
            }
            
            // 如果是支付刷新才往下面执行
            switch orModel.status ?? -1 {
            case 0:
                print("")
            case 1,2: // 支付失败,
                if self.payRequestStatusCount == 7 {
                    self.payRequestStatusCount = 0
                    self.hiddenWaitingView()
                    DeviceViewModel.pushPayFailureVC(orModel, self, 1)
                } else {
                    // 没有返回成功状态，重复几次（可能解决服务器与支付平台回调延迟问题）
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1, execute: {
                        self.loadOrderDetails(isPayCheck: isPayCheck)
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
    
    /// 弹出取消订单提示
    fileprivate func promptCancelOrder() {
        let alertVC = UIAlertController(title: "提示", message: "确定取消订单吗？", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .default, handler: nil)
        let sureAction = UIAlertAction(title: "确定", style: .destructive, handler: { (_) in
            self.cancelOrder()
        })
        alertVC.addAction(cancelAction)
        alertVC.addAction(sureAction)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    /// 取消订单
    fileprivate func cancelOrder() {
        self.showWaitingView(nc_appdelegate?.window ?? self.view)
        OrderViewModel.cancel(getUserId(), orderModel?.orderNo ?? "", { (isSuccess, message) in
            self.hiddenWaitingView()
            if isSuccess {
                postNotication(RefreshOrderListNotifation, nil, nil)
                ZZPrint("取消订单："+message)
                showSucccess("取消订单成功", superView: keyWindow)
                self.navigationController?.popViewController(animated: true)
            } else {
                showError(message, superView: self.view, afterHidden: 2)
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

//MARK:  *********  PhotoBrowserDelegate  **********
extension BlowerOrderDetailsViewController: PhotoBrowserDelegate {
    func numberOfPhotos(in photoBrowser: PhotoBrowser) -> Int {
        return self.orderModel?.refundImageModels?.count ?? 0
    }
    
    /// 缩放起始视图
    func photoBrowser(_ photoBrowser: PhotoBrowser, thumbnailViewForIndex index: Int) -> UIView? {
        return self.contentView?.refundImageViews[index]
    }
    
    /// 图片加载前的placeholder
    func photoBrowser(_ photoBrowser: PhotoBrowser, thumbnailImageForIndex index: Int) -> UIImage? {
        return self.contentView?.refundImageViews[index].image
    }
    
    /// 高清图
    func photoBrowser(_ photoBrowser: PhotoBrowser, highQualityUrlForIndex index: Int) -> URL? {
        return URL(string: (self.orderModel?.refundImageModels?[index].url ?? ""))
    }
    
    /// 长按图片
    func photoBrowser(_ photoBrowser: PhotoBrowser, didLongPressForIndex index: Int, image: UIImage) {
    }
}

//MARK: 广告相关
extension BlowerOrderDetailsViewController {
  
    /// 加载并展示首页横幅广告
    func loadAndShowCurrentPageADS() {
        
        ADSManager.getADSList(ADSID: ADSManager.orderID, pageKeywords: "社区", adsSize: CGSize(width: 640, height: 100)) { (adses) in
            guard let adsModel = adses.first else {return}
            
            self.bannerADSView.set(adsModel.image, adsModel.title, adsModel.desc)
            self.view.addSubview(self.bannerADSView)
            self.bannerADSView.snp.makeConstraints { (make) in
                make.bottom.equalTo(-BOTTOM_SAFE_HEIGHT - 66)
                make.centerX.equalToSuperview()
                make.width.equalTo(320)
                make.height.equalTo(50)
            }
            
            self.bannerADSView.touchSelfClosure = { [weak self] point in
                ADSManager.onClick(adsModel: adsModel, vc: self!, tapPoint: point, adsSize: CGSize(width: 640, height: 100))
            }
            self.bannerADSView.clickCloseClosure = { [weak self] in
                self?.bannerADSView.removeFromSuperview()
            }
            
            ADSManager.reportAfterShowed(adsModel: adsModel)
        }
    }
}

