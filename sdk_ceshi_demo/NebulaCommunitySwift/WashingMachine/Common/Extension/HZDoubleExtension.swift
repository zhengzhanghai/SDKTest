//
//  HZDoubleExtension.swift
//  WashingMachine
//
//  Created by Harious on 2017/10/24.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

import UIKit

extension Double {
    var stringValue: String {return "\(self)"}
    var CGFloatValue: CGFloat {return CGFloat(self)}
    /// 保留两位小数点
    var twoDecimalPlaces: String {return String.init(format: "%.2lf", self)}
    
    /// 保留小数点
    ///
    /// - Parameter count: 小数点位数
    /// - Returns: 返回一个字符串
    func keepDecimalPlaces(_ count: Int) -> String {
        let format = "%.\(count)lf"
        return String.init(format: format, self)
    }
    
    /// 时间戳转时间字符串, 转之前时间单位是us（微秒，1ms = 1000us）
    func timeStr(dateFormat: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let date = Date(timeIntervalSince1970: self/TimeInterval(1000))
        let dformatter = DateFormatter()
        dformatter.dateFormat = dateFormat
        return dformatter.string(from: date)
    }
}

