//
//  WasherOrderDetailsViewController.swift
//  WashingMachine
//
//  Created by zzh on 2017/7/25.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

import UIKit

class WasherOrderDetailsViewController: BaseViewController {
    
    fileprivate var contentView: WasherOrderDetailsContentView?
    fileprivate var orderId: String!
    fileprivate var orderModel: OrderDetailsModel!
    
    convenience init(orderId: String) {
        self.init()
        self.orderId = orderId
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "订单详情"
        view.backgroundColor = BACKGROUNDCOLOR
        makeUI()
    }
    
    private func makeUI() {
        contentView?.removeFromSuperview()
        contentView = WasherOrderDetailsContentView.init(CGRect(x: 0, y: 0, width: BOUNDS_WIDTH, height: contentHeightNoTop), 2, 2)
        contentView?.bottomBtnActionClourse = { action in
            switch action {
            case .cancel: ZZPrint("取消")
            case .cancelOrder: ZZPrint("取消订单")
            case .backHome: ZZPrint("回到首页")
            case .startWork: ZZPrint("启动")
            case .pay: ZZPrint("去支付")
            case .applyRefund: ZZPrint("申请退款")
            }
        }
        view.addSubview(contentView!);
    }
    
    //获取订单详情
    func loadOrderDetails(_ isPayRefresh: Bool = false) {
        showWaitingView(keyWindow)
        OrderViewModel.inquiryOrder(self.orderId) { (model, message, error) in
            self.hiddenWaitingView()
            if let orModel = model {
                self.orderModel = orModel
                
                
            } else {
                let alertVC = UIAlertController(title: message, message: "", preferredStyle: UIAlertController.Style.alert)
                let sureAction = UIAlertAction(title: "确定", style: UIAlertAction.Style.default, handler: nil)
                alertVC.addAction(sureAction)
                self.present(alertVC, animated: true, completion: nil)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
