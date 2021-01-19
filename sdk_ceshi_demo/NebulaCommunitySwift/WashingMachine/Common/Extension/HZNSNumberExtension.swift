//
//  HZNSNumberExtension.swift
//  WashingMachine
//
//  Created by Harious on 2017/10/24.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

import UIKit

extension NSNumber {
    var twoDecimalPlaces: String {return String.init(format: "%.2lf", self.doubleValue)}
    var CGFloatValue: CGFloat {return CGFloat(self.floatValue)}
    // 转换成字符串，并保留小数点
    func keepDecimalPlaces(_ count: Int) -> String {
        let format = "%.\(count)lf"
        return String.init(format: format, self.doubleValue)
    }
    
    /// 时间戳转时间字符串, 转之前时间单位是us（微秒，1ms = 1000us）
    func timeStr(dateFormat: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let date = Date(timeIntervalSince1970: self.doubleValue/TimeInterval(1000))
        let dformatter = DateFormatter()
        dformatter.dateFormat = dateFormat
        return dformatter.string(from: date)
    }
}


