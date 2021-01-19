//
//  HomeDeviceUsingCell.swift
//  WashingMachine
//
//  Created by Harious on 2018/1/11.
//  Copyright © 2018年 Eteclabeteclab. All rights reserved.
//

import UIKit

class HomeDeviceUsingCell: BaseTableViewCell {
    
    var operateActionClourse: (()->())?

    @objc fileprivate func operateAction(_ btn: UIButton) {
        operateActionClourse?()
    }
    
    override func createUI() {
        super.createUI()
        
        self.contentView.backgroundColor = BACKGROUNDCOLOR
        self.selectionStyle = .none
        
        self.contentView.addSubview(bgView)
        bgView.addSubview(icon)
        bgView.addSubview(remainingTimeLabel)
        bgView.addSubview(opearteBtn)
        bgView.addSubview(deviceNameLabel)
        
        bgView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.bottom.equalTo(-16)
        }
        icon.snp.makeConstraints { (make) in
            make.left.equalTo(19)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(23)
        }
        opearteBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-8)
            make.centerY.equalToSuperview()
            make.width.equalTo(80)
            make.height.equalTo(32)
        }
        remainingTimeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(56)
            make.top.equalTo(14)
            make.right.equalTo(-96)
            make.height.equalTo(28)
        }
        deviceNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(remainingTimeLabel)
            make.top.equalTo(remainingTimeLabel.snp.bottom).offset(8)
            make.right.equalTo(-96)
            make.bottom.equalTo(-14)
        }

    }
    
    func setOperationBtnStyle(isBlueStyle: Bool) {
        opearteBtn.backgroundColor = isBlueStyle ? UIColor(rgb: 0x3399ff) : UIColor(rgb: 0xffffff)
        opearteBtn.layer.borderWidth = isBlueStyle ? 0 : 1
        opearteBtn.setTitleColor(isBlueStyle ? UIColor(rgb: 0xffffff) : UIColor(rgb: 0x333333), for: .normal)
    }
    
    lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 8
        view.addShadow(offset: CGSize(width: 0, height: 4), opacity: 1, color: UIColor(rgb: 0x000000).withAlphaComponent(0.1), radius: 10)
        return view
    }()
    
    lazy var icon: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    lazy var remainingTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(rgb: 0x333333)
        label.font = font_PingFangSC_Regular(13)
        return label
    }()
    
    lazy var deviceNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor_0x(0x666666)
        label.font = font_PingFangSC_Regular(12)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var opearteBtn: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(UIColor_0x(0x4a4a4a), for: .normal)
        btn.titleLabel?.font = font_PingFangSC_Medium(12)
        btn.layer.borderColor = UIColor_0x(0xdbdbdb).cgColor
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 16
        btn.addTarget(self, action: #selector(operateAction(_:)), for: .touchUpInside)
        return btn
    }()
    

}
