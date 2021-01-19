//
//  OrderHistoryViewController.swift
//  WashingMachine
//
//  Created by Harious on 2018/1/12.
//  Copyright © 2018年 Eteclabeteclab. All rights reserved.
//

import UIKit


class OrderHistoryViewController: NCTableListViewController {
    
    var scrollMoveDirectionClourse:((HomeViewController.MenuDirection)->())?
    
    //MARK: --------------- viewDidLoad ------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadSize = 10
        self.view.backgroundColor = BACKGROUNDCOLOR
        self.tableView.backgroundColor = BACKGROUNDCOLOR
        self.tableView.separatorStyle = .none
        self.tableView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        OrderHistoryStatusCell.register(toTabeView: tableView)
        OrderHistoryCodeCell.register(toTabeView: tableView)
        
        // 后台进入前台的通知
        addNoticationObserver(self, #selector(applicationDidBecomeActive),UIApplication.didBecomeActiveNotification, nil)
        
    }
    
    //TODO: ------ ➡️ ----- 从后台进入前台会调用 ------------------
    @objc func applicationDidBecomeActive() {
        ZZPrint("从后台进入前台, 调用了\(NSStringFromClass(self.classForCoder)) 中的方法")
        self.loadPage = 1
        self.loadOrderList(.refresh)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isLogin() {
            self.loadOrderList(isFirstViewWillAppear ? .normal : .refresh)
        } else {
            self.loadPage = 1
            self.dataSource.removeAll()
            self.tableView.reloadData()
        }
    }
    
    override func pullUpMore() {
        super.pullUpMore()
        self.loadOrderList(.more)
    }
    
    override func pullDownRefresh() {
        super.pullDownRefresh()
        self.loadOrderList(.refresh)
    }
    
    //MARK: --------------- 获取订单列表 ------------------
    fileprivate func loadOrderList(_ loadWay: NCNetworkLoadWay = .normal) {
        showWaitView(loadWay, self.view)
        OrderViewModel.loadOrderList(type: "0", page: "\(loadPage)", size: "\(loadSize)") { (orders, message, error) in
            self.hiddenWaitingView(loadWay)
            self.tableView.nc_endRefresh()
            
            guard let orderList = orders else {
                // 如果加载出现异常，重置列表
                self.loadPageReduce()  // 失败的话loadPage执行减操作
                showError(message, superView: self.view)
                return
            }
            
            self.dealWithDataAndRefreshTable(loadWay, orderList)
        }
        
    }

}

//MARK: --------------- UITableViewDatasource/UITableViewDelegate ------------------
extension OrderHistoryViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return OrderHistoryCellFactory.create(tableView,
                                              indexPath ,
                                              self.dataSource[indexPath.row] as! OrderDetailsModel)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let order = (self.dataSource[indexPath.row] as? OrderDetailsModel) else {
            return
        }
        guard let orderId = order.id else {
            return
        }
        if order.processPattern == .onewayCommunication {
            self.pushViewController(BlowerOrderDetailsViewController(orderId: orderId.stringValue))
        } else if order.processPattern == .equipmentCoemmunication {
            OrderViewModel.pushOrderDetailsVC(orderId, self)
        }
    }
}
