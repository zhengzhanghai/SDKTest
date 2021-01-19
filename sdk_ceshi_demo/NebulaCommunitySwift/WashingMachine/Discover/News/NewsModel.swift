//
//  NewsModel.swift
//  WashingMachine
//
//  Created by zzh on 16/11/21.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

import UIKit

class NewsModel: ZZHModel {
    var status: NSNumber?
    var sort: NSNumber?
    var createBy: String?
    var id: NSNumber?
    var content: String?
    var title: String?
    var type: NSNumber?
    var logo: String?
    var createTime: NSNumber?
    var isCollection: NSNumber?
    var isGood: NSNumber?
    var goodCount: NSNumber?
    var desp: String?
    var commentCount: NSNumber?
    var collectionCount: NSNumber?
    var tag: String?  /// 标签
    
    /// 是否点赞
    var isSupport: Bool {
        return isCollection?.boolValue ?? false
    }
    /// 评论数量
    var commentCountStr: String {
        return commentCount?.stringValue ?? "0"
    }
    /// 点赞数量
    var collectionCountStr: String {
        return collectionCount?.stringValue ?? "0"
    }
    /// 标签（如果是nil或者"", 返回默认的“生活”）
    var tagStr: String {
        
        guard let str = tag, str != "" else {
            return "生活"
        }
        
        return str
    }
}
