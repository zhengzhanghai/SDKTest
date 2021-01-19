//
//  NCPayMessage.swift
//  WashingMachine
//
//  Created by zzh on 2017/7/17.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

import UIKit

class NCPayMessage {
    /// 订单id
    var orderId: String?
    /// appId
    var appId: String!
    /// 业务订单号
    var orderSn: String!
    /// 价格, 整数, 单位分
    var amount: String!
    /// 支付渠道
    var channel: NCPayChannel!
    /// 商品标题
    var subject: String!
    /// 商品描述
    var body: String!
    
    
    /// 自定义的支付渠道,用于支持一个appId中有多个支付账号
    var customChannel: String?
    /// 产品代码, 微信扫描支付时必填
    var productCode: String?
    
    init(order: OrderDetailsModel, payWay: PayWay) {
        orderId = order.id?.stringValue ?? ""
        appId = order.p_appId ?? ""
        orderSn = order.orderNo ?? ""
        amount = String(format: "%d", (order.spend?.intValue) ?? 0)
        body = "星云社区"
        subject = "星云社区服务消费"
        if payWay == .alipay {
            channel = .alipay
        } else if payWay == .wx {
            channel = .wechat
        } else if payWay == .nebula {
            channel = .nebula
        }
    }
    
    init(appId: String,
         orderSn: String,
         amount: String,
         channel: NCPayChannel,
         subject: String,
         body: String,
         orderId: String? = nil,
         customChannel: String? = nil,
         productCode: String? = nil)
    {
        self.appId = appId
        self.orderSn = orderSn
        self.amount = amount
        self.channel = channel
        self.body = body
        self.subject = subject
        self.orderId = orderId
        self.customChannel = customChannel
        self.productCode = productCode
    }
    
//    case wechat = "wx" //微信
//    case alipay = "alipay" //支付宝
//    case wechatPublic = "wx_pub" //微信公众号支付
}
