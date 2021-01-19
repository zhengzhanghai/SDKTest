//
//  DeviceViewModel.swift
//  WashingMachine
//
//  Created by zzh on 2017/8/17.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

import UIKit

class DeviceViewModel: NSObject {
//    /// 跳转到广告页
//    ///
//    /// - Parameters:
//    ///   - urlStr: 广告地址
//    ///   - superController: 父控制器
//    class func pushADSVC(_ urlStr: String?, _ superController: BaseViewController?) {
//        let vc = ADSWebViewController()
//        vc.urlString = urlStr
//        superController?.pushViewController(vc)
//    }
    
    /// 跳转到学校认证页
    ///
    /// - Parameter superController: 父控制器
    class func pushSchoolAccreditationVC(_ superController: BaseViewController?) {
        let vc = SchoolAccreditationController()
        superController?.pushViewController(vc)
    }
    
    /// 跳转到设备列表页
    ///
    /// - Parameters:
    ///   - school: 学校
    ///   - superVC: 父控制器
    class func pushMoreWashingListVC(_ school: School?, _ superVC: BaseViewController?) {
        let vc = WashingMoreViewController()
        vc.schoolPlace = school
        superVC?.pushViewController(vc)
    }
    
    /// 跳转到附近洗衣楼
    ///
    /// - Parameters:
    ///   - coordinate2D: 经纬度
    ///   - schoolId: 学校id
    ///   - superVC: 父视图
    class func pushNebyFloorVC(_ schoolId: String, _ superVC: BaseViewController?) {
        let vc = WashingFloorViewController()
        vc.schoolId = schoolId
        superVC?.pushViewController(vc)
    }
    
    /// 跳转到洗衣机详情下单页
    ///
    /// - Parameters:
    ///   - model: 洗衣机信息
    ///   - superVC: 父控制器
    ///   - removeVCCount: 跳转后移除导航控制器子控制器的数量
    class func pushWashingPayVC(_ model: WashingModel, _ superVC: BaseViewController?, removeVCCount: Int = 0) {
        let vc = WashingDetailsViewController()
        vc.machineModel = model
        vc.removeControllerCount = removeVCCount
        superVC?.pushViewController(vc)
    }
    
    /// 跳转到支付失败页
    ///
    /// - Parameters:
    ///   - orderModel: 订单
    ///   - superVC: 父控制器
    ///   - removeVCCount: 跳转后移除导航控制器子控制器的数量
    class func pushPayFailureVC(_ orderModel: OrderDetailsModel, _ superVC: BaseViewController?, _ removeVCCount: Int = 0) {
        let vc = PayFailureViewController()
        vc.orderModel = orderModel
        vc.removeControllerCount = removeVCCount
        superVC?.pushViewController(vc)
    }
    
    /// 跳转到支付成功页
    ///
    /// - Parameters:
    ///   - spendMoney: 花费金额
    ///   - orderId: 订单号
    ///   - isImmediateUse: 是否立即支付
    ///   - superVC: 父控制器
    ///   - removeVCCount: 跳转后移除导航控制器子控制器的数量
    class func pushPaySuccessVC(_ order: OrderDetailsModel?, _ superVC: BaseViewController?, _ removeVCCount: Int = 0) {
        let vc = PaySuccessViewController()
        vc.order = order
//        vc.money = spendMoney
//        vc.orderId = orderId
//        vc.isImmediateUse = isImmediateUse
        vc.removeControllerCount = removeVCCount
        superVC?.pushViewController(vc)
    }
    
    /// 跳转到扫码页
    ///
    /// - Parameter superVC: 父控制器
    class func pushScanVC(_ superVC: BaseViewController?) {
        let vc = ScanViewController()
        superVC?.pushViewController(vc)
    }
    
    /// 跳转到订单页
    ///
    /// - Parameter superVC: 父控制器
    class func pushOrderVC(_ superVC: BaseViewController?) {
        let vc = OrderViewController()
        superVC?.pushViewController(vc)
    }
    
    /// 跳转到留言板
    ///
    /// - Parameter superVC: 父控制器
    class func pushTopicVC(_ superVC: BaseViewController?) {
        let vc = FeedBackViewController()
        superVC?.pushViewController(vc)
    }
}

