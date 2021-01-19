//
//  School.swift
//  WashingMachine
//
//  Created by zzh on 17/3/7.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

import UIKit

class School: ZZHModel {
    var name: String?
    var sort: NSNumber?
    var number: NSNumber?
    var freeNumber: NSNumber?
    var modifyTime: NSNumber?
    var latitude: String?
    var parentId: NSNumber?
    var status: NSNumber?
    var id: NSNumber?
    var image: String?
    var showName: String?
    var distance: String?
    var longitude: String?
    var createTime: NSNumber?
    
    /// 楼列表中各种设备数量
    var deviceTypeCount: [[String: Any]]?
    
    var deviceTypeList: [FloorDeviceCount] {
        var deviceC = [FloorDeviceCount]()
        
        if let deviceTypes = deviceTypeCount {
            for deviceType in deviceTypes {
                deviceC.append(FloorDeviceCount.create(deviceType))
            }
        }
        
        return deviceC
    }
}


class FloorDeviceCount: ZZHModel {
    var deviceName: String?
    var deviceType: Int?
    var sum: Int?
}
