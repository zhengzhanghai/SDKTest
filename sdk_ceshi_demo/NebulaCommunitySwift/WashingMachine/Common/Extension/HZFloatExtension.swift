//
//  HZFloatExtension.swift
//  WashingMachine
//
//  Created by Harious on 2017/10/24.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

import UIKit

extension Float {
    
    var stringValue: String {return "\(self)"}
    var CGFloatValue: CGFloat {return CGFloat(self)}
    /// 保留两位小数点
    var twoDecimalPlaces: String {return String.init(format: "%.2f", self)}
    
    /// 保留小数点
    ///
    /// - Parameter count: 小数点位数
    /// - Returns: 返回一个字符串
    func keepDecimalPlaces(_ count: Int) -> String {
        let format = "%.\(count)f"
        return String.init(format: format, self)
    }
    
    
    /// 转换成字符串并保留小数点
    ///
    /// - Parameter decimalPlaces: 保留小数点位数
    /// - Returns: string
    func string(decimalPlaces: Int) -> String {
        let format = "%.\(decimalPlaces)f"
        return String.init(format: format, self)
    }
}


