//
//  NewsViewModel.swift
//  WashingMachine
//
//  Created by zzh on 2017/8/16.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

import UIKit

let newsFavoriteAboutNotication = "newsFavoriteAboutNotication"
let newsModifyAboutNotication = "newsModifyAboutNotication"

enum NewsPriseOrFavorite {
    case prise
    case favorite
}

class NewsViewModel: NSObject {
    /// 跳转到新闻详情页
    ///
    /// - Parameters:
    ///   - model: 新闻Model
    ///   - superController: 父控制器
    ///   - isRemoveSuperController: 跳转到新页面后是否从导航栏移除父控制器
    class func pushNewDetails(_ model: NewsModel?, _ superController: BaseViewController?, _ isRemoveSuperController: Bool = false) {
        if superController == nil {
            return
        }
        if let newsModel = model {
            let vc = NewsDetailsViewController()
            vc.newsModel = newsModel
            if isRemoveSuperController {
                vc.removeControllerCount = 1
            }
            superController!.pushViewController(vc)
        }
    }
    
    /// 获取新闻详情
    ///
    /// - Parameters:
    ///   - newId: 新闻id
    ///   - compeleHandler: 回调闭包
    class func loadNewsDetails(_ newId: String?, _ userId: String?, _ compeleHandler:((NewsModel?, String)->())?) {
        var url = API_GET_NEWS_DETAILS + (newId ?? "")
        if userId != nil && !(userId?.isEmpty ?? true) {
            url = url + "?userId=\(userId ?? "")"
        }
        NetworkEngine.get(url, parameters: nil) { (result) in
            if result.isSuccess {
                if let dictData = result.dataObj as? NSDictionary{
                    if let json = dictData.value(forKey: "data") as? [String: AnyObject] {
                        let newsModel = NewsModel.create(json)
                        compeleHandler?(newsModel, result.message)
                        return
                    }
                }
            }
            compeleHandler?(nil, result.message)
        }
    }
    
    class func loadRecommendList() {
        
    }
    
    /// 获取新闻列表
    ///
    /// - Parameters:
    ///   - type: 新闻类型  1列表   2置顶
    ///   - sort: 推荐时传2，否则传nil
    ///   - classify: 1.资讯 2。创业
    ///   - page: 页数
    ///   - size: 每页数量
    ///   - compeleHandler: 回调
    class func loadNewsList(_ userId: String,
                            _ type: String,
                            _ sort: String?,
                            _ classify: Int = 1,
                            _ page: String = "1",
                            _ size: String = "20",
                            _ compeleHandler:(([NewsModel]?, String)->())?)
    {
        let url = API_GET_NEWS_LIST
        var parameters = [String: Any]()
        parameters["type"] = type
        parameters["page"] = page
        parameters["size"] = size
        parameters["classify"] = classify
        if !userId.isEmpty && userId != "0"{
            parameters["userId"] = userId
        }
        if let sortStr = sort {
            parameters["sort"] = sortStr
        }
        NetworkEngine.get(url, parameters: parameters) { (result) in
            if let dict = result.dataObj as? [String: AnyObject] {
                if let array = dict["data"] as? [AnyObject] {
                    var arr = [NewsModel]()
                    for i in 0 ..< array.count {
                        if let json = array[i] as? [String: AnyObject] {
                            arr.append(NewsModel.create(json))
                        }
                    }
                    compeleHandler?(arr, result.message)
                    return
                }
            }
            compeleHandler?(nil, result.message)
        }
    }
    
    /// 获取新闻评论列表
    ///
    /// - Parameters:
    ///   - newId: 新闻id
    ///   - page: 页
    ///   - size: 每页数量
    ///   - compeleHandler: 回调闭包
    class func loadCommentList(_ newId: String,
                               _ userId: String,
                               _ page: String,
                               _ size: String,
                               _ compeleHandler:(([NewsComment]?, String)->())?) {
        let url = API_GET_NEWS_COMMENT_LIST
        let parameters: [String: Any] = ["newsId": newId,
                                         "userId": userId,
                                         "page": page,
                                         "size": size]
        NetworkEngine.get(url, parameters: parameters) { (result) in
            if let dict = result.dataObj as? [String: AnyObject] {
                if let array = dict["data"] as? [AnyObject] {
                    var arr = [NewsComment]()
                    for i in 0 ..< array.count {
                        if let json = array[i] as? [String: AnyObject] {
                            arr.append(NewsComment.create(json))
                        }
                    }
                    compeleHandler?(arr, result.message)
                    return
                }
            }
            compeleHandler?(nil, result.message)
        }
    }
    