extension DeviceViewModel {
    /// 获取推荐洗衣机列表
    ///
    /// - Parameters:
    ///   - coordinate2D: 经纬度
    ///   - schoolId: 学校id
    ///   - page: 分页页数
    ///   - size: 每页大小
    ///   - userId: 用户id
    ///   - compeleteHandler: 回调闭包
    class func loadRecomend(_ coordinate2D: CLLocationCoordinate2D,
                                  _ schoolId: String,
                                  _ page: String,
                                  _ size: String,
                                  _ userId: String?,
                                  _ compeleteHandler:((Bool, [WashingModel], String)->())?)
    {
        let url = SERVICE_BASE_ADDRESS + API_GET_RECOMMEND_WASHINGMACHINE
        var parameters = [String: Any]()
        parameters["longitude"] = String(format: "%lf", coordinate2D.longitude)
        parameters["latitude"] = String(format: "%lf", coordinate2D.latitude)
        parameters["parentId"] = schoolId
        parameters["page"] = page
        parameters["size"] = size
        if let user = userId {
            if user != "" && user != "0" {
                parameters["userId"] = user
            }
        }
        NetworkEngine.get(url, parameters: parameters) { (result) in
            var models = [WashingModel]()
            var isUsing = false
            if let resultJson = result.dataObj as? [String: AnyObject] {
                if let array = resultJson["data"] as? [Any] {
                    for i in 0 ..< array.count {
                        if let json = array[i] as? [String: AnyObject] {
                            models.append(WashingModel.createDevice(json))
                        }
                    }
                }
                if result.code == 2000 {
                    isUsing = true
                }
                compeleteHandler?(isUsing, models, result.message)
                return
            }
            compeleteHandler?(isUsing, models, result.message)
        }
    }
    
    /// 获取推荐洗衣机列表_V2
    ///
    /// - Parameters:
    ///   - page: 分页页数
    ///   - size: 每页大小
    ///   - userId: 用户id
    ///   - compeleteHandler: 回调闭包
    class func loadRecomendDevice_V2(_ page: Int,
                            _ size: Int,
                            _ userId: String?,
                            _ compeleteHandler:(((recommends: [WashingModel], usings: [WashingModel], message: String))->())?)
    {
        let url = API_GET_RECOMMEND_WASHINGMACHINE_V2
        var parameters = [String: Any]()
        parameters["longitude"] = NCLocation.message.coordinate2D.longitude
        parameters["latitude"] = NCLocation.message.coordinate2D.latitude
        parameters["page"] = page
        parameters["size"] = size
        if let user = userId {
            if user != "" && user != "0" {
                parameters["userId"] = user
            }
        }
        NetworkEngine.get(url, parameters: parameters) { (result) in
            var models = [WashingModel]()
            if let resultJson = result.dataObj as? [String: AnyObject] {
                if let array = resultJson["data"] as? [Any] {
                    for item in array {
                        if let json = item as? [String: AnyObject] {
                            models.append(WashingModel.createDevice(json))
                        }
                    }
                }
                
                compeleteHandler?((result.code == 1000 ? models : [WashingModel](),
                                  result.code == 2000 ? models : [WashingModel](),
                                  result.message))
                return
            }
            compeleteHandler?(([WashingModel](), [WashingModel](), result.message))
        }
    }
    
    /// 获取首页未支付的设备列表_V2
    ///
    /// - Parameters:
    ///   - page: 分页页数
    ///   - size: 每页大小
    ///   - userId: 用户id
    ///   - compeleteHandler: 回调闭包
    class func loadNoPayDevices_V2(_ page: Int,
                                   _ size: Int,
                                   _ userId: String?,
                                   _ compeleteHandler:(([WashingModel]?, String)->())?)
    {
        let url = API_GET_NO_PAY_DEVICE_V2
        var parameters = [String: Any]()
        parameters["longitude"] = NCLocation.message.coordinate2D.longitude
        parameters["latitude"] = NCLocation.message.coordinate2D.latitude
        parameters["page"] = page
        parameters["size"] = size
        if let user = userId {
            if user != "" && user != "0" {
                parameters["userId"] = user
            }
        }
        NetworkEngine.get(url, parameters: parameters) { (result) in
            
            guard result.error == nil else {
                compeleteHandler?(nil, result.message)
                return
            }
            
            var models = [WashingModel]()
            
            if let resultJson = result.dataObj as? [String: AnyObject] {
                if let array = resultJson["data"] as? [Any] {
                    for item in array {
                        if let json = item as? [String: AnyObject] {
                            models.append(WashingModel.createDevice(json))
                        }
                    }
                }
            }
            
            compeleteHandler?(models, result.message)
        }
    }
    
