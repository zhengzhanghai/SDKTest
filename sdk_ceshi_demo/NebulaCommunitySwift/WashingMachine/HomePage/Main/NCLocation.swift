//
//  NCLocation.swift
//  WashingMachine
//
//  Created by Harious on 2018/1/15.
//  Copyright © 2018年 Eteclabeteclab. All rights reserved.
//

import UIKit

class NCLocation: NSObject {
    
    struct Message {
        var coordinate2D: CLLocationCoordinate2D = CLLocationCoordinate2D()
        var address: String = ""
        var isSuccess: Bool = false
        
        init(_ coordinate2D: CLLocationCoordinate2D, _ address: String, _ isSuccess: Bool) {
            self.coordinate2D = coordinate2D
            self.address = address
            self.isSuccess = isSuccess
        }
    }
    
    static let NCLocationUserDefaultsKey = "NCLocation.NCLocationUserDefaultsKey"
    static let locationEndNotifationName = "NCLocation.locationSuccessNotifationName"
    // 转成了百度坐标
    fileprivate(set) static var message: Message = Message(CLLocationCoordinate2D(), "", false)
    
    /// 开始定位，首先会获取缓存中存储的定位，并存到类属性中，如果定位失败，所得到的定位是从缓存中得到的
    /// (message: Message, isNewLocation: Bool)   message: 定位信息  isNewLocation: 是否是新定位到的
    static func startLocation(_ compeletion: (((message: Message, isNewLocation: Bool))->())? = nil) {
        
        // 先从沙河中读取
        message = readLocationFromHomeDirectory()
        
        LocationManager.startUpdatingLocation { (manager, locationResult) in
            
            /// 停止定位
            manager.stopUpdatingLocation()
            
            guard locationResult.isSuccess else {
                /// 失败回调
                compeletion?((message, false))
                /// 定位失败也发送通知
                postNotication(locationEndNotifationName, nil, nil)
                return
            }
            
            message.isSuccess = true
            message.coordinate2D = NCLocationConverter.wgs84(toBd09: locationResult.coordinate2D)
            
            /// 获取到的定位再转换地址
            locationResult.getAddress({ (mark) in
                
                guard let address = mark?.name else {
                    self.saveToHomeDirectory(self.message)
                    /// 回调
                    compeletion?((message, true))
                    /// 定位成功后发送通知
                    postNotication(locationEndNotifationName, nil, nil)
                    return
                }
                
                message.address = address
                
                /// 回调
                compeletion?((message, true))
                
                self.saveToHomeDirectory(self.message)
                /// 定位成功后发送通知
                postNotication(locationEndNotifationName, nil, nil)
            })
        }
    }
    
    /// 将定位信息存到沙盒
    static func saveToHomeDirectory(_ message: Message) {
        UserDefaults.standard.set(["coordinate2D.latitude" : message.coordinate2D.latitude,
                                  "coordinate2D.longitude" : message.coordinate2D.longitude,
                                   "address": message.address,
                                   "isSuccess": message.isSuccess],
                                  forKey: NCLocationUserDefaultsKey)

        UserDefaults.standard.synchronize()
    }
    
    /// 从沙盒读取位置，并保存到类属性中
    @discardableResult
    static func readLocationFromHomeDirectory() -> Message {
        
        var message = Message(CLLocationCoordinate2D(), "", false)
        
        guard let locationDict = UserDefaults.standard.value(forKey: NCLocationUserDefaultsKey) as? [String: Any] else {
            return message
        }
        
        if let latitude = locationDict["coordinate2D.latitude"] as? Double {
            message.coordinate2D.latitude = latitude
        }
        
        if let longitude = locationDict["coordinate2D.longitude"] as? Double {
            message.coordinate2D.longitude = longitude
        }
        
        if let address = locationDict["address"] as? String {
            message.address = address
        }
        
        if let isSuccess = locationDict["isSuccess"] as? Bool {
            message.isSuccess = isSuccess
        }

        return message
    }
}










