//
//  CommonEquipmentCell.swift
//  WashingMachine
//
//  Created by Harious on 2018/1/11.
//  Copyright © 2018年 Eteclabeteclab. All rights reserved.
//

import UIKit

class CommonEquipmentCell: BaseTableViewCell {

    override func createUI() {
        super.createUI()
        sepline.isHidden = true
        self.contentView.backgroundColor = BACKGROUNDCOLOR
        self.selectionStyle = .none
        
        self.contentView.addSubview(bgView)
        bgView.addSubview(icon)
        bgView.addSubview(deviceNameLabel)
        bgView.addSubview(sepline)
        
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
        sepline.snp.makeConstraints { (make) in
            make.left.equalTo(12)
            make.right.equalTo(-12)
            make.top.equalTo(self.deviceNameLabel.snp.bottom).offset(17)
            make.height.equalTo(0.5)
        }
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
    
    lazy var deviceNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor_0x(0x666666)
        label.font = font_PingFangSC_Regular(12)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var sepline: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor_0x(0xe6e6e6)
        return view
    }()

}
