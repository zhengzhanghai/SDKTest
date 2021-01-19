//
//  AllOrderViewController.swift
//  WashingMachine
//
//  Created by 张丹丹 on 16/12/13.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

import UIKit
import MJRefresh

//   ----------------------    全部子控制器   ---------------------------------

class AllOrderViewController: BaseViewController {
    
    var tableView:UITableView?
    var dataArray:[OrderDetailsModel]?
    var loadPage: Int = 1
    var titleId:NSNumber?   //标题的id。根据id来更新url，获取不同界面的数据
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dataArray = [OrderDetailsModel]()
        setUpUi()
        self.loadOrderList(false)
        NotificationCenter.default.addObserver(self, selector: #selector(notificationRefresh), name: NSNotification.Name(rawValue: RefreshOrderListNotifation), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loginOutRefresh), name: NSNotification.Name(rawValue: LOGIN_OUT_NOTIFICATION), object: nil)
    }
    
    @objc fileprivate func loginOutRefresh() {
        if dataArray != nil {
            loadPage = 1
            dataArray?.removeAll()
            self.tableView?.reloadData()
        }
    }
    
    @objc fileprivate func notificationRefresh() {
        self.loadOrderList(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadOrderList(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    fileprivate func setUpUi() {
        tableView =  UITableView(frame: CGRect(x: 0, y: 0, width: BOUNDS_WIDTH, height: contentHeightNoTop-49), style: .plain)
        view.addSubview(tableView!)
        tableView?.separatorColor = UIColor.clear
        tableView!.delegate = self
        tableView!.dataSource = self
        tableView!.estimatedRowHeight = 145;
        //        让行高根据里面得内容来自动计算
        tableView!.rowHeight = UITableView.automaticDimension;
        //下拉刷新
        tableView?.nc_addRefreshHeader({ [weak self] in
            self?.loadPage = 1
            self?.loadOrderList(true)
        })
        //上拉加载
        tableView?.nc_addLoadMoreFooter({ [weak self] in
            if self?.dataArray == nil || self?.dataArray?.count == 0 {
                self?.loadPage = 1
            } else {
                self?.loadPage = (self?.loadPage ?? 1) + 1
            }
            self?.loadOrderList(true)
        })
    }
    
    //Mark: 网络请求相关
    fileprivate func loadOrderList(_ isRefresh: Bool) {
        if !isRefresh {
            self.showWaitingView(self.view)
        }
        OrderViewModel.loadOrderList(type: "\(titleId ?? 0)", page: "\(self.loadPage)", size: "20") { (orders, message, error) in
            if !isRefresh {
                self.hiddenWaitingView()
            }
            self.tableView?.nc_endRefresh()
            guard let orderList = orders else {
                // 如果加载出现异常，重置列表
                self.loadPage = 1
                self.dataArray?.removeAll()
                self.tableView?.reloadData()
                showError(message, superView: self.view)
                return
            }
            if self.loadPage == 1 {
                self.dataArray = orderList
            } else {
                for order in orderList {
                    self.dataArray?.append(order)
                }
            }
            self.tableView?.reloadData()
            if orderList.count < 20 {
                self.tableView?.nc_endRefreshingWithNoMoreData()
            } else {
                self.tableView?.nc_resetNotMoreData()
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension AllOrderViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return dataArray!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = OrderTableViewCell.create(tableView: tableView)
        cell.refreshUI(model: dataArray![indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let order = self.dataArray?[indexPath.row] else {
            return
        }
        guard let orderId = order.id?.stringValue else {
            return
        }
        if order.processPattern == .onewayCommunication {
            self.pushViewController(BlowerOrderDetailsViewController(orderId: orderId))
        } else if order.processPattern == .equipmentCoemmunication {
            OrderViewModel.pushOrderDetailsVC(dataArray?[indexPath.row].id, self)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.frame = CGRect(x: 0, y: 0, width: BOUNDS_WIDTH, height: 10)
        headerView.backgroundColor = BACKGROUNDCOLOR
        return headerView;
    }
}
