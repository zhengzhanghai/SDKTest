//
//  WXPay.swift
//  Truck
//
//  Created by Moguilay on 16/9/20.
//  Copyright © 2016年 Eteclab. All rights reserved.
//

import Foundation

/**
 *  微信支付Model
 */
struct WXPay {
    let appID: String
    let noncestr: String
    let package: String
    let partnerID: String
    let prepayID: String
    let sign: String
    let timestamp: Int
    
    init(appID: String,
         noncestr: String,
         package: String,
         partnerID: String,
         prepayID: String,
         sign: String,
         timestamp: Int) {
        self.appID = appID
        self.noncestr = noncestr
        self.package = package
        self.partnerID = partnerID
        self.prepayID = prepayID
        self.sign = sign
        self.timestamp = timestamp
    }
}

//                    let result_code = dic.objectForKey("result_code") as? String
//
//                    if return_code == "SUCCESS" && result_code == "SUCCESS" {
//                        let trade_state = dic.objectForKey("trade_state") as? String
//
//                        print("验证结果---->>>> ::::\(trade_state)")

//                        if trade_state == "SUCCESS" {
//
//                            //支付成功
//                            self.payResultMsg = "成功"
//                            //记录充值记录,发送记录充值记录的请求

//                        }else{
//                            ///支付失败
//                            self.payResultMsg = "失败"
//                        }

//                    }else{
//                        ///支付失败
//                        self.payResultMsg = "失败"
//                    }
//这里可以向外面跑消息,给需要得知支付结果后才能处理下一步的控制器

//                    if self.payResultClourse != nil {
//
//                        self.payResultClourse!(self.payResultMsg!)
//
//                    }
