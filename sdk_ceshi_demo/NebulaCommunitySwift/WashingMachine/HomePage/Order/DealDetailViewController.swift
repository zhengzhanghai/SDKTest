//
//  DealDetailViewController.swift
//  WashingMachine
//
//  Created by 张丹丹 on 16/12/20.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

import UIKit
import Kingfisher

let RefreshOrderListNotifation = "RefreshOrderListNotifation"
/// 是否已经关闭详情页的广告
var isClosedDetailsAds = false

class DealDetailViewController: BaseViewController {
    
    var orderId:NSNumber?         //将订单id传过来获取订单详情
    // 新的UI控件
    var bgView: UIView!
    var titleLabel: UILabel!
    var moneyLabel: UILabel!
    var orderTimeLabel: UILabel!
    var orderNoLabel: UILabel!
    var refuseTitleLabel: UILabel!
    var refuseReasonLabel: UILabel!
    var refundTitleLabel: UILabel!
    var refundReasonLabel: UILabel!
    var codeTitleLabel: UILabel!
    var codeValueLabel: UILabel!
    var buttonBgView: UIView!
    var imageBGView: UIView?
    var contentScrollView: UIView?
    
    var orderModel: OrderDetailsModel?
    /// 广告model
    var adsModel: ADSModel?
    
    fileprivate var countDownTime: Int = 0
    /// 支付成功后，重新请求订单状态，如果状态还是未支付，该变量+1，并重新请求订单状态
    fileprivate var payRequestStatusCount = 0
    fileprivate let timerMargin:TimeInterval = 1.0
    var timer:Timer? = nil
    var differTime:Int = 0
    
    /// 用来记录订单进行中，设备空闲时的倒计时时间
    var reStartCountDown: Int = 10
    /// 订单进行中，设备空闲时，用来可点击立即启动的倒计时
    lazy var reStartTimer: Timer = {
        let timer = Timer(fireAt: Date.distantFuture,
                          interval: 1,
                          target: self,
                          selector: #selector(reStartTimerAction),
                          userInfo: nil,
                          repeats: true)
        RunLoop.current.add(timer, forMode: .common)
        return timer
    }()
    
