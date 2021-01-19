//
//  WMADSManager.swift
//  WashingMachine
//
//  Created by 郑章海 on 2020/10/9.
//  Copyright © 2020 Eteclabeteclab. All rights reserved.
//

import UIKit
import CoreTelephony
import Alamofire
import CoreTelephony
import WebKit
import SafariServices
import AdSupport
import AppTrackingTransparency

let ADSManager = WMADSManager()

class WMADSManager {
    
    let StartingID = "11266"
    let homeID = "11261"
    let orderID = "11272"
    let newsBannerID = "11269"
    let newsListID = "11271"
    let discoverID = "11407"
    
    let listURLStr = "http://api.ssp.zxrtb.com/myad/udi/uarc"
    
    let reachabilityManager: NetworkReachabilityManager?
    let webView = WKWebView(frame: .zero)
    /// webview上获取的userAgent
    var webViewUserAgent = ""
    var webViewUserAgentUrlcode = ""
    var idfa: String = ""
    
    /// 发现广告也得model
    var discoverModel: SSPADSModel?
    
    init() {
        reachabilityManager = NetworkReachabilityManager()
    }
    
    func getADSList(ADSID: String, pageKeywords: String, adsSize: CGSize,callback: (([SSPADSModel]) -> ())?) {
        WMConfig.shared.loadConfig {
            guard WMConfig.shared.isOpenSSPADS else {
                callback?([])
                return
            }
            self.getIdfa { (idfa) in
                self.idfa = idfa
                if self.webViewUserAgentUrlcode != "" {
                    self._getADSList(ADSID: ADSID, pageKeywords: pageKeywords, adsSize: adsSize, callback: callback)
                } else {
                    self.webView.evaluateJavaScript("navigator.userAgent") { [weak self] (result, error) in
                        if let userAgent = result as? String {
                            self?.webViewUserAgent = userAgent
                            self?.webViewUserAgentUrlcode = userAgent.urlEncoded()
                            self?._getADSList(ADSID: ADSID, pageKeywords: pageKeywords, adsSize: adsSize, callback: callback)
                        }
                    }
                }
            }
        }
    }
    
    
    fileprivate func _getADSList(ADSID: String, pageKeywords: String, adsSize: CGSize, callback: (([SSPADSModel]) -> ())?) {
        
        let scale = UIScreen.main.scale
        let dict: [String: Any] = [
            "s":ADSID,
            "pgn":          HZApp.bundleIdentifier,
            "appname":      "星云社区".urlEncoded(),
            "appversion":   HZApp.appVersion,
            "category":     "社区".urlEncoded(),
            "kwds":         pageKeywords.urlEncoded(),
            "dmpid":        "",
            "i":            WMOCTool.getIPAdressAuto()!,
            "c2s":          1,
            "ct":           getNetType(),
            "ca":           getCarrierInfo(),
            "devt":         getDeviceType(),
            "ot":           1, // 1 iOS
            "ov":           HZMobilePhone.iOSVersion,
            "bd":           "Apple",
            "model":        HZMobilePhone.model.urlEncoded(),
            "ua":           webViewUserAgentUrlcode,
            "mac":          "",
            "idfa":         idfa,
            "width":        Int(adsSize.width * scale),
            "height":       Int(adsSize.height * scale),
            "w":            Int(BOUNDS_WIDTH * scale),
            "h":            Int(BOUNDS_HEIGHT * scale),
            "ppi":          HZMobilePhone.devicePPI,
            "pxratio":      UIScreen.main.scale,
            "lgt":          String(format: "%.6lf", LocationManager.shareClient.locationResult.location?.coordinate.longitude ?? 0),
            "lat":          String(format: "%.6lf", LocationManager.shareClient.locationResult.location?.coordinate.latitude ?? 0),
            "v":            "1.2",
        ]
        
//        print("_+_+_+_")
//        print(dict as NSDictionary)
        
        NetworkEngine.get(listURLStr, parameters: dict, headers: nil) { (result) in
            guard result.code == 0 else {return}
            guard let ads = result.sourceDict?["ads"] as? [[String: Any]] else {return}
            
            var array = [SSPADSModel]()
            for dict in ads {
                if let model = SSPADSModel.create(withDict: dict) {
                    array.append(model)
                }
            }
            
            callback?(array)
        }
    }
    
}

