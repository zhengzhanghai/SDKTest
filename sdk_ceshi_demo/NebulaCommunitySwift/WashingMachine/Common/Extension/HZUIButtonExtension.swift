//
//  HZUIButtonExtension.swift
//  WashingMachine
//
//  Created by Harious on 2018/2/2.
//  Copyright © 2018年 Eteclabeteclab. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    
    enum EdgeInsetsStyle {
        case up  // image在上，label在下
        case left  // image在左，label在右
        case bottom  // image在下，label在上
        case right   // image在右，label在左
    }
    
    func layout(forEdgeInsetsStyle style: EdgeInsetsStyle, imageTitleSpace space: CGFloat) {
        self.layoutIfNeeded()
        
        let imageWidth = imageView?.hz_width ?? 0
        let imageHeight = imageView?.hz_height ?? 0
        
        let labelWidth: CGFloat = titleLabel?.intrinsicContentSize.width ?? 0
        let labelHeight: CGFloat = titleLabel?.intrinsicContentSize.height ?? 0
        
        var imageEngeInsets = UIEdgeInsets.zero
        var labelEngeInsets = UIEdgeInsets.zero
        
        switch style {
        case .up:
            imageEngeInsets = UIEdgeInsets(top: -labelHeight-space/2.0, left: 0, bottom: 0, right: -labelWidth)
            labelEngeInsets = UIEdgeInsets(top: 0, left: -imageWidth, bottom: -imageHeight-space/2.0, right: 0)
        case .left:
            imageEngeInsets = UIEdgeInsets(top: 0, left: -space/2.0, bottom: 0, right: space/2.0)
            labelEngeInsets = UIEdgeInsets(top: 0, left: space/2, bottom: 0, right: -space/2)
        case .bottom:
            imageEngeInsets = UIEdgeInsets(top: 0, left: 0, bottom: -labelHeight-space/2, right: -labelWidth)
            labelEngeInsets = UIEdgeInsets(top: -imageHeight-space/2.0, left: -imageWidth, bottom: 0, right: 0)
        case .right:
            imageEngeInsets = UIEdgeInsets(top: 0, left: labelWidth+space/2, bottom: 0, right: -labelWidth-space/2)
            labelEngeInsets = UIEdgeInsets(top: 0, left: -imageWidth-space/2, bottom: 0, right: imageWidth+space/2)
        }
        
        self.titleEdgeInsets = labelEngeInsets
        self.imageEdgeInsets = imageEngeInsets

    }


}