    /// 订单状态icon
    lazy var stateIcon: UIImageView = {
        return UIImageView()
    }()
    /// 订单状态label
    lazy var statusLabel: UILabel = {
        return UILabel.create(font: font_PingFangSC_Medium(18),
                              textColor: UIColor(rgb: 0x333333))
    }()
    /// 背景设备视图
    lazy var deviceBGImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "order_device_bg")
        return imageView
    }()
    
    fileprivate var imageViews: [UIImageView] = [UIImageView]()
    
    /// 广告的视图
    fileprivate lazy var adsView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.clipsToBounds = true
        
        let closeBtn = UIButton(type: .custom)
        closeBtn.setImage(#imageLiteral(resourceName: "close_black"), for: .normal)
        closeBtn.addTarget(self, action: #selector(closeAdsView(_:)), for: .touchUpInside)
        imageView.addSubview(closeBtn)
        closeBtn.snp.makeConstraints({ (make) in
            make.top.right.equalToSuperview()
            make.width.height.equalTo(30)
        })
        
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickAdsGesture(_:))))
        return imageView
    }()
    
    ///之行广告平台广告视图
    fileprivate lazy var bannerADSView: BannerADSView = {
        let view = BannerADSView()
        return view
    }()
    
    @objc fileprivate func closeAdsView(_ btn: UIButton) {
        animateRemoveAdsView()
    }
    
    /// 动画移除广告
    fileprivate func animateRemoveAdsView() {
        isClosedDetailsAds = true
        self.adsView.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.5, animations: {
            self.adsView.alpha = 0
        }) { (_) in
            self.adsView.removeFromSuperview()
            self.adsView.isUserInteractionEnabled = true
        }
    }
    
    @objc fileprivate func clickAdsGesture(_ tap: UITapGestureRecognizer) {
        animateRemoveAdsView()
        
        let adsWebVC = AdsWebViewController()
        adsWebVC.titleStr = self.adsModel?.name ?? ""
        adsWebVC.urlStr = self.adsModel?.redirectAddress ?? ""
        self.pushViewController(adsWebVC)
    }
    
    /// 订单进行中，设备空闲时，立即启动的倒计时响应
    @objc fileprivate func reStartTimerAction() {
        self.reStartCountDown -= 1
        self.reStartCountDownLabel.text = String(format: "启动中，剩余 00:%02d",reStartCountDown)
        
        if self.reStartCountDown == 0 {
            self.reStartTimer.fireDate = Date.distantFuture
            self.loadOrderDetails()
        }
    }
    
    fileprivate func addOrRemoveNaviBtn(isAdd: Bool) {
        if !isAdd {
            self.navigationItem.rightBarButtonItem = nil
        } else {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "three_point_white"), style: .plain, target: self, action: #selector(clickNaviRightBtn))
        }
    }
    
    @objc func clickNaviRightBtn() {
        let alertVC = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let refundAction = UIAlertAction(title: "申请退款", style: .default) { (action) in
            self.showWaitingView(keyWindow)
            NetworkEngine.get(API_GET_ORDER_REFUND_CHECK, parameters: ["orderId": "\(self.orderId ?? 0)"], completionClourse: { (result) in
                self.hiddenWaitingView()
                if result.isSuccess {
                    self.enterRefund()
                } else {
                    showError(result.message, superView: self.view)
                }
            })
        }
        alertVC.addAction(cancelAction)
        alertVC.addAction(refundAction)
        self.present(alertVC, animated: true) {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "订单详情"
        self.view.backgroundColor = BACKGROUNDCOLOR
        self.initUI()
        self.loadOrderDetails()
        // 监听倒计时文本变化，去重新约束上面视图
        self.countDownTimerLabel.addObserver(self, forKeyPath: "attributedText", options: .new, context: nil)
        self.countDownTimerLabel.addObserver(self, forKeyPath: "text", options: .new, context: nil)
        
        self.loadAndShowCurrentPageADS()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor = BACKGROUNDCOLOR
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.barTintColor = .white
    }
    
    /// 监听倒计时文本变化，去重新约束上面视图
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let path = keyPath else {
            return
        }
        guard path == "text" || path == "attributedText" else {
            return
        }
        guard contentScrollView?.superview != nil else {
            return
        }
        if countDownTimerLabel.superview != nil && countDownTimerLabel.attributedText != nil {
            contentScrollView?.snp.remakeConstraints({ (make) in
                make.top.left.right.equalToSuperview()
                make.bottom.equalTo(countDownTimerLabel.snp.top).offset(-10)
            })
        } else {
            contentScrollView?.snp.remakeConstraints({ (make) in
                make.top.left.right.equalToSuperview()
                make.bottom.equalTo(-60)
            })
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !isFirstViewDidAppear {
            self.loadOrderDetails()
        }
    }
    
    deinit {
        countDownTimerLabel.removeObserver(self, forKeyPath: "attributedText", context: nil)
        countDownTimerLabel.removeObserver(self, forKeyPath: "text", context: nil)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        if parent == nil {
            timer?.invalidate()
            timer = nil
            self.reStartTimer.invalidate()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func timerAction() {
        countDownTime = countDownTime - 1000
        if countDownTime <= 0 {
            timer?.invalidate()
            timer = nil
            //预约开启洗衣机的倒计时结束，只能申请退款，不能再开启
            if self.orderModel?.status == 3 {
                let attstr = NSMutableAttributedString(string: "已超时,不能开启洗衣机")
                attstr.addAttributes([NSAttributedString.Key.foregroundColor: UIColor(rgb: 0xFF7733)],
                                     range: NSMakeRange(0, 3))
                self.countDownTimerLabel.attributedText = attstr
                self.bottomRightBtn.isEnabled = false
//                self.bottomRightBtn.backgroundColor = GREENCOLOR.withAlphaComponent(0.5)
            } else if self.orderModel?.status == 1 || self.orderModel?.status == 2 {
                let attstr = NSMutableAttributedString(string: "已超时,不能继续支付")
                attstr.addAttributes([NSAttributedString.Key.foregroundColor: UIColor(rgb: 0xFF7733)],
                                     range: NSMakeRange(0, 3))
                self.countDownTimerLabel.attributedText = attstr
                self.bottomRightBtn.isEnabled = false
//                self.bottomRightBtn.backgroundColor = GREENCOLOR.withAlphaComponent(0.5)
            }
            self.loadOrderDetails()
            return
        }
        
        if self.orderModel?.status == 3 {
            let timeString = calculTimeString()
            let str = String(format: "请在%@内启动洗衣机，否则将取消设备锁定状态", timeString)
            let attstr = NSMutableAttributedString(string: str)
            attstr.addAttributes([NSAttributedString.Key.foregroundColor: UIColor(rgb: 0xFF7733),
                                  NSAttributedString.Key.font: font_PingFangSC_Regular(16)],
                                 range: NSMakeRange(2, timeString.count))
            self.countDownTimerLabel.attributedText = attstr
        } else if self.orderModel?.status == 4 {
            let timeString = calculTimeString()
            let str = String(format: "完成倒计时:%@", timeString)
            let attstr = NSMutableAttributedString(string: str)
            attstr.addAttributes([NSAttributedString.Key.foregroundColor: UIColor(rgb: 0xFF7733),
                                  NSAttributedString.Key.font: font_PingFangSC_Regular(16)],
                                 range: NSMakeRange(6, timeString.count))
            self.countDownTimerLabel.attributedText = attstr
        } else if self.orderModel?.status == 1 || self.orderModel?.status == 2 {
            let timeString = calculTimeString()
            let str = String(format: "请在%@内完成支付，否则将无法完成订单", timeString)
            let attstr = NSMutableAttributedString(string: str)
            attstr.addAttributes([NSAttributedString.Key.foregroundColor: UIColor(rgb: 0xFF7733),
                                  NSAttributedString.Key.font: font_PingFangSC_Regular(16)],
                                 range: NSMakeRange(2, timeString.count))
            self.countDownTimerLabel.attributedText = attstr
        }
    }
    
    //  将剩余时间转换成字符串
    fileprivate func calculTimeString() -> String{
        let s = Int(countDownTime/1000%60)
        let m = Int(countDownTime/1000/60%60)
        let h = Int(countDownTime/1000/60/60)
        return String(format: "%02d:%02d:%02d",h, m, s)
    }
    
    fileprivate func removePayView() {
        if self.orderModel?.orderFrom == 1 {
            self.immediateUseView.removeFromSuperViewAnimation(nil)
        } else {
            self.appointUseView.removeFromSuperViewAnimation(nil)
        }
    }
    
    @objc fileprivate func clickImageTap(_ tap: UITapGestureRecognizer) {
        ZZPrint("点击了退款图片")
        let vc = PhotoBrowser(showByViewController: self, delegate: self)
        vc.pageControlDelegate = PhotoBrowserDefaultPageControlDelegate(numberOfPages: self.orderModel?.refundImageModels?.count ?? 0)
        vc.show(index: tap.view?.tag ?? 0)
    }
    
//MARK: --------- 更新UI后，刷新UI
    func refresh(_ order: OrderDetailsModel) {

        self.orderModel = order
        bgView.isHidden = false
                
        imageBGView?.removeAllSubView()
        // 是否有图片展示
        var tmpView: UIView = self.orderNoLabel
        // 添加或者移除导航栏右边的按钮
        self.addOrRemoveNaviBtn(isAdd: self.orderModel?.isRefund?.boolValue ?? false)
        
        refundTitleLabel?.removeFromSuperview()
        refundReasonLabel?.removeFromSuperview()
        refuseTitleLabel?.removeFromSuperview()
        refuseReasonLabel?.removeFromSuperview()
        codeTitleLabel?.removeFromSuperview()
        codeValueLabel?.removeFromSuperview()
        imageBGView?.removeFromSuperview()
        imageViews.removeAll()
        reStartView.removeFromSuperview()
        reStartCountDownLabel.removeFromSuperview()
        aloneBtn.removeFromSuperview()
        bottomLeftBtn.removeFromSuperview()
        bottomRightBtn.removeFromSuperview()
                
        if order.isShowRefundReason {
            refundReasonLabel = self.createContentRightLabel()
            bgView.addSubview(refundReasonLabel)
            refundReasonLabel.text = self.orderModel?.refundReason
            refundReasonLabel.snp.makeConstraints({ (make) in
                make.top.equalTo(tmpView.snp.bottom).offset(8)
                make.left.equalTo(108)
                make.right.equalToSuperview()
                make.height.equalTo(48)
            })
            tmpView = refundReasonLabel
            
            refundTitleLabel = self.createContentLeftLabel("退款原因")
            bgView.addSubview(refundTitleLabel)
            refundTitleLabel.snp.makeConstraints({ (make) in
                make.left.equalTo(24)
                make.height.equalTo(48)
                make.centerY.equalTo(refundReasonLabel)
            })
        }
        
        if order.isExistPassword {
            codeValueLabel = self.createContentRightLabel()
            bgView.addSubview(codeValueLabel)
            codeValueLabel.font = font_PingFangSC_Semibold(20)
            codeValueLabel.text = self.orderModel?.drierPassword
            codeValueLabel.snp.makeConstraints({ (make) in
                make.top.equalTo(tmpView.snp.bottom).offset(8)
                make.left.equalTo(108)
                make.right.equalToSuperview()
                make.height.equalTo(48)
            })
            tmpView = codeTitleLabel
            
            codeTitleLabel = self.createContentLeftLabel("验证码（离线时使用）")
            bgView.addSubview(codeTitleLabel)
            codeTitleLabel.snp.makeConstraints({ (make) in
                make.left.equalTo(24)
                make.height.equalTo(48)
                make.centerY.equalTo(codeValueLabel)
            })
        }

        if order.isShowRefundImage {
            imageBGView = UIView()
            bgView.addSubview(imageBGView!)
            imageBGView?.snp.makeConstraints({ (make) in
                make.top.equalTo(tmpView.snp.bottom).offset(8)
                make.left.equalToSuperview()
                make.width.equalTo(BOUNDS_WIDTH-48)
            })
            
            let imageWidth = (BOUNDS_WIDTH-48-15)/4;
            let imageModels = order.refundImageModels!
            for i in 0 ..< imageModels.count {
                let imageView = UIImageView()
                imageView.kf.setImage(with: URL.init(string: imageModels[i].url ?? ""),
                                      placeholder: nil,
                                      options: [.transition(ImageTransition.fade(1))])
                imageView.backgroundColor = UIColor(rgb: 0xf3f3f3)
                imageView.kf.indicatorType = .activity
                imageView.isUserInteractionEnabled = true
                imageView.tag = i
                imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickImageTap(_:))))
                imageBGView?.addSubview(imageView)
                imageView.snp.makeConstraints({ (make) in
                    make.left.equalTo(CGFloat(i%4)*(5+imageWidth))
                    make.top.equalTo(CGFloat(i/4)*(5+imageWidth))
                    make.width.height.equalTo(imageWidth)
                    if i == imageModels.count-1 {
                        make.bottom.equalToSuperview()
                    }
                })
                
                imageViews.append(imageView)
            }
            tmpView = imageBGView!
        }
        
        if order.isShowRefuseReason {
            refuseReasonLabel = self.createContentRightLabel()
            bgView.addSubview(refuseReasonLabel)
            refuseReasonLabel.text = self.orderModel?.refuseReason
            refuseReasonLabel.snp.remakeConstraints({ (make) in
                make.top.equalTo(tmpView.snp.bottom).offset(8)
                make.left.equalTo(108)
                make.right.equalToSuperview()
                make.height.equalTo(48)
            })
            
            tmpView = refuseReasonLabel
            
            refuseTitleLabel = self.createContentLeftLabel("拒绝原因")
            bgView.addSubview(refuseTitleLabel)
            refuseTitleLabel.snp.makeConstraints({ (make) in
                make.left.equalTo(24)
                make.height.equalTo(48)
                make.centerY.equalTo(refuseReasonLabel)
            })

        }
        
        tmpView.snp.makeConstraints { (make) in
            make.bottom.equalTo(-13)
        }
        
        self.titleLabel.text = self.orderModel?.baseName ?? ""
        self.moneyLabel.text = "¥" + String(format: "%.2f", (self.orderModel?.spend?.floatValue ?? 0.0)/100.0)
        self.orderTimeLabel.text = timeStringFromTimeStamp(timeStamp: (self.orderModel?.createTime?.doubleValue)!)
        self.orderNoLabel.text = self.orderModel?.orderNo ?? ""
        
        buttonBgView.removeAllSubView()
        countDownTimerLabel.removeFromSuperview()
        alertBGView.removeFromSuperview()
        
        switch order.status {
        case 0:
            self.stateIcon.image = UIImage(named: "order_going")
            self.statusLabel.text = "无效订单"
            self.buttonBgView.addSubview(self.aloneBtn)
            self.aloneBtn.setTitle("返回首页", for: .normal)
        case 1:
            self.stateIcon.image = UIImage(named: "order_going")
            self.statusLabel.text = "未支付"
            self.buttonBgView.addSubview(self.bottomLeftBtn)
            self.bottomLeftBtn.setTitle("取消", for: .normal)
            self.bottomLeftBtn.setTitleColor(DEEPCOLOR, for: .normal)
            self.buttonBgView.addSubview(self.bottomRightBtn)
            self.bottomRightBtn.setTitle("付款", for: .normal)
            self.bottomRightBtn.isEnabled = true
            
            if countDownTime > 0 {
                addAlertContentView(countDownTimerLabel)
                self.createTimer()
            }

        case 2:
            self.stateIcon.image = UIImage(named: "order_start_error")
            self.statusLabel.text = "支付失败"
            self.buttonBgView.addSubview(self.bottomLeftBtn)
            self.bottomLeftBtn.setTitle("取消", for: .normal)
            self.bottomLeftBtn.setTitleColor(DEEPCOLOR, for: .normal)
            self.buttonBgView.addSubview(self.bottomRightBtn)
            self.bottomRightBtn.setTitle("付款", for: .normal)
            self.bottomRightBtn.isEnabled = true
            
            if countDownTime > 0 {
                addAlertContentView(countDownTimerLabel)
                self.createTimer()
            }

        case 3: // 支付成功
            self.stateIcon.image = UIImage(named: "order_going")
            if self.orderModel?.orderFrom == 2 {
                self.statusLabel.text = "已预约，未洗衣"
                
                self.buttonBgView.addSubview(self.aloneBtn)
                self.aloneBtn.setTitle("立即启动", for: .normal)

                if countDownTime > 0 {
                    addAlertContentView(countDownTimerLabel)
                    self.createTimer()
                }
            } else {
                
                self.buttonBgView.addSubview(self.aloneBtn)
                self.aloneBtn.setTitle("返回首页", for: .normal)
            }
        case 4:
            self.stateIcon.image = UIImage(named: "order_going")
            self.buttonBgView.addSubview(self.aloneBtn)
            self.aloneBtn.setTitle("返回首页", for: .normal)
            self.statusLabel.text = self.orderModel?.washStatusString ?? ""
            
            if !order.deviceIsWorking {
                /// 当订单处于进行中，设备处于没有工作状态
                /// 这时会添加一个启动中倒计时，如果倒计时时间为0，显示启动失败，并且添加启动按钮
                if self.reStartCountDown <= 0 {
                    addAlertContentView(reStartView)
                    self.reStartCountDown = 10
                } else {
                    self.reStartCountDownLabel.text = String(format: "启动中，剩余 00:%02d",reStartCountDown)
                    addAlertContentView(reStartCountDownLabel)
                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
                        self.reStartTimer.fireDate = Date.distantPast
                    }
                }
                
            } else {
                addAlertContentView(countDownTimerLabel)
                let timeStr = String(format: "%d分钟", self.orderModel?.timeLong?.intValue ?? 0)
                let str = String(format: "您的服务预计 %@ 后完成。\n谢谢您的使用！", timeStr)
                let attstr = NSMutableAttributedString(string: str)
                attstr.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.red,
                                      NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 23)],
                                     range: NSMakeRange(7, timeStr.count))
                self.countDownTimerLabel.attributedText = attstr
                
            }
            
            if self.adsModel == nil && !isClosedDetailsAds {
                self.loadADS()
            }

        case 5:
            self.stateIcon.image = UIImage(named: "order_finish")
            self.statusLabel.text = "已完成"
            self.buttonBgView.addSubview(self.aloneBtn)
            self.aloneBtn.setTitle("返回首页", for: .normal)
        case 6:
            self.stateIcon.image = UIImage(named: "order_going")
            self.statusLabel.text = "申请退款中"
            self.buttonBgView.addSubview(self.aloneBtn)
            self.aloneBtn.setTitle("返回首页", for: .normal)
        case 7:
            self.stateIcon.image = UIImage(named: "order_going")
            self.statusLabel.text = "申请退款中"
            self.buttonBgView.addSubview(self.aloneBtn)
            self.aloneBtn.setTitle("返回首页", for: .normal)
        case 8:
            self.stateIcon.image = UIImage(named: "order_going")
            self.buttonBgView.addSubview(self.aloneBtn)
            self.aloneBtn.setTitle("返回首页", for: .normal)
            self.statusLabel.text = "退款失败"
        case 9:
            self.stateIcon.image = UIImage(named: "order_finish")
            self.statusLabel.text = "已退款"
            self.buttonBgView.addSubview(self.aloneBtn)
            self.aloneBtn.setTitle("返回首页", for: .normal)
        case 10:
            self.stateIcon.image = UIImage(named: "order_finish")
            self.statusLabel.text = "订单超时"
            self.buttonBgView.addSubview(self.aloneBtn)
            self.aloneBtn.setTitle("返回首页", for: .normal)
        case 11:
            self.stateIcon.image = UIImage(named: "order_finish")
            self.statusLabel.text = "支付超时"
            self.buttonBgView.addSubview(self.aloneBtn)
            self.aloneBtn.setTitle("返回首页", for: .normal)
        case 12:
            self.stateIcon.image = UIImage(named: "order_finish")
            self.statusLabel.text = "订单已取消"
            self.buttonBgView.addSubview(self.aloneBtn)
            self.aloneBtn.setTitle("返回首页", for: .normal)
        case 13:
            self.stateIcon.image = UIImage(named: "order_finish")
            self.statusLabel.text = "拒绝退款"
            self.buttonBgView.addSubview(self.aloneBtn)
            self.aloneBtn.setTitle("返回首页", for: .normal)
        default:
            print("")
        }
        
        if self.adsModel != nil && order.status?.intValue != 4 {
            self.adsView.removeFromSuperview()
        }
    }
    
    fileprivate func addAlertContentView(_ alertContentView: UIView) {
        bgView.addSubview(alertBGView)
        alertBGView.snp.makeConstraints { (make) in
            make.top.equalTo(16)
            make.left.right.equalToSuperview()
            make.height.equalTo(64)
        }
        alertBGView.addSubview(alertContentView)
        alertContentView.snp.makeConstraints({ (make) in
            make.left.equalTo(32)
            make.right.equalTo(-32)
            make.height.equalTo(45)
            make.centerY.equalToSuperview()
        })
        
        titleLabel.snp.updateConstraints { (make) in
            make.top.equalTo(96)
        }
    }
    
    // 点击确定支付按钮
    fileprivate func alipayOrWxPay(_ payWay: PayWay, orderWay: OrderWay) {
        
        guard IS_FORMAL_PAY else {
            integralPay()
            return
        }
        
        func sendPay() {
            removePayView()
            
            self.showWaitingView(nc_appdelegate?.window ?? self.view)
            let payMessage = NCPayMessage(order: self.orderModel!, payWay: payWay)
            NCPayManager.sendPay(payMessage,
                                 businessOrderId: orderModel?.id?.stringValue ?? "",
                                 checkBeforeOrder: orderModel?.isCheckBeforePay ?? true,
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
    /// - Parameter result: 支付结果payResult
    private func dealPayCallBackResult(_ result: NCPayResult) {
        NCPayManager.dealPayResult(result, self, success: {
            self.loadOrderDetails_pay()
        }) { (message) in
            DeviceViewModel.pushPayFailureVC(self.orderModel ?? OrderDetailsModel(), self)
        }
    }
    
    // 创建启动洗衣机的计时器
    fileprivate func createTimer() {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        RunLoop.current.add(self.timer!, forMode: .common)
    }
  
    //启动洗衣机
    fileprivate func sendStartMachineRequest() {
        self.showWaitingView(appRootView ?? keyWindow)
        DeviceViewModel.startDevice(orderModel?.orderNo ?? "", getUserId()) { (isSuccess, message) in
            self.hiddenWaitingView()
            if isSuccess {
                postNotication(RefreshOrderListNotifation, nil, nil)
                let alertVC = UIAlertController(title: "启动成功", message: nil, preferredStyle: .alert)
                let sureAction = UIAlertAction(title: "确定", style: .default, handler: { (_) in
                    self.navigationController?.popToRootViewController(animated: true)
                })
                alertVC.addAction(sureAction)
                self.present(alertVC, animated: true, completion: nil)
            } else {
                showError(message, superView: self.view, afterHidden: 2)
            }
        }
    }
    
    //MARK:  ** 获取订单详情
    func loadOrderDetails(_ isPayRefresh: Bool = false) {
        showWaitingView(keyWindow)
        OrderViewModel.inquiryOrder(orderId?.stringValue ?? "") { (model, message, error) in
            self.hiddenWaitingView()
            if let orModel = model {
                self.updateContentView(order: orModel)

                self.countDownTime = self.orderModel?.haomiao?.intValue ?? 0
                self.refresh(orModel)
                
            } else {
                let alertVC = UIAlertController(title: message, message: "", preferredStyle: UIAlertController.Style.alert)
                let sureAction = UIAlertAction(title: "确定", style: UIAlertAction.Style.default, handler: nil)
                alertVC.addAction(sureAction)
                self.present(alertVC, animated: true, completion: nil)
            }
        }
    }
    
    fileprivate func loadOrderDetails_pay() {
        if self.payRequestStatusCount == 0 {
            self.showWaitingView(keyWindow)
        }
        OrderViewModel.inquiryOrder(orderId?.stringValue ?? "") { (model, message, error) in
            if let orModel = model {
                self.updateContentView(order: orModel)
                switch orModel.status ?? -1 {
                case 0:
                    print("")
                case 1,2: // 支付失败,
                    if self.payRequestStatusCount == 7 {
                        self.hiddenWaitingView()
                        DeviceViewModel.pushPayFailureVC(orModel, self, 1)
                    } else {
                        // 没有返回成功状态，重复几次（可能解决服务器与支付平台回调延迟问题）
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1, execute: {
                            self.loadOrderDetails_pay()
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
                        self.loadOrderDetails_pay()
                    })
                    self.payRequestStatusCount += 1
                }
            }
        }
    }

        
    fileprivate func integralPay() {
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
    }
    
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
    
    // 进入退款
    func enterRefund() {
        let vc = RefundResonViewController()
        vc.orderId = self.orderModel?.id?.stringValue ?? ""
        vc.hidesBottomBarWhenPushed = true
        vc.isNeedImage = self.orderModel?.isNeedImageWhenRefund ?? false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    fileprivate lazy var aloneBtn: UIButton = { [unowned self] in
        let btn = UIButton()
        btn.frame = CGRect(x: BOUNDS_WIDTH/2-140, y: 0, width: 280, height: 48)
        btn.titleLabel?.font = font_PingFangSC_Regular(14)
        btn.setTitleColor(UIColor(rgb: 0x333333), for: .normal)
        btn.layer.cornerRadius = 24
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor(rgb: 0xDBDBDB).cgColor
        btn.addTarget(self, action: #selector(clickAloneBtn), for: .touchUpInside)
        return btn
    }()
    
    fileprivate lazy var bottomLeftBtn: UIButton = { [unowned self] in
        let btn = UIButton()
        btn.frame = CGRect(x: (BOUNDS_WIDTH-312-17)/2, y: 8, width: 155, height: 40)
        btn.titleLabel?.font = font_PingFangSC_Regular(14)
        btn.setTitleColor(UIColor(rgb: 0x333333), for: .normal)
        btn.layer.cornerRadius = 20
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor(rgb: 0xDBDBDB).cgColor
        btn.addTarget(self, action: #selector(clickButonLeftBtn), for: .touchUpInside)
        return btn
    }()
    
    fileprivate lazy var bottomRightBtn: UIButton = { [unowned self] in
        let btn = UIButton()
        btn.backgroundColor = UIColor(rgb: 0x3399FF)
        btn.frame = CGRect(x: (BOUNDS_WIDTH-312-17)/2 + 155 + 17, y: 8, width: 155, height: 40)
        btn.layer.cornerRadius = 20
        btn.titleLabel?.font = font_PingFangSC_Medium(14)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.addTarget(self, action: #selector(clickButonRightBtn), for: .touchUpInside)
        return btn
    }()
    fileprivate lazy var alertBGView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(rgb: 0xFFF8F5)
        view.layer.cornerRadius = 32
        return view
    }()
    fileprivate lazy var countDownTimerLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(rgb: 0x333333)
        label.font = font_PingFangSC_Regular(12)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    fileprivate lazy var reStartCountDownLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(rgb: 0x333333)
        label.font = font_PingFangSC_Regular(12)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    fileprivate lazy var reStartView: UIView = {
        let view = UIView()
        
        let warmIcon = UIImageView(image: #imageLiteral(resourceName: "warming_blue"))
        view.addSubview(warmIcon)
        warmIcon.snp.makeConstraints({ (make) in
            make.left.centerY.equalToSuperview()
            make.width.height.equalTo(16)
        })
        
        let label = UILabel()
        label.font = font_PingFangSC_Regular(17)
        label.textColor = THEMECOLOR
        label.text = "启动失败"
        view.addSubview(label)
        label.snp.makeConstraints({ (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(warmIcon.snp.right).offset(5)
        })
        
        let btn = UIButton(type: .custom)
        btn.titleLabel?.font = font_PingFangSC_Regular(14)
        btn.setTitleColor(THEMECOLOR, for: .normal)
        
        let text = "立即启动"
        let attributes = [NSAttributedString.Key.underlineStyle: 1,
                          NSAttributedString.Key.foregroundColor : THEMECOLOR] as [NSAttributedString.Key : Any]
        let attStr = NSAttributedString(string: text, attributes: attributes)
        btn.setAttributedTitle(attStr, for: .normal)
        btn.addTarget(self, action: #selector(clickReStartBtn), for: .touchUpInside)
        
        view.addSubview(btn)
        btn.snp.makeConstraints({ (make) in
            make.left.equalTo(label.snp.right).offset(5)
            make.right.centerY.equalToSuperview()
        })
        
        return view
    }()
    
    //TODO: 点击启动机器（在设备延迟启动下可能出现的情况）
    @objc fileprivate func clickReStartBtn() {
        
        showWaitingView(keyWindow)
        
        let paramers = ["userId" : getUserId(),
                        "orderId" : self.orderModel?.id?.stringValue ?? ""]
        
        NetworkEngine.get(API_GET_DEVICE_START, parameters: paramers) { (result) in
  
//MARK: 取消再次点击倒计时新写的代码, modify in 2020.6.20 by zzh
            self.hiddenWaitingView()
            if result.error == nil {
                showSucccess("启动指令已发出", superView: self.view)
            } else {
                showError(result.message, superView: self.view)
            }
        }
        
        ZZPrint("点击重新启动")
    }

//MARK: ------------------  底部按钮响应
    @objc func clickAloneBtn() {
        switch self.orderModel?.status ?? -1 {
        case 1, 2:
            print("")
        case 3:
            self.sendStartMachineRequest()
        case 0, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13:
            print("")
            self.navigationController?.popToRootViewController(animated: true)
        default:
            print("")
        }
    }
    
    @objc func clickButonLeftBtn() {
        switch self.orderModel?.status ?? -1 {
            case 1, 2:
                promptCancelOrder()
            default:
                ZZPrint("")
        }
    }
    
    @objc func clickButonRightBtn() {
        switch self.orderModel?.status ?? -1 {
        case 1, 2:
            if self.orderModel?.orderFrom == 1 {
                self.addImmediatePayView()
            } else {
                self.addAppointPayView()
            }
        default:
            ZZPrint("")
        }
        
    }
    
    fileprivate func addImmediatePayView() {
        self.immediateUseView.refreshUI(payMoney: String(format: "%.02f", (self.orderModel?.spend?.floatValue)!/100.0), typeName: self.orderModel?.showedPackageName ?? "")
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
    
    // 预约下单成功后，将支付确认页添加到视图上
    fileprivate func addAppointPayView() {
        self.appointUseView.refreshUI(payMoney: String(format: "%.02f", (self.orderModel?.spend?.floatValue ?? 0)/100.0), typeName: self.orderModel?.showedPackageName ?? "")
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
    
    fileprivate lazy var immediateUseView:ImmediatedUseView = {
        let view = ImmediatedUseView(frame: CGRect(x: 0, y: 0, width: BOUNDS_WIDTH, height: BOUNDS_HEIGHT))
        return view
    }()
    
    fileprivate lazy var appointUseView:AppointUseView = {
        let view = AppointUseView(frame: CGRect(x: 0, y: 0, width: BOUNDS_WIDTH, height: BOUNDS_HEIGHT))
        return view
    }()
    

    func loadADS() {
        let url = API_GET_ADS
        /// location 0:启动页 1:首页右下角 2:首页底部 3:运行中的订单详情页
        let parameters = ["location": 3]
        NetworkEngine.get(url, parameters: parameters) { (result) in
            
            guard result.isSuccess else { return }
            guard let dataDict = (result.dataObj as? [String: AnyObject])?["data"] as? [String: Any] else { return }
            guard let model = ADSModel.create(withDict: dataDict) else { return }
            
            self.adsModel = model
            self.showAdsView(model)
        }
    }
    
    fileprivate func showAdsView(_ adsM: ADSModel) {
        /// 当底部广告在视图上，不再继续加载
        guard self.adsView.superview == nil else { return }
        
        guard let url = URL(string: adsM.image) else { return }
        
        /// 下载图片
        KingfisherManager.shared.retrieveImage(with: url,
                                               options: nil,
                                               progressBlock: nil)
        { (image, error, cacheType, url) in
            
            guard error == nil else {
                ZZPrint("download ads image error")
                return
            }
            
            guard let image = image else { return }
            
            self.adsView.alpha = 0
            self.adsView.image = image
            
            self.contentScrollView?.addSubview(self.adsView)
            
            let imageViewWidth = image.size.width > BOUNDS_WIDTH-30 ? BOUNDS_WIDTH-30 : image.size.width
            let imageViewHeight = image.size.height * imageViewWidth / image.size.width
            self.adsView.snp.makeConstraints({ (make) in
                make.top.equalTo(self.bgView!.snp.bottom).offset(30)
                make.centerX.equalToSuperview()
                make.width.equalTo(imageViewWidth)
                make.height.equalTo(imageViewHeight)
            })
            
            self.adsView.isUserInteractionEnabled = false
            UIView.animate(withDuration: 0.5, animations: {
                self.adsView.alpha = 1
            }, completion: { (_) in
                self.adsView.isUserInteractionEnabled = true
            })
        }
    }
}

extension DealDetailViewController {
    /// 添加上面不变的UI
    fileprivate func initUI() {
        view.addSubview(deviceBGImageView)
        view.addSubview(stateIcon)
        view.addSubview(statusLabel)
        
        deviceBGImageView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.right.equalTo(-16)
            make.width.equalTo(104)
            make.height.equalTo(104)
        }
        stateIcon.snp.makeConstraints { (make) in
            make.left.equalTo(24)
            make.top.equalTo(25)
            make.width.height.equalTo(24)
        }
        statusLabel.snp.makeConstraints { (make) in
            make.left.equalTo(stateIcon.snp.right).offset(8)
            make.centerY.equalTo(stateIcon)
        }
    }
    
    /// 根据订单状态更新本页视图,如果还没创建就去创建
    fileprivate func updateContentView(order: OrderDetailsModel) {
        if order.status != self.orderModel?.status {
            self.orderModel = order
            
            self.bgView?.removeFromSuperview()
            self.bgView = nil
            self.buttonBgView?.removeFromSuperview()
            self.buttonBgView = nil
            
            self.makeNewUI()
            self.makeBottomBGView()
        }
    }
    
    fileprivate func makeNewUI() {
        let titles = ["使用地址", "实付金额", "下单时间", "订单号"]
        
        contentScrollView = UIScrollView()
        contentScrollView?.backgroundColor = .white
        view.addSubview(contentScrollView!)
        contentScrollView?.layer.cornerRadius = 20
        contentScrollView?.snp.makeConstraints { (make) in
            make.top.equalTo(stateIcon.snp.bottom).offset(20)
            make.left.right.bottom.equalToSuperview()
        }
        
        bgView = UIView()
        bgView.backgroundColor = .white
        bgView.isHidden = true
        contentScrollView?.addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalTo(24)
            make.width.equalTo(BOUNDS_WIDTH - 48)
            make.height.greaterThanOrEqualTo(56*4)
            make.bottom.equalTo(-BOTTOM_SAFE_HEIGHT - 67)
        }
        
        var tmpLabel: UIView?
        for i in 0 ..< titles.count {
            
            let rightLabel = createContentRightLabel()
            bgView.addSubview(rightLabel)
            rightLabel.snp.makeConstraints({ (make) in
                if i == 0 {
                    make.top.equalTo(24)
                } else {
                    make.top.equalTo(tmpLabel!.snp.bottom).offset(8)
                }
                make.left.equalTo(108)
                make.right.equalToSuperview()
                make.height.height.equalTo(48)
            })
            tmpLabel = rightLabel
            
            let leftView = self.createContentLeftLabel(titles[i])
            bgView.addSubview(leftView)
            leftView.snp.makeConstraints({ (make) in
                make.left.equalToSuperview()
                make.height.equalTo(48)
                make.centerY.equalTo(rightLabel)
            })
            
            switch i {
            case 0:
                self.titleLabel = rightLabel
            case 1:
                self.moneyLabel = rightLabel
                self.moneyLabel.textColor = UIColor(rgb: 0xFF7733)
            case 2:
                self.orderTimeLabel = rightLabel
            case 3:
                self.orderNoLabel = rightLabel
            default:
                print("")
            }
        }
    }
    
    fileprivate func createContentLeftLabel(_ title: String = "") -> UILabel {
        let leftView = UILabel()
        leftView.textColor = UIColor(rgb: 0x666666)
        leftView.font = font_PingFangSC_Regular(12)
        leftView.text = title
        return leftView
    }
    
    fileprivate func createContentRightLabel() -> UILabel {
        let rightLabel = UILabel()
        rightLabel.textColor = UIColor(rgb: 0x333333)
        rightLabel.font = font_PingFangSC_Regular(12)
        rightLabel.numberOfLines = 0
        return rightLabel
    }
    
    fileprivate func makeBottomBGView() {
        self.buttonBgView = UIView()
        self.buttonBgView.backgroundColor = UIColor.white
        self.view.addSubview(self.buttonBgView)
        self.buttonBgView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(BOTTOM_SAFE_HEIGHT + 60)
        }
    }
}

//MARK:  *********  PhotoBrowserDelegate  **********
extension DealDetailViewController: PhotoBrowserDelegate {
    func numberOfPhotos(in photoBrowser: PhotoBrowser) -> Int {
        return self.orderModel?.refundImageModels?.count ?? 0
    }
    
    /// 缩放起始视图
    func photoBrowser(_ photoBrowser: PhotoBrowser, thumbnailViewForIndex index: Int) -> UIView? {
        return imageViews[index]
    }
    
    /// 图片加载前的placeholder
    func photoBrowser(_ photoBrowser: PhotoBrowser, thumbnailImageForIndex index: Int) -> UIImage? {
        return imageViews[index].image
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
extension DealDetailViewController {
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
