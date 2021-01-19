//
//  CommentModel.swift
//  WashingMachine
//
//  Created by zzh on 2017/6/19.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

import UIKit

class CommentModel: ZZHModel {
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
    var isGood: NSNumber?
    
    var images: [[String: AnyObject]]?
    var replys: [[String: AnyObject]]?
    
    var imageModels: [CommentImageModel]?
    var replyModels: [CommentReplyModel]?
    
    var cellContentHeight: CGFloat = 0
    var cellImageHeight: CGFloat = 0
    var cellReplyHeight: CGFloat = 0
    var cellReplyItemHeights: [CGFloat] = [CGFloat]()
    var cellHeight: CGFloat = 0
    
    class func cre(_ dict: [String: Any]?) -> Self {
        let model = self.create(dict)
        if let imgs = model.images {
            if imgs.count > 0 {
                var imas = [CommentImageModel]()
                for i in 0 ..< imgs.count {
                    imas.append(CommentImageModel.create(imgs[i]))
                }
                model.imageModels = imas
            }
        }
        if let res = model.replys {
            if res.count > 0 {
                var reps = [CommentReplyModel]()
                for i in 0 ..< res.count {
                    reps.append(CommentReplyModel.create(res[i]))
                }
                model.replyModels = reps
            }
        }
        return model
    }
    
    func calculateCellHeight() {
        self.cellContentHeight = content?.sizeWithFont(font_PingFangSC_Regular(15),
                                                       CGSize(width: BOUNDS_WIDTH-82, height: CGFloat.greatestFiniteMagnitude)).height ?? 0
        
        if let images = imageModels, images.count > 0 {
            let photoItemMargin: CGFloat = 3
            let photoItemSize: CGFloat = (BOUNDS_WIDTH-82-2*3)/3
            
            self.cellImageHeight = CGFloat(ceilf(Float(images.count)/3))*(photoItemSize+photoItemMargin)-photoItemMargin + 10
        } else {
            self.cellImageHeight = 0
        }
        
        if let replies = replyModels, replies.count > 0 {
            
            cellReplyHeight = 15
            
            for reply in replies {
                let itemHeight = "\(reply.sendAccountName ?? ""):\(reply.content ?? "")".sizeWithFont(font_PingFangSC_Regular(14), CGSize(width: BOUNDS_WIDTH-104, height: CGFloat.greatestFiniteMagnitude)).height
                cellReplyItemHeights.append(itemHeight)
                
                cellReplyHeight += itemHeight
            }
        
            if replies.count >= 3 {
                cellReplyHeight += 30
            } else {
                cellReplyHeight += 8
            }
        } else {
            self.cellReplyHeight = 0
        }
        
        cellHeight = cellContentHeight + cellReplyHeight + cellImageHeight + 115
    }
}









