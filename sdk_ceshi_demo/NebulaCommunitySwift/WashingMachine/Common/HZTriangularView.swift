//
//  HZTriangularView.swift
//  WashingMachine
//
//  Created by Harious on 2018/2/26.
//  Copyright © 2018年 Eteclabeteclab. All rights reserved.
//

import UIKit

///  绘制的一个三角形视图△
class HZTriangularView: UIView {
    
    var fillColor: UIColor
    
    init(frame: CGRect, fillColor: UIColor) {
        self.fillColor = fillColor
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let contextRef = UIGraphicsGetCurrentContext()
        contextRef?.setFillColor(fillColor.cgColor)
        contextRef?.setStrokeColor(UIColor.clear.cgColor)
        contextRef?.move(to: CGPoint(x: self.hz_width/2, y: 0))
        contextRef?.addLine(to: CGPoint(x: 0, y: self.hz_height))
        contextRef?.addLine(to: CGPoint(x: self.hz_width, y: self.hz_height))
        contextRef?.addLine(to: CGPoint(x: self.hz_width/2, y: 0))
        contextRef?.drawPath(using: CGPathDrawingMode.fill)
    }

}
