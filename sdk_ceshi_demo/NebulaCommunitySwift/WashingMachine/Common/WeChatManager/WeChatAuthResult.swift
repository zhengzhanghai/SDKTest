//
//  WeChatAuthResult.swift
//  WashingMachine
//
//  Created by zzh on 2017/9/6.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

import UIKit

enum WeChatAuthResultType {
    case startCallBack // 刚从微信回调回来
    case authStatusError  // 认证的status错误
    case cancel  // 取消了认证
    case requestUrlError  // 获取token、openid，用户信息时发生异常
    case success //成功
    case other //其他
}

class WeChatAuthResult: NSObject {
    var type: WeChatAuthResultType = .other
    var desp: String = "未知错误"
    var headimgurl: String?
    var privilege: [Any]?
    var openId: String?
    var nickname: String?
    var sex: NSNumber?
    var country: String?
    var province: String?
    var city: String?
}
