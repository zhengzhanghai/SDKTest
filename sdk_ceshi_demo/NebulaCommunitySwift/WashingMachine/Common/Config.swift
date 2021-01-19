//
//  Config.swift
//  WashingMachine
//
//  Created by zzh on 2017/9/18.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

import Foundation

/// 清洁流程类型
enum CleaningProcessType {
    case equipmentCoemmunication  // 设备通讯（目前涡轮洗衣机采用的模式）
    case onewayCommunication  // 单向通讯(目前吹分机、烘干机采用的模式)
    case other  // 单向通讯(目前吹分机、烘干机采用的模式)
}



//MARK: - 微信相关  WECHAT
let WXPaySuccessNotification = "WeixinPaySuccessNotification"
let WXAPPID = "wx5199f2a6aceb216e"
let WXSECRET = "ab16e91bd9ed2f2fb6922d1b7ea6b115"
let WXPartnerId = "1411270102" ////微信商户号 洗衣机


//MARK: - 支付宝相关  AliPay
let AlipayPartner:String = "2088521210863073"//Partner
let AlipaySeller:String = "zhaokai@qtmob.com"//Seller
let AlipayAppId:String = "2016110802643449"//appid
let AppScheme:String = "com.nebula.alipay"


//MARK: 极光推送
// 测试
//let JPush_APPKEY = "8aa9c9ce8494fc69d81ce40b"
// 正式
let JPush_APPKEY = "29fbbfedae276d6eb2faeb7c"
// 正式
let JPush_SECRET = "7b984b7ea395d2a1df6b3cee"
let JPush_RegistrationID_Key = "JPush_RegistrationID_Key"

//MARK: - 登录、退出登录 的通知名
let LOGIN_SUCCESS_NOTIFICATION = "loginSuccessNotification"
let LOGIN_OUT_NOTIFICATION = "loginOutNotification"


//MARK: ******  工程中相关颜色 *********
let GRAYCOLOR       = UIColor(rgb:0x666666)///灰色字体
//let THEMECOLOR      = UIColorRGB(39, 172, 243, 1)
let THEMECOLOR      = UIColor(rgb:0x27acf3)
let UNDERTINTCOLOR  = UIColor(rgb:0x999999) // 浅色
let DEEPCOLOR       = UIColor(rgb:0x333333) // 深色
let GREENCOLOR      = UIColor(rgb:0x08c847) // 绿色按钮
let BACKGROUNDCOLOR = UIColor(rgb:0xfafafa) // 浅灰色背景
let THEMEBLACKCOLOR = UIColor(rgb: 0x0F0F0F)    // 字体黑色
let THEMEGRAYCOLOR  = UIColor(rgb: 0x666666)    // 字体二级灰色



