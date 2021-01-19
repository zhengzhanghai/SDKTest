//
//  HZColorExtexion.swift
//  WashingMachine
//
//  Created by zzh on 2017/9/18.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

import Foundation
import UIKit

// MARK: - UIColor 的扩展 可以添加16进制  将传入的16进制颜色值前面加0x
extension UIColor {
    convenience init(rgb: UInt, alpha: CGFloat = 1) {
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
}

//MARK: - 根据RGB获取UIcolor
/// 快捷创建UIColor
public func UIColorRGB(_ red: CGFloat, _ green:CGFloat, _ blue:CGFloat, _ alpha:CGFloat = 1) -> UIColor {
    return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
}

/// 快捷创建UIColor(传入十六进制色值)
public func UIColor_0x(_ rgb: Int,_ alpha: CGFloat = 1) -> UIColor {
    return UIColor.init(red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
                        green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
                        blue: CGFloat(rgb & 0x0000FF) / 255.0,
                        alpha: alpha)
}
