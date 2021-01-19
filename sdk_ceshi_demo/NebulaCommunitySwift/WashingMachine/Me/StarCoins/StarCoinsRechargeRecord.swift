//
//  StarCoinsRechargeRecord.swift
//  WashingMachine
//
//  Created by Harious on 2018/4/2.
//  Copyright © 2018年 Eteclabeteclab. All rights reserved.
//

import UIKit

class StarCoinsRechargeRecord: ZZHModel {
    var id: NSNumber?
    /// 充值金额 ,单位分
    var price: NSNumber?
    /// 充值的星币数量， 单位分
    var nebulaCoin: NSNumber?
    /// 充值用户id
    var accountId: NSNumber?
    /// 充值类型 1 支付宝  2 微信
    var payType: NSNumber?
    /// 状态（0：充值预订单（充值失败）；1：充值成功；2：充值失败）
    var status: NSNumber?
    /// 创建时间
    var createTime: NSNumber?
    /// 订单号
    var rechargeNo: String?
    
    /// 支付类型str
    var payTypeStr: String {
        guard let payType = payType?.intValue else {
            return ""
        }
        
        switch payType {
        case 1: return "支付宝"
        case 2: return "微信"
        default: return ""
        }
    }
    
    /// 充值金额,单位元
    var priceStr: String {
        guard let price = price?.floatValue else {
            return "__"
        }
        let priceY = price/100
        return priceY >= 1 ? "\(Int(priceY))" : priceY.string(decimalPlaces: 2)
    }
    
    /// 充值的星币数量， 单位元
    var nebulaCoinStr: String {
        guard let nebulaCoin = nebulaCoin?.floatValue else {
            return "__"
        }
        return (nebulaCoin/100).string(decimalPlaces: 2)
    }
}
