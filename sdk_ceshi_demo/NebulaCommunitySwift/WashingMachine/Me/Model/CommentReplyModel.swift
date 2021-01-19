//
//  CommentReplyModel.swift
//  WashingMachine
//
//  Created by zzh on 2017/6/19.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

import UIKit

class CommentReplyModel: ZZHModel {
    var id: NSNumber?
    var sendId: NSNumber?
    var receiveId: NSNumber?
    var createTime: NSNumber?
    var goodCount: NSNumber?
    var replyCount: NSNumber?
    var parentId: NSNumber?
    var sendPortrait: String?
    var sendAccountName: String?
    var schoolName: String?
    var receivePortrait: String?
    var receiveAccountName: String?
    var content: String?
    
    var images: [String: AnyObject]?
    var replys: [String: AnyObject]?
}