    /// 获取首页未启动的设备列表_V2
    ///
    /// - Parameters:
    ///   - page: 分页页数
    ///   - size: 每页大小
    ///   - userId: 用户id
    ///   - compeleteHandler: 回调闭包
    class func loadNoStartDevices_V2(_ page: Int,
                                   _ size: Int,
                                   _ userId: String?,
                                   _ compeleteHandler:(([WashingModel]?, String)->())?)
    {
        let url = API_GET_NO_START_DEVICE_V2
        var parameters = [String: Any]()
        parameters["longitude"] = NCLocation.message.coordinate2D.longitude
        parameters["latitude"] = NCLocation.message.coordinate2D.latitude
        parameters["page"] = page
        parameters["size"] = size
        if let user = userId {
            if user != "" && user != "0" {
                parameters["userId"] = user
            }
        }
        NetworkEngine.get(url, parameters: parameters) { (result) in
            
            guard result.error == nil else {
                compeleteHandler?(nil, result.message)
                return
            }
            
            var models = [WashingModel]()
            
            if let resultJson = result.dataObj as? [String: AnyObject] {
                if let array = resultJson["data"] as? [Any] {
                    for item in array {
                        if let json = item as? [String: AnyObject] {
                            models.append(WashingModel.createDevice(json))
                        }
                    }
                }
            }
            
            compeleteHandler?(models, result.message)
        }
    }
    
    /// 获取首页正在使用的设备列表_V2
    ///
    /// - Parameters:
    ///   - page: 分页页数
    ///   - size: 每页大小
    ///   - userId: 用户id
    ///   - compeleteHandler: 回调闭包
    class func loadUsingDevices_V2(_ page: Int,
                                     _ size: Int,
                                     _ userId: String?,
                                     _ compeleteHandler:(([WashingModel]?, String)->())?)
    {
        let url = API_GET_USING_DEVICE_V2
        var parameters = [String: Any]()
        parameters["longitude"] = NCLocation.message.coordinate2D.longitude
        parameters["latitude"] = NCLocation.message.coordinate2D.latitude
        parameters["page"] = page
        parameters["size"] = size
        if let user = userId {
            if user != "" && user != "0" {
                parameters["userId"] = user
            }
        }
        NetworkEngine.get(url, parameters: parameters) { (result) in
            
            guard result.error == nil else {
                compeleteHandler?(nil, result.message)
                return
            }
            
            var models = [WashingModel]()
            
            if let resultJson = result.dataObj as? [String: AnyObject] {
                if let array = resultJson["data"] as? [Any] {
                    for item in array {
                        if let json = item as? [String: AnyObject] {
                            models.append(WashingModel.createDevice(json))
                        }
                    }
                }
            }
            
            compeleteHandler?(models, result.message)
        }
    }
    
    /// 获取附近洗衣楼
    ///
    /// - Parameters:
    ///   - coordinate2D: 经纬度
    ///   - schoolId: 学校id
    ///   - page: 分页页数
    ///   - size: 每页大小
    ///   - compeleteHandler: 回调闭包
    class func loadNebyFloor(_ coordinate2D: CLLocationCoordinate2D,
                             _ schoolId: String,
                             _ page: String,
                             _ size: String,
                             _ compeleteHandler:(([School]?, String)->())?)
    {
        let url = SERVICE_BASE_ADDRESS + API_GET_FLOOR_CARD
        var parameters = [String: Any]()
        parameters["longitude"] = String(format: "%lf", coordinate2D.longitude)
        parameters["latitude"] = String(format: "%lf", coordinate2D.latitude)
        parameters["parentId"] = schoolId
        parameters["page"] = page
        parameters["size"] = size
        
        NetworkEngine.get(url, parameters: parameters) { (result) in
            if result.code == 204 || result.isSuccess {
                
                var schools = [School]()
                if let items = result.dataObj["data"] as? [[String: Any]] {
                    for i in 0 ..< items.count {
                        schools.append(School.create(items[i]))
                    }
                }
                compeleteHandler?(schools,
                                  result.message)
            } else {
                compeleteHandler?(nil,
                                  result.message)
            }
        }
        
    }
    
    /// 获取洗衣机详情
    ///
    /// - Parameters:
    ///   - washerId: 洗衣机id
    ///   - coordinate2D: 经纬度
    ///   - userId: 用户id
    ///   - compeleteHandler: 回到闭包
    class func loadWasherDetails(_ washerId: String,
                                 _ coordinate2D: CLLocationCoordinate2D,
                                 _ userId: String,
                                 _ compeleteHandler:((WashingModel?, String)->())?)
    {
        let url = API_GET_WASHINGMACHINE_DETAILS + washerId
        
        let parameters = ["longitude": String(format: "%lf", coordinate2D.longitude),
                          "latitude": String(format: "%lf", coordinate2D.latitude),
                          "userId": userId]
        NetworkEngine.get(url, parameters: parameters) { (result) in
            
            if result.isSuccess {
                if let dict = result.dataObj as? [String: AnyObject] {
                    if let data = dict["data"] as? [String: AnyObject] {
                        let washingModel = WashingModel.createDevice(data)
                        compeleteHandler?(washingModel, result.message)
                        return
                    }
                }
            }
            compeleteHandler?(nil, result.message)
        }
    }
    
