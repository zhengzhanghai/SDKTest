//
//  WeChatManager.swift
//  WashingMachine
//
//  Created by zzh on 2017/7/14.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

import UIKit

/// 通过回调的code获取access_token的url
fileprivate let url_get_access_token = "https://api.weixin.qq.com/sns/oauth2/access_token"
/// 获取用户资料
fileprivate let url_get_userInfo = "https://api.weixin.qq.com/sns/userinfo"

enum WeChatShareType: Int {
    case friend
    case circleFriend
    case favorite
}

typealias WeChatAuthCallBack = ((WeChatAuthResult)->())

/// 每次发起认证都会更新，回调时会验证此串
fileprivate var authStatus: String = "com.nubula"

class WeChatManager: NSObject {
    
    internal static let instance = WeChatManager()
    /// 支付回调
    var payCallBack: NCPayCallBackClourse?
    /// 认证回调
    var authCallBack: WeChatAuthCallBack?
    
    /// 注册微信
    class func registerToApp(){
        WXApi.registerApp(WXAPPID)
    }
    
    /// 是否安装了客户端
    ///
    /// - Returns: 是返回true
    class func isInstalled() -> Bool {
        return WXApi.isWXAppInstalled()
    }
}

//MARK: *******  支付相关  *******
extension WeChatManager {
    
    /// 发起支付，会先检查是否安装客户端
    ///
    /// - Parameter payReq: 支付信息
    class func sendPay(_ payReq: PayReq) {
        if !isInstalled() { // 未安装客户端
            let payResult = NCPayResult()
            payResult.type = .notInstalled
            payResult.desp = "未安装微信客户端"
            WeChatManager.instance.payCallBack?(payResult)
            promptNotInstalled()
            return
        }
        let payResult = NCPayResult()
        payResult.type = .beforeEvokePayApp
        payResult.desp = "调起支付前最后回调"
        WeChatManager.instance.payCallBack?(payResult)
        // 吊起客户端发起支付
        WXApi.send(payReq)
    }
    
    class func promptNotInstalled() {
        let alertVC = UIAlertController(title: "请先安装微信客户端", message: "", preferredStyle: .alert)
        let sureAction = UIAlertAction(title: "确定", style: .default, handler: nil)
        alertVC.addAction(sureAction)
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.window?.rootViewController?.present(alertVC, animated: true, completion: { 
                
            })
        }
    }
}

//MARK: *******  授权、登录相关  *******
extension WeChatManager {
    /// 发起微信授权
    class func sendAuthRequest(_ compeleteHandler: WeChatAuthCallBack?) {
        if !isInstalled() {
            promptNotInstalled()
            return
        }
        WeChatManager.instance.authCallBack = compeleteHandler
        let authReq = SendAuthReq()
        authReq.scope = "snsapi_userinfo"
        authStatus = "com.nebula\(arc4random()))".md5()
        authReq.state = authStatus
        WXApi.send(authReq)
    }
    
    /// 通过回调的code获取token
    ///
    /// - Parameter code: 回调的code
    class func loadAccessToken(_ code: String) {
        let params = ["appid": WXAPPID, "secret": WXSECRET, "code": code, "grant_type": "authorization_code"] as [String: AnyObject]
        NetworkEngine.get(url_get_access_token, parameters: params) { (result) in
            if let json = result.sourceDict {
                if let openId = json["openid"] as? String{
                    if let access_token = json["access_token"] as? String {
                        loadUserInfo(openId, access_token)
                        return
                    }
                }
            }
            let authResult = WeChatAuthResult()
            authResult.type = .requestUrlError
            authResult.desp = "获取token、openid异常"
            WeChatManager.instance.authCallBack?(authResult)
        }
    }
    
