//
//  HZUIViewExtension.swift
//  WashingMachine
//
//  Created by zzh on 2017/9/12.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    public var hz_x:CGFloat {
        get {
            return frame.origin.x
        }
        set {
            var rect = frame
            rect.origin.x = newValue
            frame = rect
        }
    }
    
    public var hz_y:CGFloat {
        get {
            return frame.origin.y
        }
        set {
            var rect = frame
            rect.origin.y = newValue
            frame = rect
        }
    }
    
    public var hz_width:CGFloat {
        get {
            return frame.size.width
        }
        set {
            var rect = frame
            rect.size.width = newValue
            frame = rect
        }
    }
    
    public var hz_height:CGFloat {
        get {
            return frame.size.height
        }
        set {
            var rect = frame
            rect.size.height = newValue
            frame = rect
        }
    }
    
    public var hz_size:CGSize {
        get {
            return frame.size
        }
        set {
            var rect = frame
            rect.size = newValue
            frame = rect
        }
    }
    
    public var hz_origin:CGPoint {
        get {
            return frame.origin
        }
        set {
            var rect = frame
            rect.origin = newValue
            frame = rect
        }
    }
    
    public var hz_center:CGPoint {
        get {
            return self.center
        }
        set {
            self.center = newValue
        }
    }
    
    public var hz_centerX:CGFloat {
        get {
            return self.center.x
        }
        set {
            self.center.x = newValue
        }
    }
    
    public var hz_centerY:CGFloat {
        get {
            return self.center.y
        }
        set {
            self.center.y = newValue
        }
    }
    
    public func removeAllSubView() {
        for view in self.subviews {
            view.removeFromSuperview()
        }
    }
}

//MARK: --------------- 设置圆角相关 ------------------
extension UIView {
    
    /// 设置圆角，如果还需要加边框，不能用此方法
    func setCornerRadius(cornerRadii: CGFloat,
                         direction: UIRectCorner = .allCorners)
    {
        if self.bounds.size.height != 0 && self.bounds.size.width != 0 { // 使用Masonry布局后，view的bounds是异步返回的，这里需要做初步的判断
            let maskPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: cornerRadii)
            let maskLayer = CAShapeLayer()
            maskLayer.frame = self.bounds
            maskLayer.path = maskPath.cgPath
            self.layer.mask = maskLayer
        } else { // 如果没有获取到view的bounds时
            DispatchQueue.main.async {
                self.setCornerRadius(cornerRadii: cornerRadii, direction: direction)
            }
        }
    }
    
    /// 设置圆形圆角(高的一半)
    func setRoundCornerRadius() {
        if self.bounds.size.width == 0 || self.bounds.size.height == 0 {
            DispatchQueue.main.async {
                self.setCornerRadius(cornerRadii: self.bounds.size.height/2, direction: .allCorners)
            }
        } else {
            self.setCornerRadius(cornerRadii: self.bounds.size.height/2, direction: .allCorners)
        }
    }
}

extension UIView {
    func addShadow(offset: CGSize, opacity: Float, color: UIColor? = nil, radius: CGFloat? = nil) {
        layer.shadowOffset = offset
        layer.shadowOpacity = opacity
        if let color = color {
            layer.shadowColor = color.cgColor
        }
        if let radius = radius {
            layer.shadowRadius = radius
        }
        
        // 一下设置防止卡顿
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
}
