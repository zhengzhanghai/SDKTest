//
//  NCPayResult.swift
//  WashingMachine
//
//  Created by zzh on 2017/7/17.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

import UIKit

enum NCPayResultType: Int {
    case success // 成功(回调结果)
    case inProgress // 处理中，结果未知(回调结果)
    case defeated // 失败(回调结果)
    case rePayRequest // 重复请求(回调结果)
    case cancel // 取消支付(回调结果)
    case networkError // 网络连接出错(回调结果)
    case unKnown // 支付结果未知（有可能已经支付成功）(回调结果)
    case otherError // 其他支付错误(回调结果)
    case beforePayError  // 吊起支付前错误(吊起支付前会与本服务器交互异常情况)
    case notInstalled    // 没有安装相关软件（吊起支付前的结果）
    case beforeEvokePayApp   //  调起支付app或者网页支付前最后回调
}

class NCPayResult: NSObject {
    /// 支付结果类型,默认未知
    var type: NCPayResultType = .unKnown
    /// 支付结果描述
    var desp: String = ""
}