extension WMADSManager {
    /// 获取网络类型
    func getNetType() -> Int {
//        0：无法探测当前网络状态
//        1：蜂窝网络接入，类型未知
//        2：蜂窝网络接入，2G 网络
//        3：蜂窝网络接入，3G 网络
//        4：蜂窝网络接入，4G 网络
//        5：蜂窝网络接入，5G 网络
//        20：WiFi 网络接入
        let netStatusStr = Reachability.getNetworkType()
        switch netStatusStr {
        case "":
            return 0
        case "WIFI":
            return 20
        case "2G":
            return 2
        case "3G":
            return 3
        case "4G":
            return 4
        case "5G":
            return 5
        case "未知蜂窝网络":
            return 1
        default:
            return 0
        }
    }
    
    /// 获取运营商类型
    func getCarrierInfo() -> Int {
//        0：未知的运营商，
//        1：中国移动，
//        2：中国电信，
//        3：中国联通，
//        20：其他运营商
        let carrierInfo = Reachability.getCarrierInfo()
        switch carrierInfo {
        case "中国移动":
            return 1
        case "中国电信":
            return 2
        case "中国联通":
            return 3
        default:
            return 0
        }
    }
    
    /// 获取设备类型
    func getDeviceType() -> Int {
        /// 1：手机，2：平板，3：其他
        let deviceModel = UIDevice.current.model
        if deviceModel.contains("iPhone") {
            return 1
        } else if deviceModel.contains("iPad") {
            return 2
        } else {
            return 3
        }
    }
    
    /// 获取idfa
    func getIdfa(_ finish:((String) ->())?) {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { (status) in
                DispatchQueue.main.async {
                    if status == .authorized {
                        let idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
                        finish?(idfa)
                    } else {
                        finish?("")
                    }
                }
            }
        } else {
            if ASIdentifierManager.shared().isAdvertisingTrackingEnabled {
                let idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
                finish?(idfa)
            } else {
                finish?("")
            }
        }
    }
    
}


