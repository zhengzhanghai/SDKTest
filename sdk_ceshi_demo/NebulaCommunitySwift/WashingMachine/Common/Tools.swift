//
//  Tools.swift
//  Truck
//
//  Created by Moguilay on 16/9/9.
//  Copyright © 2016年 Eteclab. All rights reserved.
//

import UIKit
import MBProgressHUD
import CoreLocation

public enum NCNetworkLoadWay: Int {
    case normal
    case refresh
    case more
}

// MARK: - NSHomeDirectory 缓存目录初始化
//document目录   一般需要持久的数据都放在此目录中，可以在当中添加子文件夹，iTunes备份和恢复的时候，会包括此目录。
let DOCUMENTDICTIONARY  = NSHomeDirectory() + "/Library/Private Documents"
//temp文件目录  创建临时文件的目录，当iOS设备重启时，文件会被自动清除
let TEMP_DICTIONARY = NSTemporaryDirectory() + "/tmp"
//cache目录
let  CACHE_DICTIONARY = NSHomeDirectory() + "/Library/Caches"

/// ***************************************************分割线*************************************************///
//MARK: - 屏幕宽、高、大小
let BOUNDS_WIDTH  = UIScreen.main.bounds.width
let BOUNDS_HEIGHT = UIScreen.main.bounds.height
let BOUNDS        = UIScreen.main.bounds

/// 跟iPhone7的屏宽比
let screen_scale_7 = (BOUNDS_WIDTH/375)
/// 传入一个iphone7标准下的尺寸，返回一个根据屏幕宽比例计算的尺寸
public func cgFloatScreenTrans(_ value: CGFloat) -> CGFloat {
    return screen_scale_7*value
}

/// ***************************************************分割线*************************************************///
//MARK: - 获取状态栏、导航栏、tabbar的高度
/// 状态栏高度
let STATUSBAR_HEIGHT = UIApplication.shared.statusBarFrame.height
/// 状态栏绝对高度
let STATUSBAR_ABSOLUTE_HEIGHT: CGFloat = is_iPhoneX ? 44 : 20
let NAVIGATIONBAR_HEIGHT = UINavigationController().navigationBar.frame.height
let TABBAR_HEIGHT = UITabBarController().tabBar.frame.height
let BOTTOM_SAFE_HEIGHT: CGFloat = is_iPhoneX ? 34 : 0

let topHeight = (STATUSBAR_HEIGHT+NAVIGATIONBAR_HEIGHT)
let contentHeightNoTop = (BOUNDS_HEIGHT-topHeight)
let contentHeightNoBottm = (BOUNDS_HEIGHT-TABBAR_HEIGHT)
let contentHeightNoTopBottom = (BOUNDS_HEIGHT-topHeight-TABBAR_HEIGHT)

//MARK: - 获取当前屏幕宽与iPhone6屏幕宽的比例
let RATIO_SCREEN_WIDTH = BOUNDS_WIDTH/CGFloat(375)

/// 根据屏幕大小适应大小
func floatFromScreen(_ num: CGFloat)-> CGFloat {
    return num * RATIO_SCREEN_WIDTH
}

