//
//  UserInfo.swift
//  Truck
//
//  Created by 张丹丹 on 16/9/27.
//  Copyright © 2016年 Eteclab. All rights reserved.
//

import UIKit

class UserInfoModel: ZZHModel {
    var token :String?
    var type :NSNumber?
    var userId :NSNumber?
    var code: NSNumber?
    var message: String?

    class func newToken() -> String {
        let userModel = UserInfoModel.readFromLocal()
        if userModel.token == nil || userModel.token == "" {
            return "0"
        }
        return userModel.token ?? "0"
    }
    
    class func newUserId() -> String {
        let userModel = UserInfoModel.readFromLocal()
        if userModel.userId == nil || (userModel.userId?.stringValue ?? "0") == "" {
            return "0"
        }
        return userModel.userId?.stringValue ?? "0"
    }

}
