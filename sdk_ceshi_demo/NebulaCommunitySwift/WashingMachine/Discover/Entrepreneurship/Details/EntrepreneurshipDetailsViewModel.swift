//
//  EntrepreneurshipDetailsViewModel.swift
//  WashingMachine
//
//  Created by Harious on 2018/2/12.
//  Copyright © 2018年 Eteclabeteclab. All rights reserved.
//

import UIKit

let entrepreneurshipDeleteSuccessNoticationName = "EntrepreneurshipDeleteSuccessNoticationName"
let entrepreneurshipSupportNoticationName = "entrepreneurshipSupportNoticationName"

struct EntrepreneurshipSupportItem {
    var projectId : String
    var isSupport : Bool
    var supportCount : Int
}

extension EntrepreneurshipDetailsViewController {
    
    class ViewModel {
        weak var vc: EntrepreneurshipDetailsViewController?
        
        init(_ vc: EntrepreneurshipDetailsViewController) {
            
            self.vc = vc
        }
    }
    
}


extension EntrepreneurshipDetailsViewController.ViewModel {
    
    /// 获取专家评论列表
    func loadExpertsComment(projectId: String, finish:(([EntrepreneurshipExpertComment]?)->())? = nil)  {
        
        let  parameters = ["page" : 1, "size" : 20]
        
        NetworkEngine.get(api_get_cy_expert_comment(projectId: projectId),
                          parameters: parameters)
        { (result) in
            if result.isSuccess || result.code == 204 {
                var comments = [EntrepreneurshipExpertComment]()
                
                if let dicts = (result.dataObj as? [String: Any])?["data"] as? [[String: Any]] {
                    for dict in dicts {
                        comments.append(EntrepreneurshipExpertComment.create(dict))
                    }
                }
                
                finish?(comments)
                
            } else {
                
                finish?(nil)
            }
        }
    }
    
    /// 获取用户评论列表
    func loadUserComment(projectId: String, page: Int = 1, size: Int = 20, finish:(([EntrepreneurshipUserComment]?)->())? = nil) {
        
        let  parameters = ["page" : page, "size" : size, "userId": getUserId()] as [String : Any]

        NetworkEngine.get(api_get_cy_user_comment(projectId: projectId),
                          parameters: parameters)
        { (result) in
            if result.isSuccess || result.code == 204 {
                var comments = [EntrepreneurshipUserComment]()
                
                if let dicts = (result.dataObj as? [String: Any])?["data"] as? [[String: Any]] {
                    for dict in dicts {
                        comments.append(EntrepreneurshipUserComment.create(dict))
                    }
                }
                
                finish?(comments)
                
            } else {
                
                finish?(nil)
            }
        }
    }
    
    /// 获取图片
    func loadImages(projectId: String, finish:(([EntrepreneurshipImage]?, [String]?)->())? = nil) {
        
        NetworkEngine.get(api_get_cy_images(projectId: projectId),
                          parameters: nil)
        { (result) in
            if result.isSuccess || result.code == 204 {
                
                var images = [EntrepreneurshipImage]()
                var urlStrs = [String]()
                
                if let dicts = (result.dataObj as? [String: Any])?["data"] as? [[String: Any]] {
                    for dict in dicts {
                        let model = EntrepreneurshipImage.create(dict)
                        images.append(model)
                        urlStrs.append(model.url ?? "")
                    }
                }
                
                finish?(images, urlStrs)
                
            } else {
                
                finish?(nil, nil)
            }
        }
    }
    
    /// 对创业项目评论
    func sendComment(projectId: String, content: String, finish:((Bool, String)->())?) {
        
        let parameters = ["sendId" : getUserId(), "projectId" : projectId, "content": content]
        
        NetworkEngine.postJSON(api_post_cy_sendComent(projectId: projectId), parameters: parameters)
        { (result) in
            finish?(result.isSuccess, result.message)
        }
    }
    
    /// 获取创业项目详情
    func loadProjectDetails(_ projectId: String, finish:((EntrepreneurshipPlan?, String)->())?) {
        
        let parameters = ["userId": getUserId()]
        
        NetworkEngine.get(api_get_cy_project_details(projectId: projectId), parameters: parameters) { (result) in
            
            guard result.isSuccess else {
                finish?(nil, result.message)
                return
            }
            
            guard let dict = (result.dataObj as? [String: Any])?["data"] as? [String: Any] else {
                finish?(nil, result.message)
                return
            }
            
            finish?(EntrepreneurshipPlan.create(dict), result.message)
        }
    }
    
    /// 给项目点赞
    func projectSupport(_ projectId: String, finish:((Bool, Bool, String)->())?) {
        
        let parameters = ["userId" : getUserId(), "projectId" : projectId]
        
        NetworkEngine.get(api_get_cy_project_support(projectId: projectId), parameters: parameters) { (result) in
            finish?(result.isSuccess, result.isError204, result.message)
        }
    }
    
    /// 给项目评论点赞
    func projectCommentSupport(_ projectId: String, commentId: String, finish:((Bool, Bool, String)->())?) {
        
        let parameters = ["userId" : getUserId(), "projectId" : projectId, "commentId": commentId]
        
        NetworkEngine.get(api_get_cy_project_comment_support(projectId: projectId, commentId: commentId), parameters: parameters) { (result) in
            finish?(result.isSuccess, result.isError204, result.message)
        }
    }
    
    /// 给用户评论回复
    func commentReply(sendId: String, receiveId: String, parentId: String, projectId: String, content: String, finish:((Bool, String)->())?) {
        let parameters = ["sendId" : getUserId(),"receiveId": receiveId, "parentId": parentId,  "projectId" : projectId, "content": content]
        
        NetworkEngine.postJSON(api_post_cy_comment_reply(projectId: projectId), parameters: parameters) { (result) in
            finish?(result.isSuccess, result.message)
        }
    }
    
    func delete(_ projectId: String) {
        
        vc?.showWaitingView(keyWindow)
        
        let parameters = ["userId" : getUserId()]
        NetworkEngine.delete(api_delete_cy_delete_porject(projectId: projectId), parameters: parameters) { (result) in
            
            self.vc?.hiddenWaitingView()
            
            if result.isSuccess {
                ZZPrint("删除成功")
                
                postNotication(entrepreneurshipDeleteSuccessNoticationName, nil, nil)
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.4, execute: {
                    showSucccess("删除成功", superView: keyWindow, afterHidden: 2)
                })
                
                self.vc?.navigationController?.popViewController(animated: true)
                
            } else {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.4, execute: {
                    showError(result.message, superView: self.vc!.view)
                })
            }
        }
    }
    
    
}
