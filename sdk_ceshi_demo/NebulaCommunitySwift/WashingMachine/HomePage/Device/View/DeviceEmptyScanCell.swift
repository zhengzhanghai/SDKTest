//
//  DeviceEmptyScanCell.swift
//  WashingMachine
//
//  Created by zzh on 2017/8/25.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

import UIKit

class DeviceEmptyScanCell: BaseTableViewCell, UITextViewDelegate {
    
    var clickScanClourse: (()->())?
    
    override func createUI() {
        
        self.selectionStyle = .none
        self.contentView.backgroundColor = BACKGROUNDCOLOR
        
        let bgView = UIView()
        bgView.backgroundColor = UIColor.white
        contentView.addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.top.equalTo(16)
            make.height.equalTo(80)
            make.bottom.equalToSuperview()
        }
        
        let label = UILabel()
        
        let text = "欢迎使用星云社区！请您扫一扫星云设备"
        let attbuString = NSMutableAttributedString(string: text)
        attbuString.addAttribute(NSAttributedString.Key.foregroundColor, value: THEMECOLOR, range: NSMakeRange(11, 3))
        label.attributedText = attbuString
        
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 0
        bgView.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.width.equalTo(BOUNDS_WIDTH-60)
            make.centerX.centerY.equalToSuperview()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
