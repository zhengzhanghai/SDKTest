//
//  NCTableListViewController.swift
//  WashingMachine
//
//  Created by zzh on 2017/6/20.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

import UIKit

class NCTableListViewController: BaseViewController {
    
    var tableView: UITableView!
    var dataSource: [AnyObject] = [AnyObject]()
    var loadPage = 1
    var loadSize = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        makeTabele()
    }
    
    fileprivate func makeTabele() {
        tableView = UITableView(frame: CGRect.zero,
                                style: UITableView.Style.plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 240
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 30))
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        
        tableView.nc_addRefreshHeader { [weak self] in
            self?.pullDownRefresh()
        }
        tableView.nc_addLoadMoreFooter { [weak self] in
            self?.pullUpMore()
        }
    }
    
    /// 下拉刷新
    func pullDownRefresh() {
        loadPage = 1
    }
    
    /// 上拉加载, 如果不采用DataSource存数据，请重写覆盖此方法
    func pullUpMore() {
        if dataSource.count == 0 {
            loadPage = 1
        } else {
            loadPage += 1
        }
    }
    
    /// 清空数据及tableview
    func resetListAndTableView() {
        self.loadPage = 1
        self.dataSource.removeAll()
        self.tableView.reloadData()
    }
    
    func dealWithDataAndRefreshTable(_ loadWay: NCNetworkLoadWay, _ list: [AnyObject], _ isRefreshTable: Bool = true) {
        if loadWay == .normal || loadWay == .refresh {
            dataSource = list
        } else {
            for obj in list {
                dataSource.append(obj)
            }
        }
        if list.count < loadSize {
            tableView.nc_endRefreshingWithNoMoreData()
        } else {
            tableView.nc_resetNotMoreData()
        }
        if isRefreshTable {
            tableView.reloadData()
        }
    }
    
    func loadPageReduce() {
        if loadPage > 1 {
            loadPage -= 1
        }
    }
    
    func showWaitView(_ loadType: NCNetworkLoadWay, _ superView: UIView, _ message: String = "") {
        if loadType == .normal {
            showWaitingView(superView, message)
        }
    }
    
    func hiddenWaitingView(_ loadType: NCNetworkLoadWay) {
        if loadType == .normal {
            hiddenWaitingView()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

//MARK:  UITableViewDelegate, UITableViewDataSource ********
extension NCTableListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

