//
//  UseBlowerContentView.swift
//  WashingMachine
//
//  Created by zzh on 2017/7/14.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

import UIKit
import Kingfisher

class UseBlowerContentView: UIView {
    
    var startClourse: ((Int)->())?
    
    private var chooseTypeSelectBtns = [UIButton]()
    private var titlelabel: UILabel!
    
    convenience init(deviceModel: WashingModel, packages: [PackageModel]) {
        self.init()
        self.addDeviceBaseView(deviceModel: deviceModel)
        self.addBottomButton()
//        if deviceModel.deviceType == .condensateBeads {
//            self.addAlertView()
//        }
        self.addChooseTypeContent(packages, deviceModel)
        
    }
    
    /// 点击套餐
    @objc func clickChooseTypeBtn(_ btn: UIButton) {
        let index = btn.tag
        let oldIndex = selectedPakageIndex()
        if index == oldIndex {
            return
        }
        let oldBtn = chooseTypeSelectBtns[oldIndex]
        oldBtn.isSelected = false
        let selectBtn = chooseTypeSelectBtns[index]
        selectBtn.isSelected = true
    }
    
    /// 获取选中套餐的序号
    func selectedPakageIndex() -> Int {
        var index: Int = 0;
        for (i, btn) in chooseTypeSelectBtns.enumerated() {
            if btn.isSelected {
                index = i;
                break
            }
        }
        return index;
    }
    
    /// 点击底部使用启动按钮
    @objc func clickBottom(_ btn: UIButton) {
        startClourse?(self.selectedPakageIndex())
    }
    
