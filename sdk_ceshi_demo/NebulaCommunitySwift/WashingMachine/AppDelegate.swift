//
//  AppDelegate.swift
//  WashingMachine
//
//  Created by Moguilay on 2016/10/24.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

import UIKit
import UserNotifications
import Kingfisher

let nc_appdelegate = UIApplication.shared.delegate as? AppDelegate
let windowRootView = (UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController?.view
fileprivate let shortcutItemWashingKey = "com.nebula.washing"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var tabController: UITabBarController!
    //将支付宝结果状态码传出
    var AlipayResultClourse:((String)->())?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        removeUserInfoInVersion_2_3_0_orLaterIfNeed()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        window?.makeKeyAndVisible()
        if #available(iOS 13.0, *) { // 关闭暗黑模式
            window?.overrideUserInterfaceStyle = .light
        }
        initSystemTabbarController()
        window?.rootViewController = tabController
        WeChatManager.registerToApp()
        addJPUSHService(launchOptions: launchOptions)
        // 数据采集
        HZDataStatistics.shareManager()
//        DBAcquisition.sharedManager().channelId = "AppStore"
        /// icon Touch
//        addShartcutItem();
//        NSNotification.Name.UIApplicationDidReceiveMemoryWarning
        addNoticationObserver(self, #selector(didReceiveMemoryWarning), UIApplication.didReceiveMemoryWarningNotification, nil)
        
        NCLocation.startLocation()
        
        /// 刷新用户账户余额
        UserBalanceManager.share.asynRefreshBalance()
        
        // 获取发现页的广告
//        ADSManager.getDiscoverADS()
//        changeDiscoverIfNeed()
        
        return true
    }
    
    /// 内存警告处理
    @objc fileprivate func didReceiveMemoryWarning() {
        KingfisherManager.shared.cache.clearDiskCache()
        KingfisherManager.shared.cache.clearMemoryCache()
    }
    
    fileprivate func initSystemTabbarController() {
//        let titles = ["首页", "发现", "我的"]
//        let normalIcons = ["tab_home", "tab_discover", "tab_me"]
//        let selectedIcons = ["tab_home_ed", "tab_discover_ed", "tab_me_ed"]
//
//        let controllers = [HomeViewController(), DiscoverViewController(), MeViewController()]
//        var vcs = [UINavigationController]()
//        for i in 0 ..< titles.count {
//            vcs.append(createTabbarItem(controllers[i], titles[i], normalIcons[i], selectedIcons[i]))
//        }
//        tabController = UITabBarController()
//        tabController.viewControllers = vcs
//        tabController.tabBar.tintColor = THEMECOLOR
        
        
        tabController = MainTabbarViewController()
    }
    
    fileprivate func createTabbarItem(_ vc: UIViewController, _ title: String, _ normalIcon: String, _ selectedIcon: String) -> UINavigationController{
        let navc = UINavigationController(rootViewController: vc)
        navc.tabBarItem.title = title
        navc.tabBarItem.image = UIImage(named: normalIcon)?.withRenderingMode(.alwaysOriginal)
        navc.tabBarItem.selectedImage = UIImage(named: selectedIcon)?.withRenderingMode(.alwaysOriginal)
        return navc
    }
    
    // 添加极光推送服务
    func addJPUSHService(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        registerJPUSH()
        JPUSHService.setup(withOption: launchOptions,
                           appKey: JPush_APPKEY,
                           channel: "AppStore",
                           apsForProduction: false)
        JPUSHService.registrationIDCompletionHandler { (resCode, registrationID) in
            ZZPrint("------------  极光推送id  -------------\n"
                + (registrationID ?? "")
                + "\n--------------------------------------")
            UserDefaults.standard.set(registrationID, forKey: JPush_RegistrationID_Key)
            UserDefaults.standard.synchronize()
        }
    }
    
    // 添加icon touch功能
    func addShartcutItem() {
        if #available(iOS 9.1, *) {
            let shortcutIcon = UIApplicationShortcutIcon(templateImageName: "shortcut_washing");
            let shortcutItem = UIApplicationShortcutItem(type: shortcutItemWashingKey, localizedTitle: "一键洗衣", localizedSubtitle: "", icon: shortcutIcon, userInfo: nil);
            UIApplication.shared.shortcutItems = [shortcutItem];
        }
    }
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        switch shortcutItem.type {
        case shortcutItemWashingKey:
            if let vcs = tabController.viewControllers {
                for vc in vcs {
                    if let navc = vc as? UINavigationController {
                        navc.popToRootViewController(animated: false)
                    }
                }
            }
            tabController.selectedIndex = 0
            if let navc = tabController.viewControllers?.first as? UINavigationController  {
                if let vc = navc.topViewController as? BaseViewController{
                    if !isLogin() {
                        LoginViewModel.pushLoginController(vc)
                    } else {
                        DeviceViewModel.pushScanVC(vc)
                    }
                }
            }
        default:
            ZZPrint("shortcutItem 未知")
        }
        completionHandler(true)
    }
    
    func registerJPUSH() {
        if #available(iOS 10.0, *) {
            let entiity = JPUSHRegisterEntity()
            entiity.types = Int((UIUserNotificationType.badge.union(UIUserNotificationType.sound).union(UIUserNotificationType.alert)).rawValue)
            JPUSHService.register(forRemoteNotificationConfig: entiity, delegate: self)
        } else if #available(iOS 8.0, *) {
            JPUSHService.register(forRemoteNotificationTypes: (UIUserNotificationType.badge.union(UIUserNotificationType.sound).union(UIUserNotificationType.alert)).rawValue, categories:nil)
        }else {
            JPUSHService.register(forRemoteNotificationTypes: (UIUserNotificationType.badge.union(UIUserNotificationType.sound).union(UIUserNotificationType.alert)).rawValue, categories:nil)
        }
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        if url.scheme == WXAPPID {
            return WXApi.handleOpen(url, delegate: WeChatManager.instance)
        } else if url.host == "safepay"{
            //跳转支付宝钱包客户端进行支付，处理支付结果
            AlipaySDK.defaultService().processOrder(withPaymentResult: url, standbyCallback: { (resultDic) in
                DispatchQueue.main.async {
                    NCAlipayManger.dealOpenURLResult(resultDic)
                }
            })
        }
        return true
    }
 
    func applicationWillResignActive(_ application: UIApplication) {
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }
    
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        ZZPrint(url.scheme)
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
        UserBalanceManager.share.asynRefreshBalance()
        // 检查token
        LoginViewModel.checkToken { (isEffection, message, error) in
            if !isEffection && (error == nil) {
                ZZPrint("****** token失效 *******")
                LoginViewModel.updateJPushRegister(getUserId(), jpushId: "0", nil)
                UserInfoModel.deleteLocal()
                UserBaseInfoModel.deleteLocal()
                UserBalanceManager.share.reSet()
            }
        }
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
    }
    
    /**
     极光推送  接收到通知
     */
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        ZZPrint("------接到通知")
        
        application.applicationIconBadgeNumber = 0
