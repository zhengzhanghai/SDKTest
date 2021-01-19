//
//  WMGradientView.swift
//  WashingMachine
//
//  Created by ZZH on 2020/12/19.
//  Copyright © 2020 Eteclabeteclab. All rights reserved.
//

import UIKit


extension WMGradientView {
    enum GradientDirection {
        /// 垂直
        case horizontal
        /// 水平
        case vertical
        /// 倾斜
        case tilt
    }
}

class WMGradientView: UIView {
    
    private var direction: GradientDirection?
    private var colors: [UIColor]?
    private var gradientLayer: CALayer?
    
    func addGradientLayer(colors: [UIColor], direction: GradientDirection) {
        self.direction = direction
        self.colors = colors
        guard bounds.width > 0 && bounds.height > 0 else {
            return
        }
        _addGradientLayer()
    }
   
    private func _addGradientLayer() {
        guard let direction = direction else { return }
        guard let colors = colors else { return }
        
        // 移除原来的渐变layer
        gradientLayer?.removeFromSuperlayer()
        
        let layer = CAGradientLayer()
        layer.frame = bounds
        ///设置颜色
        layer.colors = colors.map({ (color) -> CGColor in return color.cgColor })
        ///设置颜色渐变的位置 （我这里是横向 中间点开始变化）
        layer.locations = [0,0.5,1]
        switch direction {
        case .horizontal:
            layer.startPoint = CGPoint(x: 0, y: 0)
            layer.endPoint = CGPoint(x: 1, y: 0)
        case .vertical:
            layer.startPoint = CGPoint(x: 0, y: 0)
            layer.endPoint = CGPoint(x: 0, y: 1)
        case .tilt:
            layer.startPoint = CGPoint(x: 0, y: 1)
            layer.endPoint = CGPoint(x: 1, y: 0)
        }
        
        self.layer.insertSublayer(layer, at: 0)
//        self.layer.addSublayer(layer)
        
        gradientLayer = layer
    }

    override func layoutSubviews() {
        if gradientLayer == nil {
            _addGradientLayer()
        }
    }
}


