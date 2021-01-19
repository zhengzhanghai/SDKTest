//
//  LoginViewModel.swift
//  WashingMachine
//
//  Created by zzh on 2017/8/17.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

import UIKit

enum RegisterType {
    case register
    case reset
}

class LoginViewModel: NSObject {
    /// 跳转到登录页
    ///
    /// - Parameter superController: 父控制器
    class func pushLoginController(_ superController: BaseViewController?) {
        let vc = LoginViewController()
        superController?.pushViewController(vc)
    }
    
    class func pushRegisterVC(_ type: RegisterType, _ superController: BaseViewController?) {
        let vc = RegisterViewController()
        vc.type = type
        superController?.pushViewController(vc)
    }
}

extension LoginViewModel {
    /// 发送短信验证码
    ///
    /// - Parameters:
    ///   - mobile: 手机号
    ///   - type: 类型  1注册  3重置密码
    ///   - compeleteHandler: 回调闭包
    class func sendMobileAuthCode(_ mobile: String, _ type: RegisterType, _ imageCode: String, _ sessionId: String, _ compeleteHandler:((Bool, String?, String)->())?) {
//        let url = SERVICE_BASE_ADDRESS + API_GET_MOBICODE
        let url = SERVICE_BASE_ADDRESS + API_GET_MOBICODE_NEW
        var params = [String: Any]()
        params["m"] = mobile
        params["code"] = imageCode
        if type == .register {
            params["type"] = "1"
        } else {
            params["type"] = "3"
        }
        let headers = ["SESSION": sessionId]
        
        NetworkEngine.get(url, parameters: params, headers: headers) { (result) in
            var isSuccess: Bool = false
            var authCodeStr: String?
            var messageStr = result.error?.message ?? ""
            if let dict = result.dataObj as? [String: AnyObject] {
                if let authCode = dict["authCode"] as? String {
                    authCodeStr = authCode
                }
                if let message = dict["message"] as? String {
                    messageStr = message
                }
            }
            if result.isSuccess {
                isSuccess = true
            }
            compeleteHandler?(isSuccess, authCodeStr, messageStr)
        }
    }
    
    /// 登录
    ///
    /// - Parameters:
    ///   - accountName: 用户名
    ///   - password: 密码
    ///   - compeleteHandler: 回调闭包
    class func login(_ accountName: String,
                     _ password: String,
                     _ compeleteHandler: ((UserInfoModel?, String)->())?)
    {
        let url = SERVICE_BASE_ADDRESS + API_POST_LOGIN
        let params = ["accountName": accountName, "password": password]
        NetworkEngine.postJSON(url, parameters: params) { (result) in
            if result.isSuccess {
                if let dict = result.dataObj as? [String: AnyObject] {
                    let userModel = UserInfoModel.create(dict)
                    userModel.writeLocal()
                    compeleteHandler?(userModel, result.message)
                    return
                }
            }
            compeleteHandler?(nil, result.message)
        }
    }
    
    /// 检查token是否有效,只有在登录状态是才去检测
    ///
    /// - Parameter compeleteClurse: 回调闭包
    class func checkToken(_ compeleteClurse:VMJudgeClourse?) {
        if !isLogin() {
            ZZPrint("*****  未登录  ******")
            return
        }
        let url = SERVICE_BASE_ADDRESS + API_GET_TOKEN + getToken()
        NetworkEngine.get(url, parameters: nil) { (result) in
            if result.isSuccess {
                ZZPrint("********  检查token有效  *********")
                compeleteClurse?(true, result.message, result.error)
            } else {
                ZZPrint("********  检查token无效  *********")
                compeleteClurse?(false, result.message, result.error)
            }
        }
    }
    
