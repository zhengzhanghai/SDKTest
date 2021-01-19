//
//  UserBaseInfoModel.swift
//  Truck
//
//  Created by 张丹丹 on 16/9/27.
//  Copyright © 2016年 Eteclab. All rights reserved.
//

import UIKit

class UserBaseInfoModel: ZZHModel {
    
    var appkey: String?
    var vip: NSNumber?
    var mobile: String?
    var uuid: String?
    var osName: String?
    var collectCount: NSNumber?
    var nickName: String?
    var birthday: String?
    var email: String?
    var background: String?
    var status: NSNumber?
    var wallet: NSNumber?
    var attentionCount: NSNumber?
    var score: NSNumber?
    var sex: NSNumber?
    var udid: String?
    var id: NSNumber?
    var type: NSNumber?
    var portrait: String?
    var schoolId: String?
    
    var isLogin:NSNumber?
    var house:NSNumber?
    var vehicle:NSNumber?
    var arriage:NSNumber?
    var income:String?
    var job:String?
    var realName:String?
    var accountName:String?
    var registTime:String?
    var childbirth:NSNumber?
    var address:String?
    var name:String?
    var grade:String?
    var school:String?
    
    /// 从服务器获取用户资料, 在已登录状态下调用
    class func loadUserInfo(_ userId: String, _ completeHandler: ((UserBaseInfoModel?, String?)->())?) {
        let url = SERVICE_BASE_ADDRESS + API_GET_USER_PROFILE + "?userId=\(userId)"
        NetworkEngine.get(url, parameters: nil) { (result) in
            if result.isSuccess {
                if let data = result.dataObj as? [String: AnyObject] {
                    if let json = data["data"] as? [String: AnyObject] {
                        completeHandler?(UserBaseInfoModel.create(json), result.message)
                        return
                    }
                }
            }
            completeHandler?(nil, result.message)
        }
    }
}




