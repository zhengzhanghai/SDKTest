//
//  OrderDetailsModel.swift
//  WashingMachine
//
//  Created by zzh on 16/11/2.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

import UIKit
import HandyJSON

class OrderDetailsModel: ZZHModel {
    var id: NSNumber?
    var productId: NSNumber?
    var packageId: NSNumber?
    var timeLong: NSNumber?
    var amount: NSNumber?
    var productName: String?
    var baseName: String?
    var memo: String?
    var packageName: String?
    var packageTime: NSNumber?
    var userId: NSNumber?
    var createTime: NSNumber?
    var endTime: NSNumber?
    var spend: NSNumber?
    var startTime: NSNumber?
    var baseId: NSNumber?
    var status: NSNumber?
    var orderNo: String?
    var score: NSNumber?
    var haomiao: NSNumber?//倒计时
    var from: NSNumber? //订单来源  1 一键下单   2 预约下单
    var orderFrom: NSNumber? //订单来源  1 一键下单   2 预约下单
    var bigStatus: NSNumber?
    var refundNo: NSNumber?   //退款流水号
    // (0待机中 1预约中 3.4.5....)（0、1机器处于未工作状态，其他状态设备处于工作中）
    var washStatus: NSNumber? //洗衣状态
    var vendorName: String?
    var washStatusString:String?  //设备状态描述
    var p_appId: String?
    var showName: String?
    var refundReason: String?  // 退款原因
    var refuseReason: String?  // 拒绝原因
    /// 吹风机密码
    var drierPassword: String?
    /// 使用的设备类型(3是吹风机)
    var deviceType: NSNumber?
    /// 是否允许退款
    var isRefund: NSNumber?
    /// 退款图片
    var refundImages: [Any]?
    ///  1 设备通讯，洗衣机流程   2 吹风机流程
    var processType: NSNumber?
    
    var refundImageModels: [RefundImage]?
    
    /// 对这个订单支付前，是否需要检验能否去支付
    var isCheckBeforePay: Bool {
        return (self.processPattern == .equipmentCoemmunication)
    }
    
    /// 设备是否处于工作中状态
    var deviceIsWorking: Bool {
        return !((washStatus == 0) || (washStatus == 1))
    }
    
    /// 设备类型
    var dType: DeviceType {
        guard let type = self.deviceType else {
            return .other
        }
        return Device.type(type)
    }
    
    var showedPackageName: String {
        if let packageTime = packageTime {
            return "\(packageName ?? "")(\(packageTime)分钟)"
        }
        return packageName ?? ""
    }
    
    /// 是否已经存在动态密码
    var isExistPassword: Bool {
        if status == 6 || status == 7 || status == 8 || status == 9 {
            return false
        }
        guard let pwd = drierPassword else {
            return false
        }
        if pwd.count < 2 {
            return false
        }
        return true
    }
    
    /// 是否展示退款图片
    var isShowRefundImage: Bool {
        guard let images = self.refundImageModels else {
            return false
        }
        guard images.count > 0 else {
            return false
        }
        guard let statusValue = self.status else {
            return false
        }
        if statusValue == 6 || statusValue == 7 || statusValue == 8 || statusValue == 13  {
            return true
        }
        return false
    }
    
    /// 是否有退款原因
    var isShowRefundReason: Bool {
        guard let statusValue = self.status else {
            return false
        }
        if statusValue == 6 || statusValue == 7 || statusValue == 8 || statusValue == 13 || statusValue == 9 {
            return true
        }
        return false
    }
     /// 是否有拒绝退款原因
    var isShowRefuseReason: Bool {
        guard let statusValue = self.status else {
            return false
        }
        if statusValue == 13  {
            return true
        }
        return false
    }
    /// 是否允许退款
    var isAllowRefund: Bool {
        return self.isRefund?.boolValue ?? false
    }
    /// 如果可以退款，是否需要上传图片（该方法不判断是否允许退款）
    var isNeedImageWhenRefund: Bool {
        guard let status = self.status else {
            return true
        }
        
        // 只有当双向交互设备并且是预定付款没有洗衣时，才不需要退款图片
        return (processPattern == .equipmentCoemmunication && status == 3) ? false : true
    }
    /// 是否是立即使用的订单
    var isImmediateUse: Bool {
        return (processPattern == .onewayCommunication) || (orderFrom?.intValue == 1)
    }
    /// 订单状态字符串
    var statusStr: String {
        switch (status ?? -938) {
        case 0: return "无效订单"
        case 1: return "未支付"
        case 2: return "支付失败"
        case 3: return "已预约，未洗衣"
        case 4: return self.washStatusString ?? ""
        case 5: return "已完成"
        case 6: return "申请退款中"
        case 7: return "申请退款中"
        case 8: return "退款失败"
        case 9: return "已退款"
        case 10: return "订单超时"
        case 11: return "支付超时"
        case 12: return "订单已取消"
        case 13: return "拒绝退款"
        default : return ""
        }
    }
    /// 下单时间字符串
    var createTimeStr: String {
        return (self.createTime ?? 0).timeStr()
    }
    /// 洗衣流程模式
    var processPattern: CleaningProcessType {
        switch self.processType ?? -1 {
        case 1:
            return .equipmentCoemmunication
        case 2:
            return .onewayCommunication
        default:
            return .other
        }
    }
    /// 设备类型名称
    var deviceTypeStr: String {
                
        guard let type = self.deviceType else {
            return ""
        }
        switch type {
        case 1:
            return "涡轮洗衣机"
        case 2:
            return "滚筒洗衣机"
        case 3:
            return "吹风机"
        case 4:
            return "烘干机"
        case 5:
            return "洗鞋机"
        default:
            return ""
        }
    }
    
    class func createOrder(_ dictionary: [String : Any]?) -> Self  {
        let model = self.deserialize(from: dictionary) ?? self.init()
        if model.deviceType == 2 || model.deviceType == 8 {
            model.processType = 1
        }
        return model
    }
    
    class func create_sub(_ dictionary: [String : Any]?) -> Self  {
        let model = self.createOrder(dictionary)
        guard let images = model.refundImages else {
            return model
        }
        guard images.count > 0 else {
            return model
        }
        guard let imagesDict = images as? [[String: Any]] else {
            return model
        }
        var imageModels = [RefundImage]()
        for dict in imagesDict {
            imageModels.append(RefundImage.create(dict))
        }
        model.refundImageModels = imageModels
        return model
    }
}


