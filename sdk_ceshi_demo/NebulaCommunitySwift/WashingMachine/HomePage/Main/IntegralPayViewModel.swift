//
//  IntegralPayViewModel.swift
//  WashingMachine
//
//  Created by zzh on 2017/8/18.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

import UIKit

class IntegralPayViewModel: NSObject {
    class func pay(_ order: OrderDetailsModel, _ userId: String, _ compeleHandler:((Bool, String, Error?)->())?) {
        var parameters: [String: Any] = [String: AnyObject]()
        parameters["userId"] = userId
        parameters["orderId"] = (order.orderNo ?? "")
        var url: String = ""
        if order.orderFrom ?? false == 1 {
            url = SERVICE_BASE_ADDRESS + API_GET_ORDER_TRACK
        } else {
            url = SERVICE_BASE_ADDRESS + API_GET_ORDER_YUYUE_TRACK
        }
        NetworkEngine.get(url, parameters: parameters) { (result) in
            compeleHandler?(result.isSuccess, result.message, result.error)
        }
    }
}
