//
//  PublishEntrepreneurshipViewModel.swift
//  WashingMachine
//
//  Created by Harious on 2018/2/7.
//  Copyright © 2018年 Eteclabeteclab. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import Kingfisher

let entrepreneurshipProjectModifySuccessNoticationName = "entrepreneurshipProjectModifySuccessNoticationName"

extension PublishEntrepreneurshipProjectViewController {
    
    class PublishViewModel {
        
        weak var controller: PublishEntrepreneurshipProjectViewController?
        
        var contentView: ContentView? {
            return controller?.contentView
        }
        
        lazy var disposeBag: DisposeBag = {
            return DisposeBag()
        }()
        
        init(_ controller: PublishEntrepreneurshipProjectViewController?) {
            
            self.controller = controller
            
            rxObserver()
            
            if let view = self.contentView, let plan = controller?.plan  {
                
                self.downloadImage(plan.id)
                
                view.projectNameTF.text = plan.name
                view.publisherNameTF.text = plan.realName
                view.schoolTF.text = plan.schoolName
                view.teamNumberTF.text = plan.teamNumberStr
                view.despTextView.text = plan.content
                view.selectedTeamIndex = plan.teamNumber?.intValue
            }
        }
        
        fileprivate func downloadImage(_ planId: NSNumber?) {
            
            guard let planIdStr = planId?.stringValue else { return }
            
            controller?.showWaitingView(keyWindow)
            
            /// 先获取图片地址
            NetworkEngine.get(api_get_cy_images(projectId: planIdStr),
                              parameters: nil)
            { (result) in
                
                guard result.isSuccess else {
                    self.controller?.hiddenWaitingView()
                    return
                }
                
                guard let dicts = (result.dataObj as? [String: Any])?["data"] as? [[String: Any]], dicts.count > 0 else {
                    self.controller?.hiddenWaitingView()
                    return
                }
                
                var downImageIndex: Int = 0
                
                var urlStrs = [String]()
                for dict in dicts {
                    guard let urlStr = dict["url"] as? String else { continue }
                    urlStrs.append(urlStr)
                }
                
                guard urlStrs.count > 0 else {
                    self.controller?.hiddenWaitingView()
                    return
                }
                
                var imageDict = [String: UIImage]()
                
                /// 去下载图片
                for urlStr in urlStrs {
                    
                    guard let url = URL(string: urlStr) else { continue }
                    
                    KingfisherManager.shared.retrieveImage(with: url, options: nil, progressBlock: nil, completionHandler: { (image, error, cacheType, url) in
                        
                        downImageIndex += 1
                        
                        /// 将下载的图片保存到字典中，key为图片地址，UIImage为value
                        if let img = image, let imgUrlStr = url?.absoluteString {
                            imageDict[imgUrlStr] = img
                        }
                        
                        guard downImageIndex == urlStrs.count else { return }
                        
                        /// 将下载下来的图片按照原来图片地址的顺序放在数组中
                        var images = [UIImage]()
                        for urlStr in urlStrs {
                            if let image = imageDict[urlStr] {
                                images.append(image)
                            }
                        }
                        
                        DispatchQueue.main.async {
                            /// 将下载下来的图片更新到界面上
                            self.contentView?.images = images
                            self.contentView?.imageCollectionView.reloadData()
                            
                            /// 隐藏加载等待
                            self.controller?.hiddenWaitingView()
                        }
                        
                    })
                    
                }
                
            }
        }
        
        func rxObserver() {
            
            guard let view = contentView else { return }
            
            view.saveBtn.rx.tap.subscribe(onNext: {
                self.contentView?.endEditing(true)
                self.saveProject(isPublish: false)
            }).disposed(by: disposeBag)
            
            view.publishBtn.rx.tap.subscribe(onNext: { [unowned self] in
                self.contentView?.endEditing(true)
                self.saveProject(isPublish: true)
            }).disposed(by: disposeBag)
            
            view.schoolAssistBtn.rx.tap.subscribe(onNext: {
                ZZPrint(" ----- 点击学校选择")
            }).disposed(by: disposeBag)
            
            view.teamlAssistBtn.rx.tap.subscribe(onNext: {
                
                appRootView?.addSubview(view.chooseTeamView)
                view.chooseTeamView.snp.makeConstraints({ (make) in
                    make.edges.equalToSuperview()
                })
                view.chooseTeamView.layoutIfNeeded()
                view.chooseTeamView.showAndAnimation()
                ZZPrint("--- 点击团队人数")
            }).disposed(by: disposeBag)
        }
        
