//
//  WashingModel.swift
//  WashingMachine
//
//  Created by zzh on 16/10/26.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

import UIKit

class WashingModel: ZZHModel {
    var id:NSNumber?
    var image:String?
    var name:String?
    var number:NSNumber?
    var sort:NSNumber?
    var url:String?
//   洗衣状态 (1使用中，2空闲，3预约）
    var washStatus:NSNumber?
//  洗衣机状态 （0离线，1在线）
    var onOffStatus: NSNumber?
//    设备编号
    var imei:String?
    var sign:String?
    //剩余时间
    var residualTime:String?
    var packageId:NSNumber?
    var packageName:String?
    var timeLong:NSNumber?
    var spend:NSNumber?
    var distance:String?
    var desp:String?
//    上次洗衣时间
    var lastLaundryTime:NSNumber?
//    代理商
    var vendorName:String?
    /// 代理商电话   
    var vendorMobile: String?
    
    var isUnfold:Bool = false
    var isUse: NSNumber? //是否被用
    var collection: NSNumber? //是否收藏
    var count: NSNumber? //showName
    var showName:String?
    var lastCleanTime: NSNumber?
    /// 设备类型(3吹风机)
    var type: NSNumber?
    ///  1 设备通讯，洗衣机流程   2 吹风机流程
    var processType: NSNumber?
    
    static func createDevice(_ dictionary: [String : Any]?) -> Self {
        let device = self.deserialize(from: dictionary) ?? self.init()
        if device.type == 2 || device.type == 8  {
            device.processType = 1
        }
        return device
    }
    
    /// 是否空闲(在线并且没在使用中是空闲)，没有设备状态的设备始终返回true
    var isEmpty: Bool {
        if processPattern == .equipmentCoemmunication {
            if onOffStatus != 0 {
                if washStatus == 2 {
                    return true
                }
            }
        } else {
            return true
        }
        return false
    }
    
    /// 是否离线，没有设备状态的设备返回false
    var isOffLine: Bool {
        if processPattern == .onewayCommunication {
            return false
        } else {
            return !(onOffStatus?.boolValue ?? false)
        }
    }
    
    var washStatusStr: String {
        if isEmpty {
            return "空闲"
        } else {
            if onOffStatus == 0 {
                return "离线"
            } else {
                if washStatus == 3 {
                    return "已预约"
                } else {
                    return "使用中"
                }
            }
        }
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
    
    /// 设备类型
    var deviceType: DeviceType {
        return Device.type(self.type)
    }
    
    /// 设备类型名字
    var deviceTypeStr: String {
        return Device.name(self.type)
    }
    
    /// 使用提示语
    var useAlertString: String {
        switch self.deviceType {
        case .pulsatorWasher: return ""
        case .rollerWasher:   return ""
        case .blower:         return ""
        case .dryer:          return "注意：请用洗衣机甩干后进行烘干，羊毛、丝绸类等精细衣物不能使用烘干"
        case .XXJ:            return ""
        case .phoenixDryer:   return "注意：请用洗衣机甩干后进行烘干，羊毛、丝绸类等精细衣物不能使用烘干"
        default:              return ""
        }
    }
    
    var cellIcon: String {
        switch deviceType {
            
        case .pulsatorWasher: return "device_washer"
        case .rollerWasher: return "device_washer"
        case .blower: return "device_blower"
        case .dryer: return "device_drayer"
        case .XXJ: return "device_xxj"
        case .condensateBeads: return "device_condensatebeads"
        case .phoenixDryer: return "device_drayer"
        default:
            return ""
        }
    }
    
    var cellSmallIcon: String {
        switch deviceType {
            
        case .pulsatorWasher: return "device_washer_small"
        case .rollerWasher: return "device_washer_small"
        case .blower: return "device_blower_small"
        case .dryer: return "device_drayer_small"
        case .XXJ: return "device_xxj_small"
        case .condensateBeads: return "device_condensatebeads_small"
        case .phoenixDryer: return "device_drayer_small"
        default:
            return ""
        }
    }
}










