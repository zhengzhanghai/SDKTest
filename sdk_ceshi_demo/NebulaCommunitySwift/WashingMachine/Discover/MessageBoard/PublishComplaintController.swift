//
//  PublishComplaintController.swift
//  WashingMachine
//
//  Created by zzh on 2017/6/14.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

import UIKit

let publishCommentSuccessNotifation = "publishCommentSuccessNotifation"

class PublishComplaintController: BaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    fileprivate var contentView: PublishComplaintContentView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        contentView.textView.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "吐个槽"
        createUI()
        configPublishBtn()
    }
    
    fileprivate func configPublishBtn() {
        let publishItem = UIBarButtonItem(title: "发布", style: .plain, target: self, action: #selector(clickPublish))
        publishItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : THEMECOLOR,
                                            NSAttributedString.Key.font : font_PingFangSC_Regular(15)], for: .normal)
        publishItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : THEMECOLOR,
                                            NSAttributedString.Key.font : font_PingFangSC_Regular(15)], for: .highlighted)
        self.navigationItem.rightBarButtonItem = publishItem
    }
    
    
    fileprivate func createUI() {
        contentView = PublishComplaintContentView(viewController: self,
                                                      frame: CGRect(x: 0, y: 0, width: BOUNDS_WIDTH, height: BOUNDS_HEIGHT)) ?? PublishComplaintContentView()
//        contentView.canSendClourse = { [weak self] canSend in
//
//        }
        view.addSubview(contentView)
    }
    
    @objc fileprivate func clickPublish() {
        let message = contentView.getPublishMessage()
        if message.0 == "" {
            showError("内容不能为空", superView: view, afterHidden: 2)
            windowUserEnabled(true)
            return
        }
        showWaitingView(nc_appdelegate?.window ?? self.view, "发送中")
        MessageBoardViewModel.send(getUserId(), message.0, message.1, getUserSchoolId()) { (isSuccess, message) in
            self.hiddenWaitingView()
            if isSuccess {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: publishCommentSuccessNotifation), object: nil)
                self.navigationController?.popViewController(animated: true)
            } else {
                showError(message, superView: self.view, afterHidden: 2)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
