//
//  OrderDetailsContentView.swift
//  WashingMachine
//
//  Created by zzh on 2017/7/21.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

import UIKit
import Kingfisher

enum OrderContentViewBottomBtnAction: Int {
    case cancel //简单的取消
    case cancelOrder // 取消该订单
    case applyRefund // 申请退款
    case backHome // 返回首页
    case startWork // 启动
    case pay //付款
}

class OrderDetailsContentView: UIView {
    /// 点击底部按钮回调闭包
    var bottomBtnActionClourse: ((OrderContentViewBottomBtnAction)->())?
    /// 点击退款图片数组回调
    var didSelectedRefundImageClourse: ((Int, [UIImageView])->())?
    /// 退款图片视图数组
    var refundImageViews: [UIImageView] = [UIImageView]()
    
    /// 最后一个订单信息视图
    var lastOrderMessageView: UIView!
    /// 订单
    var order: OrderDetailsModel!
    
    let bottomBtnHeight: CGFloat = 55
    var scrollView: UIScrollView!
    var contentBGView: UIView!
    /// 倒计时视图
    var countDownLabel: UILabel?
    var buttonBgView: UIView!
    /// 倒计时时间（单位毫秒）
    var countDownTime: Int = 0
    var timer: Timer?
    /// 结束倒计时回调
    var endCountDownClourse: (()->())?
    
    convenience init(orderModel: OrderDetailsModel) {
        self.init()
        self.order = orderModel
        self.makeNewUI(orderModel)
        if isCreateAloneBotomBtn() {
            makeBottomBGView()
            createAloneBtn()
        } else {
            makeBottomBGView()
            createDouleBtn()
        }
    }
    
    override func removeFromSuperview() {
        super.removeFromSuperview()
        
        self.timer?.invalidate()
        self.timer = nil
    }
    
