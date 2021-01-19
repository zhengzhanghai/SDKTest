//
//  ZHPictureValidationView.swift
//  IMageDemo
//
//  Created by 郑章海 on 2020/6/19.
//  Copyright © 2020 zzh. All rights reserved.
//

import UIKit

class ZHPictureValidationView: UIButton {
    
    var touchSelfAction: (() -> ())?
    private var drawedCharacters:[Character] = ["0", "0", "0", "0"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addTarget(self, action: #selector(onClickSelf), for: .touchUpInside)
    }
    
    @objc private func onClickSelf() {
        touchSelfAction?()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func drawCharacters(_ chars: [Character]) {
        drawedCharacters = chars
        backgroundColor = randomColor
        setNeedsDisplay()
    }
    
    /// 随机颜色
    private var randomColor: UIColor {
        return UIColor(red: CGFloat(arc4random() % 100) / 100,
                       green: CGFloat(arc4random() % 100) / 100,
                       blue: CGFloat(arc4random() % 100) / 100,
                       alpha: 0.5)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let rectWidth = rect.size.width
        let rectHeight = rect.size.height
                
        let text = String(drawedCharacters)
        let charWidth = rectWidth / CGFloat(text.count) - 15
        let charHeight = rectHeight - 25
        
        var pointX: CGFloat = 0
        var pointY: CGFloat = 0
        
        // 依次绘制文字
        for i in 0 ..< drawedCharacters.count {
            let char = drawedCharacters[i]
            pointX = CGFloat(arc4random() % UInt32(charWidth)) + rectWidth / CGFloat(text.count) * CGFloat(i)
            pointY = CGFloat(arc4random() % UInt32(charHeight))
            (String(char) as NSString)
                .draw(at: CGPoint(x: pointX, y: pointY),
                      withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: CGFloat(arc4random() % 10) + 15)])
        }

        let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(1)
        for _ in 0 ... 3 {
            context?.setStrokeColor(randomColor.cgColor)
            pointX = CGFloat(arc4random() % UInt32(rectWidth))
            pointY = CGFloat(arc4random() % UInt32(rectHeight))
            context?.move(to: CGPoint(x: pointX, y: pointY))
            
            pointX = CGFloat(arc4random() % UInt32(rectWidth))
            pointY = CGFloat(arc4random() % UInt32(rectHeight))
            context?.addLine(to: CGPoint(x: pointX, y: pointY))
            
            context?.strokePath()
        }
        
        context?.endPage()
    }
}
