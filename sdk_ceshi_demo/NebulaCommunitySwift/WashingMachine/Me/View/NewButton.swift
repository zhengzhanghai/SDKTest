//
//  NewButton.swift
//  Truck
//
//  Created by 张丹丹 on 16/9/12.
//  Copyright © 2016年 Eteclab. All rights reserved.
// 图文上下排列的button

import UIKit

class NewButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.imageView?.contentMode = .center
        self.titleLabel?.textAlignment = .center
        self.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        self.setTitleColor(UIColor.darkGray, for: UIControl.State())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        let imageW = contentRect.size.width
        let imageH = contentRect.size.height*0.6
        return CGRect(x: 0, y: 5, width: imageW, height: imageH)
    }
    
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        let titleY = contentRect.size.height*0.6
        let titleW = contentRect.size.width
        let titleH = contentRect.size.height - titleY
        return CGRect(x: 0, y: titleY, width: titleW, height: titleH)
    }


}
