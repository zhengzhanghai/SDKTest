//
//  HomeNoDeviceDataView.swift
//  WashingMachine
//
//  Created by ZZH on 2020/12/19.
//  Copyright © 2020 Eteclabeteclab. All rights reserved.
//

import UIKit

class HomeNoDeviceDataView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "")
        addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.top.centerX.equalToSuperview()
            make.width.height.equalTo(120)
        }
        
        let label = UILabel()
        label.font = font_PingFangSC_Regular(14)
        label.textColor = UIColor(rgb: 0x666666)
        label.textAlignment = .center
        let text = "欢迎使用星云社区！请您 扫一扫 星云设备"
        let attstr = NSMutableAttributedString(string: text)
        attstr.addAttributes([NSAttributedString.Key.foregroundColor: UIColor(rgb: 0x3399ff)], range: NSRange(location: 12, length: 3))
        label.attributedText = attstr
        addSubview(label)
        label.snp_makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(24)
            make.left.equalTo(16)
            make.right.equalTo(16)
            make.bottom.equalToSuperview()
        }
        
        imageView.backgroundColor = .orange
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
