//
//  StarCoinsConsumptionRecord.swift
//  WashingMachine
//
//  Created by Harious on 2018/4/2.
//  Copyright © 2018年 Eteclabeteclab. All rights reserved.
//

import UIKit

class StarCoinsConsumptionRecord: ZZHModel {
    var id: NSNumber?
    /// 充值金额
    var nebulaCoin: NSNumber?
    /// 充值用户id
    var accountId: NSNumber?
    /// 消费类型（1：消费；2：退款）
    var type: NSNumber?
    /// 状态（0：无效；1：有效）
    var status: NSNumber?
    /// 创建时间
    var createTime: NSNumber?
    /// 展示名称
    var showName: String?
    /// 订单号
    var orderSn: String?
    
    var nebulaCoinStr: String {
        guard let nebulaCoin = nebulaCoin?.floatValue else { return "__" }
        
        return (nebulaCoin/100).string(decimalPlaces: 2)
    }
}
