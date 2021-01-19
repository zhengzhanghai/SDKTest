//
//  EntrepreneurshipUserComment.swift
//  WashingMachine
//
//  Created by Harious on 2018/2/26.
//  Copyright © 2018年 Eteclabeteclab. All rights reserved.
//

import UIKit

/// 用户对创业项目的评价
class EntrepreneurshipUserComment: ZZHModel {
    /// 评论id
    var id: NSNumber?
    /// 留言人id
    var sendId: NSNumber?
    /// 接收人id
    var receiveId: NSNumber?
    /// 评论时间
    var createTime: NSNumber?
    /// 点赞数
    var goodCount: NSNumber?
    /// 回复数
    var replyCount: NSNumber?
    /// 是否点赞
    var isGood: NSNumber?
    /// 留言人头像
    var sendPortrait: String?
    /// 留言人昵称
    var sendAccountName: String?
    /// 留言人学校名字
    var schoolName: String?
    /// 接收人头像
    var receivePortrait: String?
    /// 接收人昵称
    var receiveAccountName: String?
    /// 评论内容
    var content: String?
    /// 回复
    var replys: [[String: Any]]?
    
    
    private var _replyModels: [EntrepreneurshipUserComment]?
    
    /// 对留言的回复
    var replyModels: [EntrepreneurshipUserComment]? {
        
        if _replyModels == nil {
            
            guard let replyList = replys else { return nil }
            
            var models = [EntrepreneurshipUserComment]()
            
            for dict in replyList {
                let comment = EntrepreneurshipUserComment.create(dict)
                models.append(comment)
            }
            
            self._replyModels = models
        }
        
        return _replyModels
    }
    
    /// 只对关键点进行判断,只要关键点相同就认为相同
    public static func ==(lhs: EntrepreneurshipUserComment, rhs: EntrepreneurshipUserComment) -> Bool {
        return (lhs.id == rhs.id) && (lhs.replyModels?.count ?? 0) == (rhs.replyModels?.count ?? 0)
    }
}