    /// 对新闻发表评论
    ///
    /// - Parameters:
    ///   - newsId: 新闻id
    ///   - userId: 发表人id
    ///   - content: 发表内容
    ///   - compeleHandler: 回调闭包
    class func publishComment(_ newsId: String,
                              _ userId: String,
                              _ content: String,
                              _ compeleHandler:((Bool, String)->())?)
    {
        let url = API_POST_NEWS_COMMENT_PUBLISH
        var parameters = [String: Any]()
        parameters["newsId"] = newsId
        parameters["userId"] = userId
        parameters["content"] = content
        NetworkEngine.postJSON(url, parameters: parameters) { (result) in
            if result.isSuccess {
                compeleHandler?(true, result.message)
            } else {
                compeleHandler?(false, result.message)
            }
        }
    }
    
    /// 给评论点赞
    ///
    /// - Parameters:
    ///   - newsId: 评论id
    ///   - userId: 点赞人id
    ///   - compeleHandler: 回调闭包
    class func commentPrise(_ commentId: String,
                            _ userId: String,
                            _ compeleHandler:((Bool, Bool, String)->())?)
    {
        let url = API_GET_NEWS_COMMENT_PRAISE
        var parameters = [String: Any]()
        parameters["commentId"] = commentId
        parameters["userId"] = userId
        NetworkEngine.get(url, parameters: parameters) { (result) in
            compeleHandler?(result.isSuccess,result.isError204, result.message)
        }
    }
    
    ///  给新闻点赞或收藏
    ///
    /// - Parameters:
    ///   - newsId: 新闻id
    ///   - userId: 用户id
    ///   - type: 类型
    ///   - compeleHandler: 回调闭包
    class func priseOrFavorite(_ newsId: String,
                               _ userId: String,
                               _ type: NewsPriseOrFavorite,
                               _ compeleHandler:((Bool, NSNumber, NSNumber, String)->())?)
    {
        let url = API_GET_NEWS_PRAISE_FAVORITE
        var parameters = [String: Any]()
        parameters["newsId"] = newsId
        parameters["userId"] = userId
        switch type {
            case .prise:
                parameters["type"] = "2"
            case .favorite:
                parameters["type"] = "1"
        }
        NetworkEngine.get(url, parameters: parameters) { (result) in
            var isSure: NSNumber = NSNumber(value: 0)
            var count: NSNumber = NSNumber(value: 0)
            if result.isSuccess {
                if let sure = result.sourceDict?["is"] as? NSNumber {
                    isSure = sure
                }
                if let countNum = result.sourceDict?["count"] as? NSNumber {
                    count = countNum
                }
                compeleHandler?(true, isSure, count, result.message)
            } else {
                compeleHandler?(false, isSure, count, result.message)
            }
        }
    }
    
    /// 获取收藏列表
    ///
    /// - Parameters:
    ///   - userId: 用户id
    ///   - page: 分页页数
    ///   - size: 分页大小
    ///   - compeleteHander: 回调闭包
    class func loadFavoriteList(_ userId: String,
                                _ page: String,
                                _ size: String,
                                _ compeleteHander:(([NewsModel]?, String)->())?)
    {
        let url = API_GET_NEWS_FAVORITE_LIST + userId
        let params = ["page": page,
                      "size": size]
        NetworkEngine.get(url, parameters: params) { (result) in
            guard (result.isSuccess || result.code == 204) else {
                compeleteHander?(nil, result.message)
                return
            }
            var models = [NewsModel]()
            if let list = result.dataObj["data"] as? [[String: AnyObject]] {
                for json in list {
                    models.append(NewsModel.create(json))
                }
            }
            compeleteHander?(models, result.message)
        }
    }
    
    
}
