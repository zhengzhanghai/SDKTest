//
//  NCHelper.swift
//  WashingMachine
//
//  Created by zzh on 2017/9/18.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

import Foundation

let keyWindow = UIApplication.shared.keyWindow!

// MARK: - 获取用户ID， 当用户未登录，会返回 “”
/// 获取用户ID， 当用户未登录，会返回 “”
public func getUserId() -> String {
    let userModel = UserBaseInfoModel.readFromLocal()
    guard let userId = userModel.id else {
        return ""
    }
    guard userId.intValue != 0 else {
        return ""
    }
    return userId.stringValue
}

// MARK: - 获取用户手机号
/// 获取用户手机号（如果用户未登录或者没有手机号，返回"00000000000"）
public func getUserMobile() -> String {
    return UserBaseInfoModel.readFromLocal().mobile ?? "00000000000"
}

// MARK: - 获取token
/// 获取token（如果用户未登录，或者没有获取到token，返回“”）
public func getToken() -> String {
    let userModel = UserInfoModel.readFromLocal()
    if let token = userModel.token {
        return token
    }
    return ""
}

// MARK: - 判断用户是否登录
/// 判断用户是否登录
public func isLogin() -> Bool {
    return (getUserId() != "" && getUserId() != "0")
}

public func getUserSchoolId() -> String {
    return UserBaseInfoModel.readFromLocal().schoolId ?? ""
}

// MARK: - 判断用户登录状态是否改变
/// 判断用户登录状态是否改变
//public func isChangeOfLoginStatus(_ loginStatus: Bool) -> Bool {
//    if isLogin() == loginStatus {
//        return false
//    } else {
//        return true
//    }
//}

// MARK: - 是否是iOS11+
/// 是否是iOS11+
public var iOS_11_or_more: Bool {
    if #available(iOS 11.0, *) {
        return true
    }
    return false
}

// MARK: - 是否是iPhoneX
/// 是否是iPhoneX
public var is_iPhoneX: Bool {
    if let window = UIApplication.shared.windows.first {
        if #available(iOS 11.0, *) {
            return window.safeAreaInsets.bottom > 0
        }
    }
    return false
}

// MARK: - 设置keyWindow用户是否能操作
/// 设置keyWindow用户是否能操作
public func keyWindowUserInteractionEnabled(_ enabled: Bool) {
    (UIApplication.shared.delegate as? AppDelegate)?.window?.isUserInteractionEnabled = enabled
}


private let flagRemoveUserInfoVersion_2_3_0_key = "flagRemoveUserInfoVersion_2_3_0_key"

/// 用户2.3.0以后的版本，第一次进入，删除用户登录信息

public func removeUserInfoInVersion_2_3_0_orLaterIfNeed() {
    let userDefaults = UserDefaults.standard
    let flag = userDefaults.bool(forKey: flagRemoveUserInfoVersion_2_3_0_key)
    
    guard !flag else {
        return
    }
    
    /// 清空全局及沙河的学校认证信息
    AuthSchool.clear()
    
    /// 清除服务器中与用户id绑定的极光设备关联信息
    LoginViewModel.updateJPushRegister(getUserId(), jpushId: "0", nil)
    UserInfoModel.deleteLocal()
    UserBaseInfoModel.deleteLocal()
    UserBalanceManager.share.reSet()
    postNotication(LOGIN_OUT_NOTIFICATION, nil, nil)
    
    userDefaults.set(true, forKey: flagRemoveUserInfoVersion_2_3_0_key)
    userDefaults.synchronize()
}