/// AppDelegate.window.rootViewController.view
let appRootView = (UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController?.view

/// ***************************************************分割线*************************************************///
// MARK: - isPhoneNumber 判断手机号是否合法
public func isPhoneNumber(_ phoneNumber:String) -> Bool {
//    if phoneNumber.count == 0 {
//        return false
//    }
//    let mobile = "^(13[0-9]|15[0-9]|18[0-9]|17[0-9]|19[0-9]|147)\\d{8}$"
//    let regexMobile = NSPredicate(format: "SELF MATCHES %@",mobile)
//    if regexMobile.evaluate(with: phoneNumber) == true {
//        return true
//    } else {
//        return false
//    }
    
    return phoneNumber.hasPrefix("1") && phoneNumber.count == 11
}

/// ***************************************************分割线*************************************************///
// MARK: - 获取与当前时间差 ms
public func differentTimeForString(_ timeString: String) -> TimeInterval {
    let timeFormatter = DateFormatter()
    timeFormatter.dateFormat = "yyy-MM-dd HH:mm:ss"
    let data = timeFormatter.date(from: timeString)
    let time = data?.timeIntervalSince1970
    let currentTime = Date().timeIntervalSince1970
    return (time! - currentTime)*1000.0
}

public func differentTimeForDoule(_ time: Double) -> TimeInterval {
    let currentTime = Date().timeIntervalSince1970*1000.0
    return time - currentTime
}




/// ***************************************************分割线*************************************************///
// MARK: - 加载菊花
private var loadingView:MBProgressHUD? = nil
func showLoadingView(_ superView: UIView, _ message: String = "加载中") {
    loadingView = MBProgressHUD.showAdded(to: superView, animated: true)
    loadingView?.label.text = message
    loadingView?.label.font = UIFont.systemFont(ofSize: 16.0)
    loadingView?.margin = 20.0
    loadingView?.removeFromSuperViewOnHide = true
    loadingView?.contentColor = UIColor.white
    loadingView?.bezelView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
}

func hiddenLoadingView() {
    loadingView?.hide(animated: true)
}


/// ***************************************************分割线*************************************************///
// MARK: -  用MBProgressHUB提示
private var alertView:MBProgressHUD? = nil
func showSucccess(_ message: String ,superView: UIView?, afterHidden: TimeInterval = 1.2) {
    createAlertView(message, superView: superView, isSuccess:true, afterHidden: afterHidden)
}

func showError(_ message: String ,superView: UIView?, afterHidden: TimeInterval = 1.2) {
    createAlertView(message, superView: superView, isSuccess:false, afterHidden: afterHidden)
}

func hiddenAlertView() {
    alertView?.hide(animated: true)
    alertView = nil
}

private func createAlertView(_ message: String, superView: UIView?, isSuccess: Bool, afterHidden: TimeInterval = 1.2) {
    if superView == nil {
        let supView = UIApplication.shared.windows.last
        alertView = MBProgressHUD.showAdded(to: supView!, animated: true)
    } else {
        alertView = MBProgressHUD.showAdded(to: superView!, animated: true)
    }
    alertView?.mode = MBProgressHUDMode.customView
    alertView?.label.text = message
    alertView?.label.numberOfLines = 0
    alertView?.label.font = UIFont.systemFont(ofSize: 16.0)
    alertView?.contentColor = UIColor.white
    alertView?.bezelView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    let imageView = UIImageView()
    if isSuccess {
        imageView.image = UIImage(named: "加载正确")
    } else {
        imageView.image = UIImage(named: "加载出错")
    }
    alertView?.isUserInteractionEnabled = false
    alertView?.customView = imageView
    alertView?.removeFromSuperViewOnHide = true
    alertView?.hide(animated: true, afterDelay: afterHidden)
}


/// ***************************************************分割线*************************************************///
// MARK: -  根据年月返回月的天数
func getDayFromMonth(_ year: Int,month: Int) -> Int{
    var day:Int = 30
    switch month {
    case 1:
        day = 31
    case 2:
        if year%4 == 0  && year%100 != 0 {
            day = 29
        } else {
            day = 28
        }
    case 3:
        day = 31
    case 4:
        day = 30
    case 5:
        day = 31
    case 6:
        day = 30
    case 7:
        day = 31
    case 8:
        day = 31
    case 9:
        day = 30
    case 10:
        day = 31
    case 11:
        day = 30
    case 12:
        day = 31
    default:
        day = 30
    }
    return day
}


/// ***************************************************分割线*************************************************///
// MARK: -  根据时间字符串返回规定的格式的时间字符串, 参数字符串时间格式 "yyy-MM-dd HH:mm:ss"
public func calculNewEndTime(_ timeString: String) -> String {
    let timeFormatter = DateFormatter()
    timeFormatter.dateFormat = "yyy-MM-dd HH:mm:ss"
    
    let currString = timeFormatter.string(from: Date())
    let arr = currString.components(separatedBy: " ")
    let currYmd:String = arr[0]
    let yMdArr = currYmd.components(separatedBy: "-")
    let currYear: Int = ((yMdArr[0] as NSString).integerValue)
    let currMonth: Int = ((yMdArr[1] as NSString).integerValue)
    let currDay: Int = ((yMdArr[2] as NSString).integerValue)
    
    let array = timeString.components(separatedBy: " ")
    let yMDString = array[0]
    var hMSString = array[1]
    let array1 = NSMutableArray(array: hMSString.components(separatedBy: ":"))
    array1.removeLastObject()
    hMSString = array1.componentsJoined(by: ":")
    let array2 = yMDString.components(separatedBy: "-")
    let year: Int = ((array2[0] as NSString).integerValue)
    let month: Int = ((array2[1] as NSString).integerValue)
    let day: Int = ((array2[2] as NSString).integerValue)
    
    if currYear > year {
        // 不同年
        let array = yMDString.components(separatedBy: "-")
        return array.joined(separator: "") + " " + hMSString
    } else if currMonth > month {
        // 同年不同月
        var diffDay: Int = 0
        if currMonth == 1 {
            diffDay = getDayFromMonth(currYear, month: 12) + currDay - day
        } else {
            diffDay = getDayFromMonth(currDay, month: currMonth-1) - day
        }
        return stringFromDayAndString(diffDay, yMDString: yMDString, hMSString: hMSString)
    } else {
        //同年同月
        let diffDay:Int = currDay - day
        return stringFromDayAndString(diffDay, yMDString: yMDString, hMSString: hMSString)
    }
}

private func stringFromDayAndString(_ diffDay: Int, yMDString: String, hMSString: String) -> String{
    if diffDay == 0 {
        return "今天" + " " + hMSString
    } else if diffDay == 1{
        return "昨天" + " " + hMSString
    } else if diffDay == 2{
        return "前天" + " " + hMSString
    } else {
        let array = NSMutableArray(array: yMDString.components(separatedBy: "-"))
        array.removeObject(at: 0)
        return array.componentsJoined(by: "-") + " " + hMSString
    }
}

/// ***************************************************分割线*************************************************///
// MARK: -  用类名字符串创建该类的对象（工程名需全英文字母，没有符号和汉字等）
public func createObjectWithClassName(_ className: String) -> AnyObject {
    guard
        // 动态获取命名时间
        let nameSpace = Bundle.main.infoDictionary!["CFBundleExecutable"] as? String
        else {
            print("nameSpace error")
            abort()
    }
    guard
        let classType:AnyClass = NSClassFromString(nameSpace + "." + className)
        else {
            print("该类名不存在")
            abort()
    }
    let cla = classType as! NSObject.Type
    let object = cla.self.init()
    return object
}

/// ***************************************************分割线*************************************************///
// MARK: -
public func iPhoneSystem() -> Float {
    return (UIDevice.current.systemVersion as NSString).floatValue
}

/// ***************************************************分割线*************************************************///
// MARK: - 判断是否是字符串，是则返回原字符串，不是返回""
public func asString(_ obj: Any?) -> String {
    return obj as? String ?? ""
}

/// ***************************************************分割线*************************************************///
// MARK: - 时间戳转时间
public func timeStringFromTimeStamp(timeStamp: TimeInterval) -> String{
    //转换为时间
    let date = Date(timeIntervalSince1970: timeStamp/TimeInterval(1000))
    //格式话输出
    let dformatter = DateFormatter()
    dformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return dformatter.string(from: date)
}

/// ***************************************************分割线*************************************************///
// MARK: - 时间戳转时间
public func timeStringFromTimeStampNotYear(timeStamp: TimeInterval) -> String{
    //转换为时间
    let date = Date(timeIntervalSince1970: timeStamp/TimeInterval(1000))
    //格式话输出
    let dformatter = DateFormatter()
    dformatter.dateFormat = "MM-dd HH:mm"
    return dformatter.string(from: date)
}

/// ***************************************************分割线*************************************************///
// MARK: - 距离转换，小于100米，直接返回“<100米”，大于1千米，转成千米，100米到1000米之间，以单位为米
public func distanceTransform(distance: String?) -> String {
    if distance == nil {
        return ""
    }
    
    if let distanceFloat = Float(distance!) {
        if distanceFloat <= 100 {
            return "<100m"
        } else if distanceFloat >= 1000 {
            return String(format: "%.1fkm", distanceFloat/1000)
        } else {
            return String(format: "%.0fm", distanceFloat)
        }
    }
    return ""
}

/// ***************************************************分割线*************************************************///
// MARK: - 判断是不是在中国
public func isLocationOutOfChina(location: CLLocationCoordinate2D) -> Bool {
    if location.longitude < 72.004 || location.longitude > 137.8347 || location.latitude < 0.8293 || location.latitude > 55.8271  {
        return true
    }
    return true;
}

public func windowUserEnabled(_ enabled: Bool) {
    let win = UIApplication.shared.delegate?.window
    if win != nil {
        win!?.isUserInteractionEnabled = enabled
    }
}

public func appdeleWindow() -> UIWindow? {
    return (UIApplication.shared.delegate?.window)!
}




/// 在release模式下不打印信息
public func ZZPrint<N>(_ message: N?, fileName: String = #file, methodName: String = #function, lineNumber: Int = #line){
    #if DEBUGSWIFT // 若是Debug模式下，则打印
        guard let msg = message else {
            print("--  nil  --")
            return
        }
        if let dict = msg as? [String: Any] {
            print(dict as NSDictionary)
        } else if let arr = msg as? [Any] {
            print(arr as NSArray)
        } else {
            print(msg)
        }
    #endif
}

/// 在release模式下不打印信息
public func ZZPrintDetails<N>(_ message: N?, fileName: String = #file, methodName: String = #function, lineNumber: Int = #line) {
    #if DEBUGSWIFT // 若是Debug模式下，则打印
        if message == nil {
            print("\(fileName as NSString)\n方法:\(methodName)\n行号:  \(lineNumber)\n  --  nil  --\n");
        } else {
            print("\(fileName as NSString)\n方法:\(methodName)\n行号:  \(lineNumber)\n\(message!)\n");
        }
    #endif
}

/// 毛玻璃效果视图
///
/// - Parameters:
///   - frame: frame
///   - style: 毛玻璃风格
public func effectView(_ frame: CGRect, _ style: UIBlurEffect.Style) -> UIVisualEffectView {
    let effect = UIBlurEffect(style: style)
    let effectView = UIVisualEffectView(effect: effect)
    effectView.frame = frame
    return effectView
}

public func postNotication(_ name: String, _ object: Any?,_ userInfo: [AnyHashable : Any]?) {
    NotificationCenter.default.post(name: NSNotification.Name(rawValue: name), object: object, userInfo: userInfo)
}

public func postNotication(_ notification: Notification) {
    NotificationCenter.default.post(notification)
}

public func addNoticationObserver(_ observer: Any,_ selector: Selector, _ nameStr: String, _ object: Any?) {
    NotificationCenter.default.addObserver(observer, selector: selector, name: NSNotification.Name(rawValue: nameStr), object: object)
}

public func addNoticationObserver(_ observer: Any,_ selector: Selector, _ notiName: NSNotification.Name?, _ object: Any?) {
    NotificationCenter.default.addObserver(observer, selector: selector, name: notiName, object: object)
}

