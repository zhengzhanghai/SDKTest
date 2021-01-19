//
//  HZDataStatistics.swift
//  WashingMachine
//
//  Created by zzh on 2017/7/20.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

import UIKit

class HZDataStatistics: NSObject {
    
    static let share = HZDataStatistics.init()
    
    @discardableResult
    class func shareManager() -> HZDataStatistics {
        return self.share
    }
    
    
    @discardableResult
    override init() {
        super.init()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationWillResignActive),
                                               name:UIApplication.willResignActiveNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationDidBecomeActive),
                                               name:UIApplication.didBecomeActiveNotification,
                                               object: nil)
        
        
        /// 开启定位
        NCLocation.startLocation()
    }
    
    /// 进入后台
    @objc fileprivate func applicationWillResignActive() {
        ZZPrint("进入了后台")
        self.sendData()
    }
    /// 进入前台
    @objc fileprivate func applicationDidBecomeActive() {
        ZZPrint("进入了前台")
    }
    
    fileprivate func sendData() {
        let parameters = ["reportType": "0",
                          "header": ["appName": HZApp.appName,
                                     "appVersion": HZApp.appVersion,
                                     "appVersionCode": "10",
                                     "appkey": HZApp.appKey,
                                     "channelId": "AppStore",
                                     "deviceId": HZMobilePhone.UUIDStr,
                                     "deviceManufacturer": "Apple Inc.",
                                     "deviceModel": HZMobilePhone.deviceType,
                                     "lat": "\(NCLocation.message.coordinate2D.latitude)",
                                     "lng": "\(NCLocation.message.coordinate2D.longitude)",
                                     "mobile": getUserMobile(),
                                     "osName": "iOS",
                                     "osVersion": HZMobilePhone.iOSVersion,
                                     "packageName": HZApp.bundleIdentifier,
                                     "screen": "\(Int(HZMobilePhone.screenWidth))*\(Int(HZMobilePhone.screenHeight))",
                                     "sdkInt": "0000",
                                     "simCardId": "000",
                                     "udid": HZMobilePhone.UUIDStr,
                                     "userId": getUserId(),
                                     "uuid": HZMobilePhone.UUIDStr]] as [String : Any]
        NetworkEngine.postJSON(API_POST_USER_DATA, parameters: parameters as [String : AnyObject]) { (result) in
            if result.isSuccess {
                ZZPrint("+++++++ 数据收集成功 ✅✅✅✅✅ +++++++")
            } else {
                ZZPrint("+++++++ 数据收集失败 ❌❌❌❌❌+++++++")
            }
        }
        ZZPrint(parameters)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}


