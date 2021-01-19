//
//  HZIntExtenxion.swift
//  WashingMachine
//
//  Created by Harious on 2017/10/24.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

import UIKit

extension Int {
    var FloatValue: Float {return Float(self)}
    var DoubleValue: Double {return Double(self)}
    var CGFloatValue: CGFloat {return CGFloat(self)}
    var stringValue: String {return "\(self)"}
    
    /// 时间戳转时间字符串, 转之前时间单位是us（微秒，1ms = 1000us）
    func timeStr(dateFormat: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(self)/TimeInterval(1000))
        let dformatter = DateFormatter()
        dformatter.dateFormat = dateFormat
        return dformatter.string(from: date)
    }
    
    /// 将ms转换成时分秒
    func transToCommonTimeFromMS() -> String {
        guard self >= 0 else {
            return "00:00:00"
        }
        let s = Int(self/1000%60)
        let m = Int(self/1000/60%60)
        let h = Int(self/1000/60/60)
        return String(format: "%02d:%02d:%02d",h, m, s)
    }
}
