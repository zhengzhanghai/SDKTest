//
//  OrderViewModel.swift
//  WashingMachine
//
//  Created by zzh on 2017/8/17.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

import UIKit

class OrderViewModel: NSObject {
    /// 跳转到订单详情
    ///
    /// - Parameters:
    ///   - orderId: 订单id
    ///   - superController: 父控制器
    class func pushOrderDetailsVC(_ orderId: NSNumber?,_ superController: BaseViewController?) {
        let vc = DealDetailViewController()
        vc.orderId = orderId
        superController?.pushViewController(vc)
    }
    
    /// 跳转到吹风机订单详情页
    class func pushBlowerOrderVC(orderId: String, superController: BaseViewController?, removeVCCount: Int = 0) {
        let blowerOrderVC = BlowerOrderDetailsViewController(orderId: orderId)
        blowerOrderVC.removeControllerCount = removeVCCount
        superController?.pushViewController(blowerOrderVC)
    }
    
    /// 取消订单
    ///
    /// - Parameters:
    ///   - userId: 用户id
    ///   - orderId: 订单号
    ///   - compeleteHandler: 回调闭包
    class func cancel(_ userId: String, _ orderId: String, _ compeleteHandler:((Bool, String)->())?) {
        let url = SERVICE_BASE_ADDRESS + API_GET_CANCEL_ORDER
        let parameters: [String: Any] = ["userId": userId,
                                               "orderSn": orderId]
        NetworkEngine.get(url, parameters: parameters) { (result) in
            compeleteHandler?(result.isSuccess, result.message)
        }
    }
    
    /// 通过设备查询该用户在使用过程中的订单
    ///
    /// - Parameters:
    ///   - productId: 设备id
    ///   - userId: 用户id
    ///   - compeleteHandler: 回调闭包
    class func inquiryOrder(_ productId: String,
                            _ userId: String,
                            _ compeleteHandler:((OrderDetailsModel?, String)->())?)
    {
        let url = SERVICE_BASE_ADDRESS + API_GET_ORDER_FORM_MACHINE
        let parameters = ["productId": productId, "userId": userId] as [String: AnyObject]
        NetworkEngine.get(url, parameters: parameters) { (result) in
            if result.isSuccess {
                if let dict = result.dataObj as? [String: Any] {
                    if let json = dict["data"] as? [String: AnyObject] {
                        let model = OrderDetailsModel.createOrder(json)
                        compeleteHandler?(model, result.message)
                        return
                    }
                }
            }
            compeleteHandler?(nil, result.message)
        }
    }
    
    /// 通过订单号查询订单
    ///
    /// - Parameters:
    ///   - orderId: 订单号
    ///   - compeleteHandler: 回调闭包
    class func inquiryOrder(_ orderId: String, _ compeleteHandler:((OrderDetailsModel?, String, Error?)->())?) {
        let url = API_GET_ORDER_DETAILS + orderId
        NetworkEngine.get(url, parameters: nil) { (result) in
            let message = result.message
            if let dict = result.dataObj as? [String: AnyObject] {
                if result.isSuccess {
                    
                    if let data = dict["data"] as? [String: AnyObject] {
                        let model = OrderDetailsModel.create_sub(data)
                        compeleteHandler?(model, message, result.error)
                        return
                    }
                }
            }
           compeleteHandler?(nil, message, result.error)
        }
    }
    
    /// 申请退款
    ///
    /// - Parameters:
    ///   - userId: 用户id
    ///   - orderId: 订单号
    ///   - reason: 退款原因
    ///   - compeleteClourse: 回调闭包
    class func applyForRefund(_ userId: String, _ orderId: String, _ reason: String, _ compeleteClourse:((Bool, String)->())?) {
        let url = SERVICE_BASE_ADDRESS + API_POST_ORDER_REFUND
        let params = ["userId": userId, "orderId": orderId, "memo": reason] as [String: AnyObject]
        NetworkEngine.postJSON(url, parameters: params) { (result) in
            compeleteClourse?(result.isSuccess, result.message)
        }
    }
    
    /// 预约下单
    ///
    /// - Parameters:
    ///   - userId: 用户id
    ///   - productId: 设备id
    ///   - packageId: 套餐id
    ///   - compeleteColurse: 回调闭包
    class func appointOrder(_ userId: String,
                            _ productId: String,
                            _ packageId: String,
                            _ compeleteColurse:((OrderDetailsModel?, String)->())?)
    {
        let url = API_POST_ORDER_APPOINTMENT
        var parameters = [String: Any]()
        parameters["userId"] = userId
        parameters["productId"] = productId
        parameters["packageId"] = packageId
        NetworkEngine.post(url, parameters: parameters) { (result) in
            if result.isSuccess {
                if let dict = result.dataObj as? [String: AnyObject] {
                    if let json = dict["data"] as? [String: AnyObject] {
                        compeleteColurse?(OrderDetailsModel.createOrder(json), result.message)
                        return
                    }
                }
            }
            compeleteColurse?(nil, result.message)
        }
    }
    
    /// 业务下单
    ///
    /// - Parameters:
    ///   - userId: 用户id
    ///   - productId: 设备id
    ///   - packageId: 套餐id
    ///   - compeleteColurse: 回调闭包
    class func order(_ userId: String,
                     _ productId: String,
                     _ packageId: String,
                     _ compeleteColurse:((OrderDetailsModel?, String)->())?) {
        let url = API_POST_ORDER
        var parameters = [String: Any]()
        parameters["userId"] = userId
        parameters["productId"] = productId
        parameters["packageId"] = packageId
        NetworkEngine.post(url, parameters: parameters) { (result) in
            if result.isSuccess {
                if let dict = result.dataObj as? [String: AnyObject] {
                    if let json = dict["data"] as? [String: AnyObject] {
                        compeleteColurse?(OrderDetailsModel.createOrder(json), result.message)
                        return
                    }
                }
            }
            compeleteColurse?(nil, result.message)
        }
    }
    
    /// 获取订单列表
    class func loadOrderList(type: String,
                             page: String = "1",
                             size: String = "20",
                             compeleteColurse:(([OrderDetailsModel]?, String, Error?)->())?)
    {
        let parameters = ["userId": getUserId(),
                          "bigStatus": type,
                          "page": page,
                          "size": size]
        NetworkEngine.get(API_GET_ORDER_LIST, parameters: parameters) { (result) in
            if result.code == 204 || result.isSuccess {

                var orders = [OrderDetailsModel]()
                if let items = result.dataObj["data"] as? [[String: Any]] {
                    for i in 0 ..< items.count {
                        orders.append(OrderDetailsModel.createOrder(items[i]))
                    }
                }
                compeleteColurse?(orders,
                                  result.message,
                                  result.error)
            } else {
                compeleteColurse?(nil,
                                  result.message,
                                  result.error)
            }
        }
    }


}