    private func addDeviceBaseView(deviceModel: WashingModel) {
        backgroundColor = BACKGROUNDCOLOR
        addSubview(baseInfoView)
        baseInfoView.addSubview(auxiliaryView)
        addSubview(chooseTypeView)
        baseInfoView.addSubview(icon)
        baseInfoView.addSubview(titleLabel)
        
        auxiliaryView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(20)
        }
        baseInfoView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
        }
        chooseTypeView.snp.makeConstraints { (make) in
            make.top.equalTo(baseInfoView.snp.bottom).offset(16)
            make.left.equalTo(16)
            make.width.equalTo(BOUNDS_WIDTH-32)
            make.bottom.equalTo(-BOTTOM_SAFE_HEIGHT - 64 - (deviceModel.deviceType == .condensateBeads ? 30 : 0))
        }
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(16)
            make.left.equalTo(40)
            make.centerY.equalToSuperview()
            make.right.equalTo(-16)
            make.bottom.equalTo(-16)
        }
        icon.snp_makeConstraints { (make) in
            make.left.equalTo(16)
            make.width.height.equalTo(24)
            make.centerY.equalTo(titleLabel)
        }
        titleLabel.text = deviceModel.showName
    }
    
    // 添加套餐内视图，并且添加使用提示语
    func addChooseTypeContent(_ models: [PackageModel], _ device: WashingModel) {
        if models.count == 0 {
            return
        }
        
        var tmpBtn: UIButton! // 辅助布局
        for i in 0 ..< models.count {
            let bgButton = UIButton(type: .custom)
            bgButton.backgroundColor = UIColor.white
            bgButton.adjustsImageWhenHighlighted = false
            bgButton.clipsToBounds = true
            bgButton.tag = i
            bgButton.layer.cornerRadius = 8
            bgButton.addTarget(self, action: #selector(clickChooseTypeBtn(_:)), for: UIControl.Event.touchUpInside)
            chooseTypeView.addSubview(bgButton)
            bgButton.snp.makeConstraints({ (make) in
                if i == 0 {
                    make.top.equalToSuperview()
                } else {
                    make.top.equalTo(tmpBtn.snp.bottom).offset(16)
                }
                make.left.equalToSuperview()
                make.width.equalTo(BOUNDS_WIDTH-32)
                if i == models.count - 1 {
                    make.bottom.equalTo(-16)
                }
            })
            tmpBtn = bgButton
            
            let icon = UIImageView()
            bgButton.addSubview(icon)
            icon.contentMode = .scaleAspectFill
            icon.kf.setImage(with: URL.init(string: models[i].icon ?? ""),
                             placeholder: nil,
                             options: [.transition(ImageTransition.fade(1))])
            icon.snp.makeConstraints({ (make) in
                make.top.equalTo(16)
                make.left.equalTo(0)
                make.width.equalTo(72)
                make.height.equalTo(48)
            })
            
            let selectBtn = UIButton(type: .custom)
            selectBtn.setImage(UIImage(named: "pay_choose"), for: .normal)
            selectBtn.setImage(UIImage(named: "pay_choose_ed"), for: .selected)
            selectBtn.isUserInteractionEnabled = false
            chooseTypeSelectBtns.append(selectBtn)
            bgButton.addSubview(selectBtn)
            selectBtn.snp.makeConstraints({ (make) in
                make.right.equalTo(-24)
                make.centerY.equalToSuperview()
                make.width.height.equalTo(24)
            })
            
            let moneyLabel = UILabel()
            bgButton.addSubview(moneyLabel)
            moneyLabel.textColor = UIColor(rgb: 0xFF7733)
            moneyLabel.font = font_PingFangSC_Medium(12)
            let priceStr = String(format: "%.2f", models[i].spend!.floatValue/100.0)
            let money = priceStr + " " + "元"
            let priceAttStr = NSMutableAttributedString(string: money)
            priceAttStr.addAttributes([NSAttributedString.Key.font: font_PingFangSC_Medium(16)], range: (priceStr as NSString).range(of: priceStr))
            moneyLabel.attributedText = priceAttStr
            moneyLabel.snp.makeConstraints({ (make) in
                make.right.equalTo(-64)
                make.centerY.equalToSuperview()
            })
            
            let titleLabel = UILabel()
            bgButton.addSubview(titleLabel)
            titleLabel.textColor = UIColor(rgb: 0x333333)
            titleLabel.font = font_PingFangSC_Medium(14)
            titleLabel.text = models[i].name
            titleLabel.snp.makeConstraints({ (make) in
                make.top.equalTo(30)
                make.left.equalTo(72)
                make.right.equalTo(-130)
                make.height.greaterThanOrEqualTo(20)
                make.bottom.equalTo(-30)
            })
            
            if i == 0 {
                selectBtn.isSelected = true
            }
        }
        
        chooseTypeView.addSubview(useAlertLabel)
        useAlertLabel.text = device.useAlertString
        useAlertLabel.snp.makeConstraints { (make) in
            make.top.equalTo(tmpBtn.snp.bottom).offset(10)
            make.width.equalTo(BOUNDS_WIDTH-32)
            make.left.bottom.equalToSuperview()
        }
    }
    
    private func addBottomButton() {
        let bgView = UIView()
        bgView.backgroundColor = .white
        addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(BOTTOM_SAFE_HEIGHT + 64)
        }
        
        let button = UIButton()
        button.setTitle("立即支付", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.adjustsImageWhenHighlighted = false
        button.titleLabel?.font = font_PingFangSC_Medium(14)
        button.layer.cornerRadius = 24
        button.addTarget(self, action: #selector(clickBottom(_:)), for: .touchUpInside)
        button.backgroundColor = UIColor(rgb: 0x3399FF)
        bgView.addSubview(button)
        button.snp.makeConstraints({ (make) in
            make.top.equalTo(12)
            make.centerX.equalToSuperview()
            make.width.equalTo(280)
            make.height.equalTo(48)
        })
    }
    
    private func addAlertView() {
        addSubview(promptView)
        promptView.addSubview(promptLabel)
        promptView.addSubview(promptIcon)
        
        promptLabel.snp.makeConstraints { (make) in
            make.left.centerX.equalToSuperview().offset(12.5)
            make.centerY.equalToSuperview()
        }
        promptIcon.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(22.5)
            make.width.height.equalTo(20)
        }
        promptView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-50 - 15)
            make.width.equalTo(self.promptLabel.textWidth + 70)
            make.height.equalTo(30)
        }
    }
    
    fileprivate lazy var auxiliaryView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    lazy var baseInfoView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.addShadow(offset: CGSize(width: 0, height: 4), opacity: 1, color: UIColor.black.withAlphaComponent(0.1), radius: 10)
        view.layer.cornerRadius = 20
        return view
    }()
    
    lazy var chooseTypeView: UIScrollView = {
       let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = UIColor.clear
        return scrollView
    }()
    fileprivate lazy var icon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "location_black")
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = font_PingFangSC_Medium(14)
        label.textColor = DEEPCOLOR
        label.numberOfLines = 0
        return label
    }()
    
    lazy var useAlertLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = UIColor_0x(0xaaaaaa)
        return label
    }()
    
    lazy var promptView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor_0x(0xd2efff)
        view.setRoundCornerRadius()
        return view
    }()
    
    lazy var promptLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = UIColor_0x(0x27acf3)
        label.text = "请确保您在设备旁，尽快取走商品哦！"
        return label
    }()
    
    lazy var promptIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "prompt_blue")
        return imageView
    }()
}
