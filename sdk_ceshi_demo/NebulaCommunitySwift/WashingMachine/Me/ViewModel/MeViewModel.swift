//
//  MeViewModel.swift
//  WashingMachine
//
//  Created by zzh on 2017/8/22.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

import UIKit

class MeViewModel: NSObject {
    
    /// 获取用户认证的学校信息
    ///
    /// - Parameters:
    ///   - userId: 用户id
    ///   - compeleteHandler: 回调闭包
    class func loadAuthenticationSchool(_ userId: String,
                                        _ compeleteHandler:((AuthenticationSchool?, String)->())?)
    {
        let url = API_GET_USER_SCHOOL_MESSAGE + userId
        NetworkEngine.get(url, parameters: nil) { (result) in
            if result.isSuccess {
                if let dict = result.dataObj as? [String: AnyObject] {
                    if let json = dict["data"] as? [String: AnyObject] {
                        if !json.isEmpty {
                            let school = AuthenticationSchool.create(json)
                            compeleteHandler?(school, result.message)
                            return
                        }
                    }
                }
            }
            compeleteHandler?(nil, result.message)
        }
    }
    
    /// 获取用户资料
    ///
    /// - Parameters:
    ///   - userId: 用户id
    ///   - completeHandler: 回调闭包
    class func loadUserInfo(_ userId: String, _ completeHandler: ((Bool, UserBaseInfoModel?, String)->())?) {
        let url = SERVICE_BASE_ADDRESS + API_GET_USER_PROFILE + "?userId=\(userId)"
        NetworkEngine.get(url, parameters: nil) { (result) in
            if result.isSuccess {
                if let data = result.dataObj as? [String: AnyObject] {
                    if let json = data["data"] as? [String: AnyObject] {
                        completeHandler?(true, UserBaseInfoModel.create(json), result.message)
                        return
                    }
                }
                completeHandler?(true, nil, result.message)
                return
            }
            completeHandler?(false, nil, result.message)
        }
    }
    
    /// 获取我的里面常见问题列表
    ///
    /// - Parameter compeleteHandler: 回调闭包
    class func loadCommonProblemList(_ compeleteHandler:(([QustionModel], String)->())?) {
        let url = SERVICE_BASE_ADDRESS + API_GET_APP_QUESTION
        let params = ["appkey": "0fa41edb357c4681bc86cdfb24952d8c"] as [String: AnyObject]
        NetworkEngine.get(url, parameters: params) { (result) in
            var models = [QustionModel]()
            if result.isSuccess {
                if let dict = result.dataObj as? [String: AnyObject] {
                    if let list = dict["data"] as? [[String: AnyObject]] {
                        for json in list {
                            models.append(QustionModel.create(json))
                        }
                    }
                }
            }
            compeleteHandler?(models, result.message)
        }
    }
    
    /// 获取我的里面消息列表
    ///
    /// - Parameters:
    ///   - userId: 用户id
    ///   - page: 分页页数
    ///   - size: 每页大小
    ///   - compeleteHandler: 回调闭包
    class func loadNoticeList(_ userId: String,
                              _ page: String,
                              _ size: String,
                              _ compeleteHandler:(([NoticeModel]?, String, Error?)->())?)
    {
        let url = SERVICE_BASE_ADDRESS + API_POST_USER_NOTICE
        let params = ["userId": userId,
                      "page": page,
                      "size": size]
        NetworkEngine.get(url, parameters: params) { (result) in
            guard (result.isSuccess || result.code == 204) else {
                compeleteHandler?(nil, result.message, result.error)
                return
            }
            var models: [NoticeModel] = [NoticeModel]()
            if let list = result.dataObj["data"] as? [[String: AnyObject]] {
                for json in list {
                    models.append(NoticeModel.create(json))
                }
            }
            compeleteHandler?(models, result.message, result.error)
        }
    }
    
    /// 修改用户资料
    ///
    /// - Parameters:
    ///   - userId: 用户id
    ///   - key: 要修改的资料key
    ///   - value: 用修改的资料value
    ///   - compeleteHandler: 回调闭包
    class func modifyUserInfo(_ userId: String,
                              _ key: String,
                              _ value: String,
                              _ compeleteHandler:((Bool, String)->())?)
    {
        let url = SERVICE_BASE_ADDRESS + API_POST_USER_MODIFY
        let params = ["userId": userId, "modifyName": key, "modifyValue": value] as [String: AnyObject]
        NetworkEngine.postJSON(url, parameters: params) { (result) in
            compeleteHandler?(result.isSuccess, result.message)
        }
    }
    
    /// 修改用户头像
    ///
    /// - Parameters:
    ///   - userId: 用户id
    ///   - image: 头像
    ///   - compeleteHander: 回调闭包
    class func modifyUserHeadPortrait(_ userId: String, _ image: UIImage, _ compeleteHander:((Bool, String?, String)->())?) {
        let url = SERVICE_BASE_ADDRESS + API_POST_USER_PORTRAIT + userId
        let fileModel  = UploadFileModel()
        if let data = image.pngData() {
            fileModel.fileName = "head.png"
            fileModel.fileData = data
        } else if let data = image.jpegData(compressionQuality: 0.5) {
            fileModel.fileName = "head.jpg"
            fileModel.fileData = data
        } else {
            compeleteHander?(false, "", "文件转换失败")
            return
        }
        NetworkEngine.upload(url, nil, [fileModel], 60, { (result) in
            if result.isSuccess {
                if let dict = result.dataObj as? [String: AnyObject] {
                    if let imageUrl = dict["image"] as? String {
                        compeleteHander?(true, imageUrl, result.message)
                        return
                    }
                }
                compeleteHander?(true, "", result.message)
            } else {
                compeleteHander?(false, "", result.message)
            }
        })
    }
}
