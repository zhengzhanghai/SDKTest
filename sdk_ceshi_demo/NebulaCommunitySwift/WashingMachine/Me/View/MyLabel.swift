//
//  MyLabel.swift
//  Truck
//
//  Created by 张丹丹 on 16/9/20.
//  Copyright © 2016年 Eteclab. All rights reserved.
//  划下划线的label

import UIKit

class MyLabel: UILabel {

    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let context = UIGraphicsGetCurrentContext()
        
        self.textColor.setStroke()
        
        context?.move(to: CGPoint(x: 0, y: rect.size.height/2+4))
       
        context?.addLine(to: CGPoint(x: rect.size.width, y: rect.size.height/2+4))
     
        context?.strokePath()
    
    }

}
