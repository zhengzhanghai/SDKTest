//
//  ErrorExtension.swift
//  WashingMachine
//
//  Created by zzh on 2017/9/11.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

import Foundation

extension Error {
    
    var message : String {
        let ocError = self as NSError
        let code = ocError.code
        switch code {
        case -1:                return "未知错误code：-1"
        case -1003,-1004,-1009: return "网络未连接~"
        case -1001,-2000:       return "网络不给力~"
        case -999:              return "请求失败，请重试~"
        case -1011,-1008:       return "异常code:\(code)"
        case -1201,-1015,-1016: return "return异常code:\(code)"
        case -1005:             return "失去连接，请重试~"
        case -3006,-3007:       return "下载失败~"
        case -1000,-1002:       return "非法URL~"
        default:                return "未知错误code:\(code)"
        }
    }
}










