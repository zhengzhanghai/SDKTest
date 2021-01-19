//
//  AppointAndPayView.swift
//  WashingMachine
//
//  Created by zzh on 17/3/8.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

import UIKit

class AppointAndPayView: UIView {
    
    var appointOrPayClourse: ((Int)->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        self.configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func configUI() {
        let titles = ["预约", "立即启动"]
        let btnWidth: CGFloat = 155
        let leftMargin = (BOUNDS_WIDTH - 2 * btnWidth - 18) / 2
        let margin: CGFloat = 18
        for i in 0 ..< titles.count {
            let button = UIButton()
            button.frame = CGRect(x: leftMargin + (btnWidth+margin)*CGFloat(i), y: 12, width: btnWidth, height: 40)
            self.addSubview(button)
            button.tag = i
            button.setTitle(titles[i], for: .normal)
            button.setTitleColor(UIColor.white, for: .normal)
            button.adjustsImageWhenHighlighted = false
            button.titleLabel?.font = font_PingFangSC_Medium(14)
            button.layer.cornerRadius = 20
            button.addTarget(self, action: #selector(clickButton(_:)), for: .touchUpInside)
            if titles[i] == "预约"{
                button.backgroundColor = UIColor(rgb: 0xFF7733)
            } else if titles[i] == "立即启动"{
                button.backgroundColor = UIColor(rgb: 0x3399FF)
            }
        }
    }
    
    @objc fileprivate func clickButton(_ button: UIButton) {
        if appointOrPayClourse != nil {
            appointOrPayClourse!(button.tag)
        }
    }
    
}