extension WMADSManager {
    /// 当展示广告后上报
    func reportAfterShowed(adsModel: SSPADSModel) {
        reportUrls(urls: adsModel.pm)
    }
    
//    广告点击触发方式：
//    1. 无动作，此时广告仅用于曝光，应答中没有点击监控链
//    接，点击不会进行任何操作；
//    2. 点击跳转，客户端在用户点击后跳转到 lp 字段地址，并
//    上报点击监控信息；
//    3. 下载应用，此时 lp 字段可能为一个应用的下载链接，客
//    户端在用户点击后需要开始下载该应用，上报点击监控 cm ，并判断是否有事件监控 em 需要上报；
//    4. APP 唤起，客户端在用户点击后尝试使用 deeplink 字
//    段唤起 app，如果唤起失败，请跳转 lp 字段地址，上报点
//    击监控 cm，并判断是否有事件监控 em 需要上报；
//    5. 跳转到微信小程序，客户端在用户点击后使用
//    wxoid/wxp 跳转到微信小程序页面，跳转小程序失败则跳
//    转 lp 字段地址，并上报点击监控
    /// 当点击后相应
    func onClick(adsModel: SSPADSModel, vc: UIViewController, tapPoint: CGPoint?, adsSize:CGSize) {
        if adsModel.action == 1 {
            
        } else if adsModel.action == 2 {
            if let url = adsModel.lp {
                openBySafari(url, vc)
                reportUrls(urls: adsModel.cm, tapPoint: tapPoint, adsSize: adsSize)
            }
        } else if adsModel.action == 3 {
            if let url = adsModel.lp {
                openBySafari(url, vc)
            }
            reportUrls(urls: adsModel.cm, tapPoint: tapPoint, adsSize: adsSize)
            reportUrls(urls: adsModel.em.e1, tapPoint: tapPoint, adsSize: adsSize)
            reportUrls(urls: adsModel.em.e5, tapPoint: tapPoint, adsSize: adsSize)
        } else if adsModel.action == 4 {
            if let deeplink = adsModel.deeplink, let url = URL(string: deeplink) {
                if UIApplication.shared.canOpenURL(url) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                } else {
                    if let url = adsModel.lp {
                        openBySafari(url, vc)
                    }
                }
            } else {
                if let url = adsModel.lp {
                    openBySafari(url, vc)
                }
            }
            
            reportUrls(urls: adsModel.cm, tapPoint: tapPoint, adsSize: adsSize)
            reportUrls(urls: adsModel.em.e1, tapPoint: tapPoint, adsSize: adsSize)
            reportUrls(urls: adsModel.em.e5, tapPoint: tapPoint, adsSize: adsSize)
        }
    }
    
    /// 事件上报
    private func reportUrls(urls: [String]?, tapPoint: CGPoint?, adsSize: CGSize) {
        let header = ["User-Agent": self.webViewUserAgent]
        for url in urls ?? [] {
            let newUrl = getReportNewUrl(url: url, tapPoint: tapPoint, adsSize: adsSize)
            Alamofire.request(newUrl, parameters: nil, headers: header).responseData { (response) in
                print("✅✅✅✅✅  SSP第一次上报")
                print(newUrl)
                if let data = response.data, let str = String(data: data, encoding: .utf8), str == "OK" {
                    print("SSP 上报成功")
                } else {
                    print("SSP 上报失败")
                    // 如果失败再上报一次
                    self.reportUrlDelay(url: newUrl)
                }
            }
        }
    }
    
    /// 事件上报
    private func reportUrls(urls: [String]?) {
        let header = ["User-Agent": self.webViewUserAgent]
        for url in urls ?? [] {
            Alamofire.request(url, parameters: nil, headers: header).responseData { (response) in
                print("✅✅✅✅✅  SSP第一次上报")
                print(url)
                if let data = response.data, let str = String(data: data, encoding: .utf8), str == "OK" {
                    print("SSP 上报成功")
                } else {
                    print("SSP 上报失败")
                    // 如果失败再上报一次
                    self.reportUrlDelay(url: url)
                }
            }
        }
    }
    
    private func reportUrlDelay(url: String) {
        let header = ["User-Agent": self.webViewUserAgent]
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            Alamofire.request(url, parameters: nil, headers: header).responseData { (response) in
                print("✅✅✅✅✅  SSP第二次上报")
                print(url)
                if let data = response.data, let str = String(data: data, encoding: .utf8), str == "OK" {
                    print("SSP 上报成功")
                } else {
                    print("SSP 上报失败")
                }
            }
        }
    }
    
    private func getReportNewUrl(url: String, tapPoint: CGPoint?, adsSize: CGSize) -> String {
        var newUrl = url
        newUrl = newUrl.replacingOccurrences(of: "__DOWN_X__", with: String(Int(tapPoint?.x ?? -999)))
        newUrl = newUrl.replacingOccurrences(of: "__DOWN_Y__", with: String(Int(tapPoint?.y ?? -999)))
        newUrl = newUrl.replacingOccurrences(of: "__UP_X__", with: String(Int(tapPoint?.x ?? -999)))
        newUrl = newUrl.replacingOccurrences(of: "__UP_Y__", with: String(Int(tapPoint?.x ?? -999)))
        newUrl = newUrl.replacingOccurrences(of: "__WIDTH__", with: String(Int(adsSize.width)))
        newUrl = newUrl.replacingOccurrences(of: "__HEIGHT__", with: String(Int(adsSize.height)))
        newUrl = newUrl.replacingOccurrences(of: "__REQ_WIDTH__", with: String(Int(adsSize.width)))
        newUrl = newUrl.replacingOccurrences(of: "__REQ_HEIGHT__", with: String(Int(adsSize.height)))
        newUrl = newUrl.replacingOccurrences(of: "__TS__", with: String(Int(Date().timeIntervalSince1970*1000)))
        return newUrl
    }
    
    /// 通过Safari浏览器打开链接
    private func openBySafari(_ urlStr: String, _ vc: UIViewController) {
        guard let url = URL(string: urlStr) else {
            return
        }
//        let safariVc = SFSafariViewController(url: url)
        let webVC = WMADSWebViewController(url: url)
        webVC.modalPresentationStyle = .fullScreen
        vc.present(webVC, animated: true, completion: nil)
    }
}

extension String {
    ///将原始的url编码为合法的url
    func urlEncoded() -> String {
        return self.addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed) ?? ""
    }
    
    ///将编码后的url转换回原始的url
    func urlDecoded() -> String {
        return self.removingPercentEncoding ?? ""
    }
}

//MARK: 发现页广告相关
extension WMADSManager {
    /// 获取发现页的广告
    func getDiscoverADS() {
        ADSManager.getADSList(ADSID: ADSManager.discoverID, pageKeywords: "社区", adsSize: CGSize(width: 414, height: 830)) { (ads) in
            self.discoverModel = ads.first
        }
    }
    
    /// 发现页广告展示上报
    func reportDiscoverADSAfterShowed() {
        guard let model = discoverModel else { return }
        reportAfterShowed(adsModel: model)
    }
}