    /// 通过IMEI获取设备详情
    ///
    /// - Parameters:
    ///   - imei: imei
    ///   - userId: 用户id
    ///   - apiVersion: 接口版本（1 可以请求到吹风机的数据, app版本1.6.1及以前是不能请求到数据的）
    ///   - compeleteHandler: 回调闭包
    class func loadWasherDetails(_ imei: String,
                                 _ userId: String,
                                 _ apiVersion: String = "1",
                                 _ compeleteHandler:((WashingModel?, String)->())?)
    {
        let url = API_GET_WASHINGMACHINE_DETAILS_IMEI + imei
        let parameters = ["userId": userId, "apiVersion": apiVersion]
        NetworkEngine.get(url, parameters: parameters) { (result) in
            if result.isSuccess {
                
                if let dict = result.dataObj as? [String: AnyObject] {
                    if let data = dict["data"] as? [String: AnyObject] {
                        compeleteHandler?(WashingModel.createDevice(data), result.message)
                        return
                    }
                }
            }
            compeleteHandler?(nil, result.message)
        }
        
    }
    
    /// 获取距离最近的学校
    ///
    /// - Parameters:
    ///   - coordinate2D: 经纬度
    ///   - compeleteHandler: 回调闭包
    class func loadNebySchool(_ coordinate2D: CLLocationCoordinate2D,
                              _ compeleteHandler:((School?, String)->())?)
    {
        let url = SERVICE_BASE_ADDRESS + API_GET_SCHOOL
        let parameters = ["longitude": String(format: "%lf", coordinate2D.longitude),
                          "latitude": String(format: "%lf", coordinate2D.latitude)]
        NetworkEngine.get(url, parameters: parameters) { (result) in
            if result.isSuccess {
                if let dict = result.dataObj as? [String: Any] {
                    if let json = dict["data"] as? [String: Any] {
                        let school = School.create(json)
                        compeleteHandler?(school, result.message)
                        return
                    }
                }
            }
            compeleteHandler?(nil, result.message)
        }
    }
    
    /// 获取洗衣机套餐列表
    ///
    /// - Parameters:
    ///   - deviceId: 设备id
    ///   - compeleteClourse: 回调闭包
    class func loadPackage(_ deviceId: String, _ compeleteClourse: (([PackageModel]?, String)->())?) {
        let url = API_GET_WASHINGPACKAGE_LIST + "?productId=" + deviceId
        NetworkEngine.get(url, parameters: nil) { (result) in
            if result.isSuccess {
                if let dict = result.dataObj as? [String : AnyObject] {
                    if let list = dict["data"] as? [[String : AnyObject]] {
                        var array = [PackageModel]()
                        for i in 0 ..< list.count {
                            array.append(PackageModel.create(list[i]))
                        }
                        compeleteClourse?(array, result.message)
                        return
                    }
                }
            }
            compeleteClourse?(nil, result.message)
        }
    }
    
    class func loadBannerList(_ type: String = "",
                              _ page: String = "1",
                              _ size: String = "20",
                              _ userId: String = "",
                              _ completionClourse: (([HomeBannerModel]?, String)->())?)
    {
        let url = API_GET_TASK_LIST
        var params = [String: Any]()
        params["page"] = page
        params["size"] = size
        if type != "" {
            params["type"] = type
        }
        if userId != "" && userId != "0" {
            params["userId"] = userId
        }
        NetworkEngine.get(url, parameters: params) { (result) in
            if result.isSuccess {
                if let dict = result.dataObj as? [String: AnyObject] {
                    if let list = dict["data"] as? [[String: AnyObject]] {
                        var arr = [HomeBannerModel]()
                        for json in list {
                            let model = HomeBannerModel.create(json)
                            arr.append(model)
                        }
                        completionClourse?(arr, result.message)
                        return
                    }
                }
            }
            completionClourse?(nil, result.message)
        }
    }
    
    class func startDevice(_ orderNo: String,
                           _ userId: String,
                           _ compeleteClourse:((Bool, String)->())?)
    {
        let url = SERVICE_BASE_ADDRESS + API_GET_ORDER_TRACKORDER
        let params = ["orderId": orderNo, "userId": userId]
        NetworkEngine.get(url, parameters: params) { (result) in
            compeleteClourse?(result.isSuccess, result.message)
        }
    }
}



