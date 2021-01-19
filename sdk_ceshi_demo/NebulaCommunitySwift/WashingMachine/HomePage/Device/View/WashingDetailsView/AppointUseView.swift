//
//  AppointUseView.swift
//  WashingMachine
//
//  Created by zzh on 17/3/8.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

import UIKit

class AppointUseView: UIView {

    var payClourse: ((PayWay) -> ())?
    var closeClourse: (() -> ())?
    var despLabel: UILabel!
    var walletBalanceLabel: UILabel!
    private var payLabel: UILabel!
    private var contentView: UIView!
    private var typeLabel: UILabel!
    
    var payWayBtns = [UIButton]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configUI()
    }
    
    /// 修改选择的支付方式
    func choose(payWay: PayWay) {
        switch payWay {
        case .nebula:
            guard payWayBtns.count >= 1 else { return }
            clickChoosePayWayBtn(payWayBtns[0])
        case .alipay:
            guard payWayBtns.count >= 2 else { return }
            clickChoosePayWayBtn(payWayBtns[2])
        case .wx:
            guard payWayBtns.count >= 3 else { return }
            clickChoosePayWayBtn(payWayBtns[1])
        }
    }
    
    func showAnimation(_ finishAnimation:(()->())?) {
        backgroundColor = UIColor.black.withAlphaComponent(0)
        contentView.snp.remakeConstraints { (make) in
            make.top.equalTo(self.snp.bottom)
            make.left.equalToSuperview()
            make.width.equalTo(self.hz_width)
        }
        layoutIfNeeded()
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundColor = UIColor.black.withAlphaComponent(0.8)
            self.contentView.snp.remakeConstraints({ (make) in
                make.left.bottom.equalToSuperview()
                make.width.equalTo(self.hz_width)
            })
            self.layoutIfNeeded()
        }) { (_) in
            finishAnimation?()
        }
    }
    
    func removeFromSuperViewAnimation(_ finishAnimation:(()->())?) {
        backgroundColor = UIColor.black.withAlphaComponent(0.8)
        contentView.snp.remakeConstraints { (make) in
            make.left.bottom.equalToSuperview()
            make.width.equalTo(self.hz_width)
        }
        layoutIfNeeded()
        UIView.animate(withDuration: 0.2, animations: {
            self.backgroundColor = UIColor.black.withAlphaComponent(0)
            self.contentView.snp.remakeConstraints({ (make) in
                make.top.equalTo(self.snp.bottom)
                make.left.equalToSuperview()
                make.width.equalTo(self.hz_width)
            })
            self.layoutIfNeeded()
        }) { (_) in
            finishAnimation?()
            self.removeFromSuperview()
        }
    }
    
    func refreshUI(payMoney: String, typeName: String) {
        let str = payMoney + "元"
        let attstr = NSMutableAttributedString(string: str)
        attstr.addAttributes([NSAttributedString.Key.font: font_PingFangSC_Medium(32)],
                             range: NSMakeRange(0, payMoney.count))
        payLabel.attributedText = attstr
        
        typeLabel.text = typeName
    }
    
    /// 修改描述文本
    func updateDespText() {
        
    }
    
    fileprivate func configUI() {
        self.backgroundColor = UIColor.black.withAlphaComponent(0)
        
        contentView = UIView()
        self.addSubview(contentView)
        contentView.layer.cornerRadius = 20
        contentView.backgroundColor = UIColor.white
        contentView.clipsToBounds = true
        contentView.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.bottom)
            make.left.right.equalToSuperview()
        }
        
        let auxiliaryView = UIView()
        auxiliaryView.backgroundColor = .white
        contentView.addSubview(auxiliaryView)
        auxiliaryView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(30)
        }
        
        let immediatedUseLabel = UILabel()
        contentView.addSubview(immediatedUseLabel)
        immediatedUseLabel.textColor = UIColor(rgb: 0x333333)
        immediatedUseLabel.font = font_PingFangSC_Medium(14)
        immediatedUseLabel.text = "预约使用"
        immediatedUseLabel.snp.makeConstraints { (make) in
            make.top.equalTo(14)
            make.centerX.equalToSuperview()
            make.height.equalTo(20)
        }
        
        let closeButton = UIButton()
        contentView.addSubview(closeButton)
        closeButton.adjustsImageWhenHighlighted = false
        closeButton.setImage(UIImage(named: "pay_close"), for: .normal)
        closeButton.addTarget(self, action: #selector(closePay), for: .touchUpInside)
        closeButton.snp.makeConstraints { (make) in
            make.right.equalTo(-10)
            make.centerY.equalTo(immediatedUseLabel)
            make.width.height.equalTo(35)
        }
        
        let despBGView = UIView()
        despBGView.backgroundColor = UIColor(rgb: 0xFFF8F5)
        despBGView.layer.cornerRadius = 24
        contentView.addSubview(despBGView)
        despBGView.snp.makeConstraints { (make) in
            make.top.equalTo(immediatedUseLabel.snp.bottom).offset(14)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.height.equalTo(48)
        }
        
        despLabel = UILabel()
        despBGView.addSubview(despLabel)
        despLabel.numberOfLines = 0
        despLabel.textColor = UIColor(rgb: 0x333333)
        despLabel.font = font_PingFangSC_Regular(12)
        despLabel.textAlignment = .center
        let str = "请在3分钟内完成支付，支付成功后为您锁定洗衣机15分钟，过时未使用不会退款"
        let attstr = NSMutableAttributedString(string: str)
        attstr.addAttributes([NSAttributedString.Key.foregroundColor: UIColor(rgb: 0xFF7733)],
                             range: NSMakeRange(2, 3))
        attstr.addAttributes([NSAttributedString.Key.foregroundColor: UIColor(rgb: 0xFF7733)],
                             range: NSMakeRange(23, 4))
        despLabel.attributedText = attstr
        despLabel.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.top.bottom.equalToSuperview()
        }

        let payCountLabel = UILabel()
        contentView.addSubview(payCountLabel)
        payCountLabel.textColor = UIColor(rgb: 0xFF7733)
        payCountLabel.font = font_PingFangSC_Medium(14)
        payCountLabel.text = "_元"
        self.payLabel = payCountLabel
        payCountLabel.snp.makeConstraints { (make) in
            make.top.equalTo(despLabel.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.height.equalTo(45)
        }
        
        let typeLabel = UILabel()
        self.typeLabel = typeLabel
        typeLabel.textColor = UIColor(rgb: 0x999999)
        typeLabel.font = font_PingFangSC_Regular(12)
        contentView.addSubview(typeLabel)
        typeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(payCountLabel.snp.bottom).offset(8)
            make.height.equalTo(17)
            make.centerX.equalToSuperview()
            make.width.lessThanOrEqualTo(BOUNDS_WIDTH-40)
        }
        
        let payWayImages = [#imageLiteral(resourceName: "wallet_blue"), #imageLiteral(resourceName: "wx_icon"), #imageLiteral(resourceName: "alipay_icon")]
        let payNames = ["我的钱包", "微信支付", "支付宝支付"]
        for (i, image) in payWayImages.enumerated() {
            let bgButton = UIButton()
            bgButton.tag = i
            contentView.addSubview(bgButton)
            bgButton.addTarget(self, action: #selector(clickChoosePayWayBtn(_:)), for: .touchUpInside)
            payWayBtns.append(bgButton)
            bgButton.snp.makeConstraints({ (make) in
                make.top.equalTo(typeLabel.snp.bottom).offset(24+CGFloat(i)*64)
                make.left.right.equalToSuperview()
                make.height.equalTo(64)
            })
            
            let payIcon = UIImageView(image: image)
            bgButton.addSubview(payIcon)
            payIcon.snp.makeConstraints({ (make) in
                make.left.equalTo(37)
                make.width.height.equalTo(38)
                make.centerY.equalToSuperview()
            })
            
            let nameLabel = UILabel()
            bgButton.addSubview(nameLabel)
            nameLabel.textColor = UIColor(rgb: 0x333333)
            nameLabel.font = font_PingFangSC_Medium(14)
            nameLabel.text = payNames[i]
            nameLabel.snp.makeConstraints({ (make) in
                make.left.equalTo(88)
                make.height.equalTo(20)
                if i == 0 {
                    make.top.equalTo(14)
                } else {
                    make.centerY.equalToSuperview()
                }
            })
            
            if payNames[i] == "我的钱包" {
                walletBalanceLabel = createLabel("余额" + UserBalanceManager.share.balanceStr + "元",
                                                 textColor: UIColor_0x(0x333333),
                                                 font: font_PingFangSC_Regular(12),
                                                 superView: bgButton)
                walletBalanceLabel.snp.makeConstraints({ (make) in
                    make.top.equalTo(34)
                    make.left.equalTo(nameLabel)
                    make.height.equalTo(17)
                })
            }
            
            let selectedIcon = UIImageView()
            bgButton.addSubview(selectedIcon)
            selectedIcon.tag = 999
            selectedIcon.snp.makeConstraints { (make) in
                make.centerY.equalToSuperview()
                make.width.height.equalTo(20)
                make.right.equalTo(-40)
            }
        }
        /// 选中第一个
        clickChoosePayWayBtn(payWayBtns.first!)
        
        let surePayButton = UIButton()
        contentView.addSubview(surePayButton)
        surePayButton.setTitle("确认支付", for: .normal)
        surePayButton.setTitleColor(UIColor.white, for: .normal)
        surePayButton.adjustsImageWhenHighlighted = false
        surePayButton.titleLabel?.font = font_PingFangSC_Medium(14)
        surePayButton.backgroundColor = UIColor(rgb: 0x3399FF)
        surePayButton.layer.cornerRadius = 24
        surePayButton.addTarget(self, action: #selector(clickSurePay), for: .touchUpInside)
        surePayButton.snp.makeConstraints { (make) in
            make.top.equalTo(typeLabel.snp.bottom).offset(240)
            make.width.equalTo(280)
            make.height.equalTo(48)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-BOTTOM_SAFE_HEIGHT - 16)
        }
        
        layoutIfNeeded()
    }
    
    @objc fileprivate func clickSurePay() {
        for btn in payWayBtns {
            
            guard btn.isSelected else { continue }
            
            if btn.tag == 0 {
                payClourse?(.nebula)
            } else if btn.tag == 1 {
                payClourse?(.wx)
            } else if btn.tag == 2 {
                payClourse?(.alipay)
            }
        }
    }
    
    @objc fileprivate func closePay() {
        closeClourse?()
    }
    
    @objc fileprivate func clickChoosePayWayBtn(_ btn: UIButton) {
        ZZPrint(btn.tag)
        for button in payWayBtns {
            guard let selectedImageView = button.viewWithTag(999) as? UIImageView else { continue }
            button.isSelected = (button.tag == btn.tag)
            selectedImageView.image = (button.tag == btn.tag) ? UIImage(named: "pay_choose_ed") : UIImage(named: "pay_choose")
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