//        self.dealNotifationMessage(application, userInfo: userInfo)
        JPUSHService.handleRemoteNotification(userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    /**
     处理推送过来的消息
     */
    func dealNotifationMessage(_ application: UIApplication, userInfo: [AnyHashable: Any]?) {
        ZZPrint("dealNotifationMessage")
        if userInfo == nil {
            return
        }
        if !isLogin() {
            return
        }
        ZZPrint(userInfo)
        if let info = userInfo?["notification_key"] as? String {
            if let data = info.data(using: String.Encoding.utf8) {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any] {
                        ZZPrint(json)
                        if let type = json["type"] as? String {
                            if type == "1" {
//                                if let orderId = json["id"] as? String {
//                                    if(application.applicationState == .active) {
//                                        ZZPrint("------接到通知--前台")
////                                        self.alertGoOrderDetails(orderId: orderId)
//                                    } else {
//                                        ZZPrint("------接到通知--后台")
////                                        self.goOrderDetails(orderId: orderId)
//                                    }
//                                }
                            }
                        }
                    }
                } catch {
                    
                }
            }
        }
    }
    
    // 订单推送收到消息提示
    func alertGoOrderDetails(orderId: String?) {
        let alertVC = UIAlertController(title: "提示", message: "收到一条推送消息，是否前往查看?", preferredStyle: .alert)
        let sureAction = UIAlertAction(title: "确定", style: .default) { (_) in
//            self.goOrderDetails(orderId: orderId!)
        }
        let cancelAction = UIAlertAction(title: "取消", style: .default) { (_) in
            
        }
        alertVC.addAction(sureAction)
        alertVC.addAction(cancelAction)
    }

    
    // 进入订单详情页
    func goOrderDetails(orderId: String) {
//        if let orderIdInt = Int(orderId) {
//            let number = NSNumber(value: orderIdInt)
//            let vc = DealDetailViewController()
//            vc.orderId = number
//            vc.hidesBottomBarWhenPushed = true
//            let currentVC = WMTabbarController.shareClient.currentRootVC
//            if currentVC?.navigationItem.title == "扫描" {
//                if let scanNavi = currentVC as? UINavigationController {
//                    scanNavi.pushViewController(vc, animated: true)
//                }
//            } else {
//                currentVC?.navigationController?.pushViewController(vc, animated: true)
//            }
//        }
    }
}

// MARK: 极光推送，通知相关
extension AppDelegate : JPUSHRegisterDelegate {
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken:Data) {
        JPUSHService.registerDeviceToken(deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
    }
    
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
        ZZPrint("willPresent")
        let userInfo = notification.request.content.userInfo;
        if notification.request.trigger is UNPushNotificationTrigger {
            JPUSHService.handleRemoteNotification(userInfo);
        }
        completionHandler(Int(UNNotificationPresentationOptions.alert.rawValue))
    }
    
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
        ZZPrint("didReceive")
        let userInfo = response.notification.request.content.userInfo
        if response.notification.request.trigger is UNPushNotificationTrigger {
            JPUSHService.handleRemoteNotification(userInfo);
        }
        let application = UIApplication.shared
        application.applicationIconBadgeNumber = 0
        NotificationCenter.default.post(name: Notification.Name(rawValue: "qqqqqq"), object: nil)
//        let info = response.notification.request.content.userInfo
//        self.dealNotifationMessage(application, userInfo: info)
        completionHandler()
        
    }
}
