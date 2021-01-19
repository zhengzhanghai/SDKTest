//
//  MessageBoardViewModel.swift
//  WashingMachine
//
//  Created by zzh on 2017/8/24.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

import UIKit

class MessageBoardViewModel: NSObject {
    
    /// 发布评论
    ///
    /// - Parameters:
    ///   - senderId: 发布人id
    ///   - content: 发布内容
    ///   - images: 发布的图片数组
    ///   - compeleteHandler: 回调闭包
    class func send(_ senderId: String,
                    _ content: String,
                    _ images: [UIImage]?,
                    _ schoolId: String,
                    _ compeleteHandler:((Bool, String)->())?)
    {
        let url = SERVICE_BASE_ADDRESS + API_POST_PUBLISH_COMMENT
        let pararms = ["sendId": senderId, "content": content, "schoolId": schoolId]
        var fileModels = [UploadFileModel]()
        if let arr = images {
            for (index, image) in arr.enumerated() {
                let fileModel  = UploadFileModel()
                if let data = image.pngData() {
                    fileModel.fileName = "file_image\(index).png"
                    fileModel.fileData = data
                } else if let data = image.jpegData(compressionQuality: 1) {
                    fileModel.fileName = "file_image\(index).jpg"
                    fileModel.fileData = data
                } else {
                    compeleteHandler?(false, "文件转换失败")
                    return
                }
                fileModels.append(fileModel)
            }
        }
        NetworkEngine.upload(url, pararms, fileModels, 60) { (result) in
            compeleteHandler?(result.isSuccess, result.message)
        }
    }
}