    class func loadUserInfo(_ openId: String, _ access_token: String) {
        let params = ["access_token": access_token,
                      "openid": openId,
                      "lang": "zh_CN"] as [String: AnyObject]
        NetworkEngine.get(url_get_userInfo, parameters: params) { (result) in
            let authResult = WeChatAuthResult()
            if let json = result.sourceDict {
                authResult.city = json["city"] as? String
                authResult.privilege = json["privilege"] as? [Any]
                authResult.headimgurl = json["headimgurl"] as? String
                authResult.openId = json["openid"] as? String
                authResult.nickname = json["nickname"] as? String
                authResult.province = json["province"] as? String
                authResult.country = json["country"] as? String
                authResult.sex = json["sex"] as? NSNumber
                
                authResult.type = .success
                authResult.desp = "获取资料成功"
            } else {
                authResult.type = .requestUrlError
                authResult.desp = "获取用户资料异常"
            }
            WeChatManager.instance.authCallBack?(authResult)
        }
    }
}

//MARK: *******  分享相关  *******
extension WeChatManager {
    /// 分享文本
    ///
    /// - Parameters:
    ///   - share: 分享内容
    ///   - notInstanceApp: 未安装微信啊App回调
    class func shareText(_ share: WeChatShare, notInstanceApp: (()->())?) {
        if !isInstalled() {
            promptNotInstalled()
            notInstanceApp?()
            return
        }
        let req = SendMessageToWXReq()
        req.text = share.title ?? ""
        req.bText = true
        req.scene = share.typeIndex()
        WXApi.send(req)
    }
    
    /// 分享网页
    ///
    /// - Parameters:
    ///   - share: 分享内容
    ///   - notInstanceApp: 未安装微信啊App回调
    class func shareWebpage(_ share: WeChatShare, notInstanceApp: (()->())?) {
        if !isInstalled() {
            promptNotInstalled()
            notInstanceApp?()
            return
        }
        
        let webpageObj = WXWebpageObject()
        webpageObj.webpageUrl = share.webpageUrl ?? ""
        
        let message = WXMediaMessage()
        message.title = share.title ?? ""
        message.description = share.desp ?? ""
        message.setThumbImage(share.image)
        message.mediaObject = webpageObj
        
        let req = SendMessageToWXReq()
        req.bText = false
        req.message = message
        req.scene = share.typeIndex()
        WXApi.send(req)
    }
}

//MARK:  ********* 回调 *********
extension WeChatManager: WXApiDelegate {
    func onReq(_ req: BaseReq!) {
        //onReq是微信终端向第三方程序发起请求，要求第三方程序响应。第三方程序响应完后必须调用sendRsp返回。在调用sendRsp返回时，会切回到微信终端程序界面。
    }
    
    func onResp(_ resp: BaseResp) {
        // 从微信回调
        DispatchQueue.main.async {
            // 支付回调
            if let payResp = resp as? PayResp {
                let payResult = NCPayResult()
                switch payResp.errCode {
                case 0:
                    payResult.type = .success
                    payResult.desp = "微信支付成功"
                case -1:
                    payResult.type = .defeated
                    payResult.desp = "微信支付失败"
                case -2:
                    payResult.type = .cancel
                    payResult.desp = "已取消支付"
                default:
                    payResult.type = .otherError
                    payResult.desp = payResp.errStr
                }
                
                print("*********  微信支付结果  ***********")
                print("-----   " + payResult.desp + "   -----")
                print("***********************************")
                
                self.payCallBack?(payResult)
            }
            
            //微信登录回调
            if let res = resp as? SendAuthResp {
                let authResult = WeChatAuthResult()
                authResult.type = .startCallBack
                authResult.desp = "刚从微信回调"
                self.authCallBack?(authResult)
                ZZPrint("微信登录回调")
                if res.errCode == 0 {
                    if res.state == authStatus {
                        WeChatManager.loadAccessToken(res.code)
                    } else {
                        authResult.type = .authStatusError
                        authResult.desp = "认证的status错误"
                        self.authCallBack?(authResult)
                    }
                } else if res.errCode == -2 {
                    authResult.type = .cancel
                    authResult.desp = "取消了认证"
                    self.authCallBack?(authResult)
                } else {
                    authResult.type = .other
                    authResult.desp = "未知错误"
                    self.authCallBack?(authResult)
                }
            }
        }
        
        //微信分享回调
        if resp.isKind(of: SendMessageToWXResp.self) {
            if resp.errCode == WXSuccess.rawValue {
                //分享成功 ，发出分享成功通知
            }else{
                //分享失败
            }
        }
    }
}
