//
//  Device.swift
//  WashingMachine
//
//  Created by Harious on 2017/12/29.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

import UIKit

public enum DeviceType {
    case pulsatorWasher // 波轮洗衣机(服务器默认是这种类型)
    case rollerWasher  // 滚筒洗衣机
    case blower // 吹风机
    case dryer // 烘干机
    case XXJ //洗鞋机
    case condensateBeads // 洗衣凝珠
    case phoenixDryer // 凤凰洗衣机
    case other  // 其他
}

class Device {
    /// 根据设备类型号获取设备类型
    static func type(_ typeNumber: Int?) -> DeviceType {
        guard let typeNnm = typeNumber else {
            return .other
        }
        switch typeNnm {
        case 1:
            return .pulsatorWasher
        case 2:
            return .rollerWasher
        case 3:
            return .blower
        case 4:
            return .dryer
        case 5:
            return .XXJ
        case 6:
            return .condensateBeads
        case 8:
            return .phoenixDryer
        default:
            return .other
        }
    }
    
    /// 根据设备类型号获取设备类型
    static func type(_ typeNumber: NSNumber?) -> DeviceType {
        return type(typeNumber?.intValue)
    }
    
    /// 根据设备类型号获取设备对应的颜色
    static func color(_ typeInt: Int?, _ isEmpty: Bool = true) -> UIColor {
        return color(type(typeInt), isEmpty)
    }
    
    /// 根据设备类型号获取设备对应的颜色
    static func color(_ typeNumber: NSNumber?, _ isEmpty: Bool = true) -> UIColor {
        return color(type(typeNumber), isEmpty)
    }
    
    /// 根据设备类型获取设备对应的颜色
    static func color(_ type: DeviceType?, _ isEmpty: Bool = true) -> UIColor {
        guard let deviceType = type else {
            return .clear
        }
        switch deviceType {
        case .pulsatorWasher:    return isEmpty ? UIColor_0x(0x85d780) : UIColor_0x(0xff704a)
        case .rollerWasher:      return isEmpty ? UIColor_0x(0x85d780) : UIColor_0x(0xff704a)
        case .blower:            return UIColor_0x(0x73c2f0)
        case .dryer:             return UIColor_0x(0xf2c793)
        case .XXJ:               return UIColor_0x(0x94d7c2)
        case .condensateBeads:   return UIColor_0x(0xd2b727)
        case .phoenixDryer:      return UIColor_0x(0xf2c793)
        default:                 return .clear
        }
    }
    
    /// 获取订单历史cell的icon
    static func orderHistoryCellIcon(_ typeInt: Int?) -> String {
        return orderHistoryCellIcon(type(typeInt))
    }
    /// 获取订单历史cell的icon
    static func orderHistoryCellIcon(_ typeNumber: NSNumber?) -> String {
        return orderHistoryCellIcon(type(typeNumber))
    }
    /// 获取订单历史cell的icon
    static func orderHistoryCellIcon(_ type: DeviceType?) -> String {
        guard let deviceType = type else {
            return ""
        }
        switch deviceType {
        case .pulsatorWasher: return "washer_word"
        case .rollerWasher:   return "washer_word"
        case .blower:         return "blower_word"
        case .dryer:          return "dryer_word"
        case .XXJ:            return "xxj_word"
        case .condensateBeads:return "condensateBeads_word"
        case .phoenixDryer:   return "dryer_word"
        default:              return ""
        }
    }
    
    /// 获取设备类型名称
    static func name(_ type: DeviceType?)  -> String  {
        guard let deviceType = type else {
            return ""
        }
        switch deviceType {
        case .pulsatorWasher:  return "涡轮洗衣机"
        case .rollerWasher:    return "滚筒洗衣机"
        case .blower:          return "吹风机"
        case .dryer:           return "烘干机"
        case .XXJ:             return "洗鞋机"
        case .condensateBeads: return "洗衣凝珠"
        case .phoenixDryer:    return "烘干机"
        default:               return ""
        }
    }
    
    /// 获取设备类型名称
    static func name(_ typeInt: Int?) -> String {
        return name(type(typeInt))
    }
    
    /// 获取设备类型名称
    static func name(_ typeNumber: NSNumber?) -> String {
        return name(type(typeNumber))
    }
}