        //MARK: --------------- 发布网络请求 ------------------
        func saveProject(isPublish: Bool) {
            guard let view = contentView else { return }
            guard let vc = controller else { return }
            
            guard view.images.count > 0 else {
                showError("请选择图片", superView: vc.view)
                return
            }
            
            let projectName = view.projectNameTF.text
            let projectNameValidate = PublishValidate.projectName(projectName)
            guard projectNameValidate.0 else {
                showError(projectNameValidate.1, superView: vc.view)
                return
            }
            
            let realName = view.publisherNameTF.text
            let realNameValidate = PublishValidate.realName(realName)
            guard realNameValidate.0 else {
                showError(realNameValidate.1, superView: vc.view)
                return
            }
            
            guard let teamIndex = view.selectedTeamIndex else {
                showError("请选择团队人数", superView: vc.view)
                return
            }
            
            guard let schoolId = view.selectedId else {
                showError("请选择学校", superView: vc.view)
                return
            }
            
            let desp = view.despTextView.text
            let despValidate = PublishValidate.projectDesp(desp)
            guard despValidate.0 else {
                showError(despValidate.1, superView: vc.view)
                return
            }
            
            vc.showWaitingView(appdeleWindow() ?? view, "")
            
            /// saveType 只保存 1 ， 保存并发布 2
            var parameters: [String : Any] = ["name": projectName!,
                                              "realName": realName!,
                                              "userId": getUserId(),
                                              "schoolId": schoolId,
                                              "teamNumber": teamIndex,
                                              "content": desp!,
                                              "saveType": isPublish ? 2 : 1]
            /// 如果是编辑，需要传id参数，如果是新创建的则不需要
            if let planId = controller?.plan?.id?.intValue {
                parameters["id"] = planId
            }
            
            ZZPrint(parameters)
            
            var imageModels = [UploadFileModel]()
            for (index ,image) in view.images.enumerated() {
                
                let model = UploadFileModel()
                model.fileName = "chuangyexiangmu_image_\(index).jpg"
                
                if let imageData = image.pngData() {
                    model.fileData = imageData
                } else {
                    model.fileData = image.jpegData(compressionQuality: 1)
                }
                
                imageModels.append(model)
            }
            
            NetworkEngine.upload(api_post_cy_save_porject, parameters, imageModels, 60) { (result) in
                
                vc.hiddenWaitingView()
                
                guard result.isSuccess else {
                    showError(result.message, superView: view)
                    return
                }
                
                showSucccess(isPublish ? "发布成功" : "保存成功", superView: appdeleWindow() ?? view)
                
                /// 发送通知
                postNotication(entrepreneurshipProjectModifySuccessNoticationName, nil, nil)
                
                vc.navigationController?.popViewController(animated: true)
            }
            
        }
        

        
    }
}

extension PublishEntrepreneurshipProjectViewController.PublishViewModel {
    
}

extension PublishEntrepreneurshipProjectViewController {
    
    class PublishValidate {
        
        static func projectName(_ name: String?) -> (isSuccess: Bool, errorMessage: String) {
            
            guard let proName = name else {
                return (false, "请输入项目名称")
            }
            guard proName.count >= 1 else {
                return (false, "请输入项目名称")
            }
            guard proName.count <= 20 else {
                return (false, "项目名称最多20个字")
            }
            return (true, "")
        }
        
        static func realName(_ name: String?) -> (isSuccess: Bool, errorMessage: String) {
            
            guard let realNa = name else {
                return (false, "请输入您的真实姓名")
            }
            guard realNa.count >= 1 else {
                return (false, "请输入您的真实姓名")
            }
            guard realNa.count <= 30 else {
                return (false, "您的输入的姓名太长")
            }
            
            return (true, "")
        }
        
        static func projectDesp(_ desp: String?) -> (isSuccess: Bool, errorMessage: String) {
            
            guard let proDesp = desp else {
                return (false, "请输入项目介绍")
            }
            guard proDesp.count >= 1 else {
                return (false, "请输入项目介绍")
            }
            guard proDesp.count <= 2000 else {
                return (false, "项目介绍不能超过2000字")
            }
            
            return (true, "")
        }
    }
}
