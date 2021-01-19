//
//  RefundResonViewController.swift
//  WashingMachine
//
//  Created by 张丹丹 on 16/12/13.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

import UIKit

class RefundResonViewController: BaseViewController {
    
    //订单id
    var orderId: String?
    var isNeedImage: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "申请退款"
        self.view.backgroundColor = UIColor(rgb:0xffffff)
        
        
        let contentView = ApplyRefundContentView(viewController: self,
                                                 imageSction: HZIndexSction(min: isNeedImage ? 1 : 0, max: 5))
        { (reason, images) in
            self.showWaitingView(keyWindow, "提交申请中")
            let params = ["userId": getUserId(), "orderId": self.orderId ?? "", "memo": reason]
            var fileModels = [UploadFileModel]()
            for (index, image) in images.enumerated() {
                let fileModel  = UploadFileModel()
                if let data = image.pngData() {
                    fileModel.fileName = "file_image\(index).png"
                    fileModel.fileData = data
                } else if let data = image.jpegData(compressionQuality: 1) {
                    fileModel.fileName = "file_image\(index).jpg"
                    fileModel.fileData = data
                } else {
                    return
                }
                fileModels.append(fileModel)
            }
            NetworkEngine.upload(API_POST_ORDER_REFUND_IMAGE, params, fileModels, 60) { (result) in
                self.hiddenWaitingView()
                if result.isSuccess {
                    self.promptRefundMessage(true, message: "您的订单退款已成功受理，经审核通过后费用将返还到您原支付账户！")
                } else {
                    showError(result.message, superView: self.view, afterHidden: 2)
                }
            }
        }
        contentView.imageMinCount = isNeedImage ? 1 : 0
        self.view.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalToSuperview()
        }
    }
   
    
    fileprivate func promptRefundMessage(_ isSuccess: Bool, message: String) {
        let alertVC = UIAlertController(title: "", message: message, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "确定", style: UIAlertAction.Style.default) { (_) in
            if isSuccess {
                NotificationCenter.default.post(name: Notification.Name(rawValue: RefreshOrderListNotifation), object: nil)
                self.navigationController?.popViewController(animated: true)
            }
        }
        alertVC.addAction(action)
        self.present(alertVC, animated: true, completion: nil)
    }

}