    /// 注册
    ///
    /// - Parameters:
    ///   - mobile: 手机号
    ///   - password: 密码
    ///   - authCode: 短信验证码
    ///   - compeleteHandler: 回调闭包
    class func register(_ mobile: String,
                        _ password: String,
                        _ authCode: String,
                        compeleteHandler:((Bool, String? , String?, String)->())?)
    {
        let url = SERVICE_BASE_ADDRESS + API_POST_REGISTER
        let params  = ["accountName": mobile,
                       "password": password,
                       "authCode": authCode]
        
        let bundleId = String(format: "iOS.%@", Bundle.main.bundleIdentifier ?? "")
        let appKey = bundleId.md5()
        let headers = ["osName": String(format: "iOS %@", UIDevice.current.systemVersion),
                       "appkey" : appKey]
        NetworkEngine.postJSON(url, parameters: params, headers: headers) { (result) in
            var isSuccess: Bool = false
            var userIdStr: String?
            var tokenStr: String?

            if let dict = result.dataObj as? [String: AnyObject] {
    
                if result.isSuccess {
                    isSuccess = true
                    if let userId = dict["userId"] as? NSNumber {
                        userIdStr = userId.stringValue
                    }
                    if let token = dict["token"] as? String {
                        tokenStr = token
                    }
                }
            }
            compeleteHandler?(isSuccess, userIdStr, tokenStr, result.message)
        }
    }
    
    /// 重置密码
    ///
    /// - Parameters:
    ///   - mobile: 手机号
    ///   - password: 新密码
    ///   - authCode: 短信验证码
    ///   - compeleteHandler: 回调闭包
    class func resetPassword(_ mobile: String,
                             _ password: String,
                             _ authCode: String,
                             compeleteHandler:((Bool, String)->())?) {
        let url = SERVICE_BASE_ADDRESS + API_POST_PASSWORD_RESET
        let params  = ["mobile": mobile,
                       "password": password,
                       "authCode": authCode]
        NetworkEngine.postJSON(url, parameters: params) { (result) in
            compeleteHandler?(result.isSuccess, result.message)
        }
    }
    
    /// 退出登录
    ///
    /// - Parameters:
    ///   - token: token
    ///   - compeleteHandler: 回调block
    class func loginOut(_ token: String, _ compeleteHandler: ((Bool, String)->())?) {
        let url = SERVICE_BASE_ADDRESS + API_POST_LOGOUT + "?token=\(token)"
        NetworkEngine.get(url, parameters: nil) { (result) in
            compeleteHandler?(result.isSuccess,
                              result.message)
        }
    }
    
    /// 向服务器更新极光推送id
    ///
    /// - Parameters:
    ///   - userId: 用户id
    ///   - jpushId: 极光注册设备id
    ///   - compeleteHandler: 回调闭包
    class func updateJPushRegister(_ userId: String, jpushId: String, _ compeleteHandler: ((Bool, String)->())?) {
        let url = SERVICE_BASE_ADDRESS + API_GET_JPUSH_REGISTER_ID
        let params = ["userId": userId, "registrationId": jpushId]
        NetworkEngine.get(url, parameters: params) { (result) in
            if result.isSuccess {
                ZZPrint("更新极光推送id成功: \(jpushId)")
                compeleteHandler?(true, result.message)
            } else {
                compeleteHandler?(false, result.message)
            }
        }
    }
    
    
    class func getImageCode(_ compeleteHandler: ((UIImage?, String?, String) -> ())?) {
        let url = SERVICE_BASE_ADDRESS + API_GET_IMAGE
        NetworkEngine.get(url, parameters: nil) { (result) in
            if result.isSuccess {
                guard
                    let dict = result.sourceDict?["data"] as? [String: AnyObject],
                    let imageStr = dict["imageInfo"] as? String,
                    let sessionId = dict["sessionId"] as? String,
                    let imageData = Data(base64Encoded: imageStr, options:.ignoreUnknownCharacters),
                    let image = UIImage(data: imageData)
                    else
                {
                    compeleteHandler?(nil, nil, "获取图片验证码失败")
                    return
                }
               
                compeleteHandler?(image, sessionId, result.message)

            } else {
                compeleteHandler?(nil, nil, result.message)
            }
        }
        
        
    }
}
