//
//  CommonEquipmentOfflineCell.swift
//  WashingMachine
//
//  Created by Harious on 2018/1/11.
//  Copyright © 2018年 Eteclabeteclab. All rights reserved.
//

import UIKit

class CommonEquipmentDisabledCell: CommonEquipmentCell {

    override func createUI() {
        super.createUI()
        
        bgView.addSubview(statusLabel)
        bgView.addSubview(surplusTimeTagLabel)
        bgView.addSubview(surplusTimeLabel)
        
        statusLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-4)
            make.centerY.equalToSuperview()
            make.width.equalTo(88)
        }
        surplusTimeTagLabel.snp.makeConstraints { (make) in
            make.top.equalTo(22)
            make.left.equalTo(56)
            make.height.equalTo(20)
        }
        surplusTimeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(surplusTimeTagLabel.snp.right).offset(8)
            make.bottom.equalTo(surplusTimeTagLabel)
        }
        deviceNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(surplusTimeTagLabel)
            make.top.equalTo(surplusTimeTagLabel.snp.bottom).offset(8)
            make.right.equalTo(-96)
            make.bottom.equalTo(-14)
        }
    }
    
    lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor_0x(0x3399FF)
        label.font = font_PingFangSC_Regular(12)
        label.textAlignment = .center
        return label
    }()
    
    lazy var surplusTimeTagLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor_0x(0x333333)
        label.font = font_PingFangSC_Regular(14)
        label.text = "剩余时长"
        return label
    }()
    
    lazy var surplusTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor_0x(0x333333)
        label.font = font_PingFangSC_Semibold(20)
        return label
    }()

}