    @objc fileprivate func timerAction() {
        countDownTime = countDownTime - 1000
        if countDownTime <= 0 {
            timer?.invalidate()
            endCountDownClourse?()
        }
        
        let timeString = countDownTime.transToCommonTimeFromMS()
        let str = String(format: "请在%@内完成支付，否则将无法完成订单", timeString)
        let attstr = NSMutableAttributedString(string: str)
        attstr.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.red,
                              NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20)],
                             range: NSMakeRange(2, timeString.count))
        self.countDownLabel?.attributedText = attstr
    }
    
    /// 点击退款图片
    @objc fileprivate func clickRefundImage(_ tap: UITapGestureRecognizer) {
        didSelectedRefundImageClourse?(tap.view?.tag ?? 0, self.refundImageViews)
    }
    
    private func makeNewUI(_ order: OrderDetailsModel) {
        
        let deviceBGImageView = UIImageView()
        deviceBGImageView.image = UIImage(named: "order_device_bg")
        addSubview(deviceBGImageView)
        deviceBGImageView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.right.equalTo(-16)
            make.width.equalTo(104)
            make.height.equalTo(104)
        }
        
        let stateIcon = UIImageView()
        stateIcon.image = stateImage()
        addSubview(stateIcon)
        stateIcon.snp.makeConstraints { (make) in
            make.left.equalTo(24)
            make.top.equalTo(24)
            make.width.height.equalTo(24)
        }
        
        let statusLabel = UILabel.create(font: font_PingFangSC_Medium(18),
                                         textColor: UIColor(rgb: 0x333333))
        statusLabel.text = order.statusStr
        addSubview(statusLabel)
        statusLabel.snp.makeConstraints { (make) in
            make.left.equalTo(stateIcon.snp.right).offset(8)
            make.centerY.equalTo(stateIcon)
        }
        var hasAuthCode = false
        if let authCode = order.drierPassword, authCode.count > 2 {
            hasAuthCode = true
        }
        
        scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = .white
        scrollView.layer.cornerRadius = 20
        scrollView.clipsToBounds = true
        addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.top.equalTo(70)
            make.left.right.bottom.equalToSuperview()
        }
        contentBGView = UIView()
        contentBGView.backgroundColor = .white
        scrollView.addSubview(contentBGView)
        contentBGView.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.greaterThanOrEqualTo(56*4)
            make.bottom.equalTo(-BOTTOM_SAFE_HEIGHT - 67)
        }
        
        self.countDownTime = order.haomiao?.intValue ?? 0
        // 是否应该倒计时
        var isShouldCountDown = false
        if (order.status == 1 || order.status == 2) && self.countDownTime > 0 {
            isShouldCountDown = true
        }
        if isShouldCountDown {
            
            let alertBGView = UIView()
            alertBGView.backgroundColor = UIColor(rgb: 0xFFF8F5)
            alertBGView.layer.cornerRadius = 32
            contentBGView.addSubview(alertBGView)
            alertBGView.snp.makeConstraints { (make) in
                make.top.equalTo(16)
                make.left.equalTo(16)
                make.right.equalTo(-16)
                make.height.equalTo(64)
            }

            // 如果毫秒倒计时存在且大于0，先去创建倒计时视图，再去创建计时器
            countDownLabel = UILabel()
            countDownLabel?.textColor = UIColor(rgb: 0x333333)
            countDownLabel?.font = font_PingFangSC_Regular(12)
            countDownLabel?.numberOfLines = 0
            countDownLabel?.textAlignment = .center
            self.addSubview(countDownLabel!)
            countDownLabel?.snp.makeConstraints { (make) in
                make.left.equalTo(16)
                make.right.equalTo(-16)
                make.height.equalTo(46)
                make.centerY.equalToSuperview()
            }
            
            // 创建倒计时
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
            RunLoop.current.add(self.timer!, forMode: .common)
            self.timer?.fire()
        }
                
        var titles: [String] = ["使用地址", "实付金额", "下单时间", "订单号"]
        if !(order.refundReason?.isEmpty ?? true) {
            titles.append("退款原因")
        }
        if !(order.refuseReason?.isEmpty ?? true) {
            titles.append("拒绝原因")
        }
        
        var tmpView: UIView?
        for i in 0 ..< titles.count {
            
            let rightLabel = UILabel()
            rightLabel.textColor = UIColor(rgb: 0x333333)
            rightLabel.font = font_PingFangSC_Regular(12)
            rightLabel.numberOfLines = 0
            contentBGView.addSubview(rightLabel)
            
            rightLabel.snp.makeConstraints({ (make) in
                if i == 0 {
                    make.top.equalTo(hasAuthCode ? 48 : (isShouldCountDown ? 96 : 16))
                } else {
                    make.top.equalTo(tmpView!.snp.bottom).offset(8)
                }
                make.left.equalTo(108)
                make.right.equalTo(-24)
                make.height.equalTo(48)
            })
            tmpView = rightLabel
            
            let leftView = UILabel()
            leftView.textColor = UIColor(rgb: 0x666666)
            leftView.font = font_PingFangSC_Regular(12)
            leftView.text = titles[i]
            contentBGView.addSubview(leftView)
            leftView.snp.makeConstraints({ (make) in
                make.left.equalTo(24)
                make.height.equalTo(48)
                make.centerY.equalTo(rightLabel)
            })
            
            if i == titles.count - 1 {
                lastOrderMessageView = rightLabel
            }
            
            if titles[i] == "退款原因" {
                // 添加图款图片
                if order.isShowRefundImage {
                    let imageBGMView = UIView()
                    contentBGView.addSubview(imageBGMView)
                    imageBGMView.snp.makeConstraints({ (make) in
                        make.left.equalTo(24)
                        make.right.equalTo(-24)
                        make.top.equalTo(tmpView!.snp.bottom)
                    })
                    
                    tmpView = imageBGMView
                    if i == titles.count - 1 {
                        lastOrderMessageView = imageBGMView
                    }
                    
                    let imageModels = order.refundImageModels!
                    let imageWidth = (BOUNDS_WIDTH-48-3*5)/4
                    refundImageViews.removeAll()
                    
                    for j in 0 ..< imageModels.count {
                        let imageView = UIImageView()
                        imageView.backgroundColor = UIColor_0x(0xf3f3f3)
                        imageView.isUserInteractionEnabled = true
                        imageView.tag = j
                        imageView.kf.setImage(with: URL.init(string: imageModels[j].url ?? ""),
                                              placeholder: nil,
                                              options: [.transition(ImageTransition.fade(1))])
                        imageView.kf.indicatorType = .activity
                        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickRefundImage(_:))))
                        imageBGMView.addSubview(imageView)
                        imageView.snp.makeConstraints({ (make) in
                            make.left.equalTo((imageWidth+5)*CGFloat(j%4))
                            make.top.equalTo((imageWidth+5)*CGFloat(j/4))
                            make.width.height.equalTo(imageWidth)
                            if j == imageModels.count-1 {
                                make.bottom.equalToSuperview()
                            }
                        })
                        
                        refundImageViews.append(imageView)
                    }
                }
            }
            
            switch titles[i] {
            case "使用地址":
                rightLabel.text = order.baseName
            case "实付金额":
                rightLabel.text = ((order.spend?.floatValue ?? 0.0)/100).twoDecimalPlaces + "元"
                rightLabel.textColor = UIColor(rgb: 0xFF7733)
            case "下单时间":
                rightLabel.text = order.createTimeStr
            case "订单号":
                rightLabel.text = order.orderNo
            case "退款原因":
                rightLabel.text = order.refundReason
            case "拒绝原因":
                rightLabel.text = order.refuseReason
            default:
                print("")
            }
        }
        
        tmpView?.snp.makeConstraints({ (make) in
            make.bottom.equalTo(-13)
        })
    }
    
    private func stateImage() -> UIImage? {
        switch self.order.status ?? -1 {
            case 5, 9, 10, 11, 12, 13:
                return UIImage(named: "order_finish")
            case 0, 1, 3, 4, 6, 7, 8:
                return UIImage(named: "order_going")
            case 2:
                return UIImage(named: "order_start_error")
            default:
                return UIImage(named: "order_going")
        }
    }
    
    private func statusTextColor() -> UIColor {
        switch self.order.status ?? -1 {
            case 0, 2, 5, 9, 10, 11, 12:
                return UIColor(rgb: 0x999999)
            case 1:
                return UIColor(rgb: 0xF12626)
            case 3, 4:
                return UIColor(rgb: 0x08c847)
            case 6, 7, 8, 13:
                return UIColor(rgb: 0x6684EA)
            default:
                return UIColor(rgb: 0x999999)
        }
    }
    
    /// 判断创建单个底部按钮还是两个底部按钮
    private func isCreateAloneBotomBtn() -> Bool {
        switch self.order.status ?? -1 {
        case 1, 2:
            return false
        default:
            return true
        }
    }
        
    /// 底部左边按钮文本
    private func leftBtnText() -> String {
        switch self.order.status ?? -1 {
        case 1, 2: return "取消"
        default: return ""
        }
    }
    
    /// 底部右边按钮文本
    private func rightBtnText() -> String {
        switch self.order.status ?? -1 {
        case 1, 2: return "付款"
        default: return ""
        }
    }
    
    /// 底部单独按钮文本
    private func aloneBtnText() -> String {
        switch self.order.status ?? -1 {
        case 0, 3, 4, 5, 6, 7, 8, 9, 11, 12, 13: return "返回首页"
        default: return ""
        }
    }
    
    /// 获取左边按钮点击相应行为
    private func fetchLeftBtnAction() -> OrderContentViewBottomBtnAction {
        switch self.order.status ?? -1 {
        case 1, 2: return .cancelOrder
        case 3, 4, 5, 8, 10, 13: return .applyRefund
        default: return .backHome
        }
    }
    
    /// 获取右边按钮点击相应行为
    private func fetchRightBtnAction() -> OrderContentViewBottomBtnAction {
        switch self.order.status ?? -1 {
        case 1, 2: return .pay
        case 3, 4, 5, 8, 10, 13: return .backHome
        default: return .backHome
        }
    }
    
    /// 获取单独按钮点击相应行为
    private func fetchAloneBtnAction() -> OrderContentViewBottomBtnAction {
        return .backHome
    }
    
    // TODO: ----- 点击底部单独按钮  -----
    @objc private func clickAloneBtn() {
        bottomBtnActionClourse?(fetchAloneBtnAction())
    }
    
    // TODO: ----- 点击底部左边按钮  -----
    @objc private func clickLeftBtn() {
        bottomBtnActionClourse?(fetchLeftBtnAction())
    }
    
    // TODO: ----- 点击底部右边按钮  -----
    @objc private func clickRightBtn() {
        bottomBtnActionClourse?(fetchRightBtnAction())
    }
    
    private func makeBottomBGView() {
        buttonBgView = UIView()
        buttonBgView.backgroundColor = UIColor.white
        addSubview(self.buttonBgView)
        buttonBgView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(BOTTOM_SAFE_HEIGHT + 60)
        }
    }
    private func createDouleBtn() {
        let leftBtn = UIButton()
        leftBtn.frame = CGRect(x: (BOUNDS_WIDTH-312-17)/2, y: 8, width: 155, height: 40)
        leftBtn.titleLabel?.font = font_PingFangSC_Regular(14)
        leftBtn.setTitleColor(UIColor(rgb: 0x333333), for: .normal)
        leftBtn.layer.cornerRadius = 20
        leftBtn.layer.borderWidth = 1
        leftBtn.layer.borderColor = UIColor(rgb: 0xDBDBDB).cgColor
        leftBtn.setTitle(leftBtnText(), for: .normal)
        leftBtn.addTarget(self, action: #selector(clickLeftBtn), for: .touchUpInside)
        buttonBgView.addSubview(leftBtn)
        
        let rightBtn = UIButton()
        rightBtn.backgroundColor = UIColor(rgb: 0x3399FF)
        rightBtn.frame = CGRect(x: (BOUNDS_WIDTH-312-17)/2 + 155 + 17, y: 8, width: 155, height: 40)
        rightBtn.layer.cornerRadius = 20
        rightBtn.titleLabel?.font = font_PingFangSC_Medium(14)
        rightBtn.setTitleColor(UIColor.white, for: .normal)
        rightBtn.setTitle(rightBtnText(), for: .normal)
        rightBtn.addTarget(self, action: #selector(clickRightBtn), for: .touchUpInside)
        buttonBgView.addSubview(rightBtn)
    }
    
    private func createAloneBtn() {
        let aloneBtn = UIButton()
        aloneBtn.frame = CGRect(x: BOUNDS_WIDTH/2-140, y: 0, width: 280, height: 48)
        aloneBtn.titleLabel?.font = font_PingFangSC_Regular(14)
        aloneBtn.setTitleColor(UIColor(rgb: 0x333333), for: .normal)
        aloneBtn.layer.cornerRadius = 24
        aloneBtn.layer.borderWidth = 1
        aloneBtn.layer.borderColor = UIColor(rgb: 0xDBDBDB).cgColor
        aloneBtn.addTarget(self, action: #selector(clickAloneBtn), for: .touchUpInside)
        aloneBtn.setTitle(aloneBtnText(), for: .normal)
        buttonBgView.addSubview(aloneBtn)
    }
}
