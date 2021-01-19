//
//  HZAboutMessage.swift
//  WashingMachine
//
//  Created by zzh on 2017/7/20.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

import UIKit


class HZMobilePhone {
    static let screenBounds = UIScreen.main.bounds
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height

    /// 手机系统版本号
    static let iOSVersion = UIDevice.current.systemVersion
    
    /// 手机UUID
    static let UUIDStr = UIDevice.current.identifierForVendor?.uuidString ?? ""
    
    static var model: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
    
    /// 设备类型(iPhone、iPad等)
    static var deviceType: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod1,1":  return "iPod Touch 1"
        case "iPod2,1":  return "iPod Touch 2"
        case "iPod3,1":  return "iPod Touch 3"
        case "iPod4,1":  return "iPod Touch 4"
        case "iPod5,1":  return "iPod Touch (5 Gen)"
        case "iPod7,1":   return "iPod Touch 6"
            
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":  return "iPhone 4"
        case "iPhone4,1":  return "iPhone 4s"
        case "iPhone5,1":   return "iPhone 5"
        case  "iPhone5,2":  return "iPhone 5 (GSM+CDMA)"
        case "iPhone5,3":  return "iPhone 5c (GSM)"
        case "iPhone5,4":  return "iPhone 5c (GSM+CDMA)"
        case "iPhone6,1":  return "iPhone 5s (GSM)"
        case "iPhone6,2":  return "iPhone 5s (GSM+CDMA)"
        case "iPhone7,2":  return "iPhone 6"
        case "iPhone7,1":  return "iPhone 6 Plus"
        case "iPhone8,1":  return "iPhone 6s"
        case "iPhone8,2":  return "iPhone 6s Plus"
        case "iPhone8,4":  return "iPhone SE"
        case "iPhone9,1":   return "国行、日版、港行iPhone 7"
        case "iPhone9,2":  return "港行、国行iPhone 7 Plus"
        case "iPhone9,3":  return "美版、台版iPhone 7"
        case "iPhone9,4":  return "美版、台版iPhone 7 Plus"
        case "iPhone10,1","iPhone10,4":   return "iPhone 8"
        case "iPhone10,2","iPhone10,5":   return "iPhone 8 Plus"
        case "iPhone10,3","iPhone10,6":   return "iPhone X"
            
        case "iPad1,1":   return "iPad"
        case "iPad1,2":   return "iPad 3G"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":   return "iPad 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":  return "iPad Mini"
        case "iPad3,1", "iPad3,2", "iPad3,3":  return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":   return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":   return "iPad Air"
        case "iPad4,4", "iPad4,5", "iPad4,6":  return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":  return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":  return "iPad Mini 4"
        case "iPad5,3", "iPad5,4":   return "iPad Air 2"
        case "iPad6,3", "iPad6,4":  return "iPad Pro 9.7"
        case "iPad6,7", "iPad6,8":  return "iPad Pro 12.9"
        case "AppleTV2,1":  return "Apple TV 2"
        case "AppleTV3,1","AppleTV3,2":  return "Apple TV 3"
        case "AppleTV5,3":   return "Apple TV 4"
        case "i386", "x86_64":   return "Simulator"
        default:  return identifier
        }
    }
    
    static var devicePPI: Int {
        
        let device_type = deviceType
    
        if(IsCStrEqual(device_type, "iPhone 6 Plus") || IsCStrEqual(device_type, "iPhone 7 Plus") || IsCStrEqual(device_type, "iPhone 8 Plus") || IsCStrEqual(device_type, "iPhone 6s Plus")){
            return 401;
        }
        if(IsCStrEqual(device_type, "iPhone 11 Pro Max") || IsCStrEqual(device_type, "iPhone 11 Pro") || IsCStrEqual(device_type, "iPhone XS Max") || IsCStrEqual(device_type, "iPhone XS")
            || IsCStrEqual(device_type, "iPhone X")){
            return 458;
        }
        if(IsCStrEqual(device_type, "iPhone 4s") || IsCStrEqual(device_type, "iPhone 4") || IsCStrEqual(device_type, "iPod Touch 4")){
            return 330;
        }
        if(IsCStrEqual(device_type, "iPhone SE 2") || IsCStrEqual(device_type, "iPhone SE") || IsCStrEqual(device_type, "iPhone 11") || IsCStrEqual(device_type, "iPhone XR")
            || IsCStrEqual(device_type, "iPhone 6") || IsCStrEqual(device_type, "iPhone 7") || IsCStrEqual(device_type, "iPhone 8") || IsCStrEqual(device_type, "iPhone 6s")
            || IsCStrEqual(device_type, "iPhone 5") || IsCStrEqual(device_type, "iPhone 5c") || IsCStrEqual(device_type, "iPhone 5s") || IsCStrEqual(device_type, "iPod Touch 5")
            || IsCStrEqual(device_type, "iPod Touch 6") || IsCStrEqual(device_type, "iPod Touch 7") || IsCStrEqual(device_type, "iPad Mini") || IsCStrEqual(device_type, "iPad Mini 2")
            || IsCStrEqual(device_type, "iPad Mini 3") || IsCStrEqual(device_type, "iPad Mini 4") || IsCStrEqual(device_type, "iPad Mini 5")){
            return 326;
        }
        if(IsCStrEqual(device_type, "iPad Pro 12.9-inch 4") || IsCStrEqual(device_type, "iPad Pro 12.9-inch 3") || IsCStrEqual(device_type, "iPad Pro 12.9-inch 2")
            || IsCStrEqual(device_type, "iPad Pro 12.9-inch") || IsCStrEqual(device_type, "iPad Pro 11-inch 2") || IsCStrEqual(device_type, "iPad Pro 11-inch")
            || IsCStrEqual(device_type, "iPad Pro 10.5-inch") || IsCStrEqual(device_type, "iPad Pro 9.7-inch") || IsCStrEqual(device_type, "iPad Air 3")
            || IsCStrEqual(device_type, "iPad Air 2") || IsCStrEqual(device_type, "iPad Air") || IsCStrEqual(device_type, "iPad 7")
            || IsCStrEqual(device_type, "iPad 6") || IsCStrEqual(device_type, "iPad 5") || IsCStrEqual(device_type, "iPad 4") || IsCStrEqual(device_type, "iPad 3")){
            return 264;
        }
        if(IsCStrEqual(device_type, "iPhone 3GS") || IsCStrEqual(device_type, "iPhone 3G") || IsCStrEqual(device_type, "iPhone") || IsCStrEqual(device_type, "iPod Touch")
            || IsCStrEqual(device_type, "iPod Touch 2") || IsCStrEqual(device_type, "iPod Touch 3")){
            return 163;
        }
        if(IsCStrEqual(device_type, "iPad 2") || IsCStrEqual(device_type, "iPad")){
            return 132;
        }
        return 326;
    }
    
    static func IsCStrEqual(_ str1: String, _ str2: String) -> Bool {
        return str1 == str2
    }
    
