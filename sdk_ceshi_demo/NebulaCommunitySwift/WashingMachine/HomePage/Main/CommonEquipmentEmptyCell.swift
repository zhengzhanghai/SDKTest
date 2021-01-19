//
//  CommonEquipmentCell.swift
//  WashingMachine
//
//  Created by Harious on 2018/1/11.
//  Copyright © 2018年 Eteclabeteclab. All rights reserved.
//

import UIKit

class CommonEquipmentEmptyCell: CommonEquipmentCell {
    
    var useClource: (()->())?
    
    override func createUI() {
        super.createUI()
        
        bgView.addSubview(useBtn)
        
        deviceNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(19)
            make.left.equalTo(56)
            make.right.equalTo(-96)
            make.bottom.equalTo(-19)
        }
        useBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-8)
            make.centerY.equalToSuperview()
            make.width.equalTo(80)
            make.height.equalTo(32)
        }
    }
    
    lazy var useBtn: UIButton = {
        let button = UIButton()
        button.setTitle("立即使用", for: .normal)
        button.titleLabel?.font = font_PingFangSC_Regular(12)
        button.setTitleColor(UIColor_0x(0x333333), for: .normal)
        button.addTarget(self, action: #selector(clickUse(_:)), for: .touchUpInside)
        button.isUserInteractionEnabled = false
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(rgb: 0xdbdbdb).cgColor
        return button
    }()
    
    @objc fileprivate func clickUse(_ btn: UIButton) {
        useClource?()
    }
}




