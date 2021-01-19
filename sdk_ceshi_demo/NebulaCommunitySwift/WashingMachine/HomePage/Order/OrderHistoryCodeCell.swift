//
//  OrderHistoryCodeCell.swift
//  WashingMachine
//
//  Created by Harious on 2018/1/12.
//  Copyright © 2018年 Eteclabeteclab. All rights reserved.
//

import UIKit

class OrderHistoryCodeCell: BaseTableViewCell {

    override func createUI() {
        super.createUI()
        
        self.contentView.backgroundColor = BACKGROUNDCOLOR
        self.selectionStyle = .none
        
        self.contentView.addSubview(bgView)
        bgView.addSubview(auxiliaryView)
        auxiliaryView.addSubview(titleBGView)
        titleBGView.addSubview(deviceTypeNameLabel)
        titleBGView.addSubview(dateLabel)
        bgView.addSubview(statusLabel)
        bgView.addSubview(deviceNameLabel)
        bgView.addSubview(codeTagLabel)
        bgView.addSubview(codeLabel)
        
        bgView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.bottom.equalTo(-24)
        }
        auxiliaryView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(56)
        }
        titleBGView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(40)
        }
        deviceTypeNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(18)
            make.centerY.equalToSuperview()
        }
        dateLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-16)
            make.centerY.equalToSuperview()
        }
        deviceNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.right.equalTo(-96)
            make.top.equalTo(auxiliaryView.snp.bottom)
        }
        codeTagLabel.snp.makeConstraints { (make) in
            make.left.equalTo(deviceNameLabel)
            make.top.equalTo(deviceNameLabel.snp.bottom).offset(12)
            make.height.equalTo(20)
            make.bottom.equalTo(-20)
        }
        codeLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(codeTagLabel)
            make.left.equalTo(codeTagLabel.snp.right).offset(8)
            make.height.equalTo(28)
        }
        statusLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-16)
            make.centerY.equalTo(codeLabel.snp.top)
        }
    }
    
    lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 8
        view.addShadow(offset: CGSize(width: 0, height: 4), opacity: 1, color: UIColor(rgb: 0x000000).withAlphaComponent(0.1), radius: 10)
        return view
    }()
    
    lazy var auxiliaryView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
    
    lazy var titleBGView: WMGradientView = {
        let view = WMGradientView()
        return view
    }()
    
    lazy var deviceTypeNameLabel: UILabel = {
        let label = UILabel()
        label.font = font_PingFangSC_Medium(12)
        return label
    }()
    
    lazy var deviceNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor_0x(0x666666)
        label.font = font_PingFangSC_Regular(12)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor_0x(0xcccccc)
        label.font = font_PingFangSC_Regular(12)
        return label
    }()
    
    lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor_0x(0xaaaaaa)
        label.font = font_PingFangSC_Medium(14)
        return label
    }()
    
    lazy var codeTagLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(rgb: 0x333333)
        label.font = font_PingFangSC_Regular(14)
        label.text = "验证码"
        return label
    }()
    
    lazy var codeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(rgb: 0x333333)
        label.font = font_PingFangSC_Semibold(20)
        return label
    }()
}
