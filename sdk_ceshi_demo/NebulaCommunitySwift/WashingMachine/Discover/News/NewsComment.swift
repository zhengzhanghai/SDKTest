//
//  NewsComment.swift
//  WashingMachine
//
//  Created by zzh on 2017/8/17.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

import UIKit

class NewsComment: ZZHModel {
    var id: NSNumber?
    var newsId: NSNumber?
    var userId: NSNumber?
    var userAccountName: String?
    var userPortrait: String?
    var createTime: NSNumber?
    var content: String?
    var goodCount: NSNumber?
    var replyCount: NSNumber?
    var parentId: NSNumber?
    var isGood: NSNumber?
}