//    static var macAddress: String {
//        let index  = Int32(if_nametoindex("en0"))
//        let bsdData = "en0".data(using: .utf8)
//        var mib : [Int32] = [CTL_NET,AF_ROUTE,0,AF_LINK,NET_RT_IFLIST,index]
//        var len = 0;
//
//        guard sysctl(&mib,UInt32(mib.count), nil, &len,nil,0) >= 0 else {
//            print("Error: could not determine length of info data structure ")
//            return "00:00:00:00:00:00"
//        }
//
//
//        var buffer = [CChar](repeating: 0, count: len)
//        guard sysctl(&mib, UInt32(mib.count), &buffer, &len, nil, 0) >= 0 else {
//            print("Error: could not read info data structure")
//            return "00:00:00:00:00:00"
//        }
//
//        let infoData = NSData(bytes: buffer, length: len)
//        var interfaceMsgStruct = if_msghdr()
//        MemoryLayout.size(ofValue: if_msghdr())
//
//        infoData.getBytes(&interfaceMsgStruct, length: MemoryLayout.size(ofValue: if_msghdr))
//        let socketStructStart = MemoryLayout.size(ofValue: if_msghdr) + 1
//        let socketStructData = infoData.subdataWithRange(NSMakeRange(socketStructStart, len - socketStructStart))
//        let rangeOfToken = socketStructData.rangeOfData(bsdData, options: NSDataSearchOptions(rawValue: 0), range: NSMakeRange(0, socketStructData.length))
//        let macAddressData = socketStructData.subdataWithRange(NSMakeRange(rangeOfToken.location + 3, 6))
//        var macAddressDataBytes = [UInt8](repeating: 0, count: 6)
//        macAddressData.getBytes(&macAddressDataBytes, length: 6)
//        return macAddressDataBytes.map({ String(format:"%02x", $0) }).joinWithSeparator(":")
//    }
}

class HZApp {
    /// 应用版本号
    static let appVersion = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? ""
    
    /// 应用build版本号
    static let buildVersion = (Bundle.main.infoDictionary?["CFBundleVersion"] as? String) ?? ""
    
    /// 应用bundleId
    static let bundleIdentifier = (Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String) ?? ""
    
    /// 应用名称
    static let appName = (Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String) ?? ""
    
    /// 工程名称
    static let projectName = (Bundle.main.infoDictionary?[String(kCFBundleExecutableKey)] as? String) ?? ""
    
    /// 生成的AppKey
    static let appKey = "ios.\((Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String) ?? "")".md5()
}




