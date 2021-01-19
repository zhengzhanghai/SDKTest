//
//  BaseTableViewController.swift
//  WashingMachine
//
//  Created by zzh on 2017/7/11.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

import UIKit
import MJRefresh

class BaseTableViewController: BaseViewController {
    
    /// 网络请求页数
    var loadPage:   Int = 1
    /// 网络请求每页数据量
    var pageSize:   Int = 20
    /// tableView
    var tableView:  UITableView!
    /// 便捷存储数据的数组，建议只有一类数据时使用
    var dataSource: [AnyObject] = [AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTable()
    }
    
    /// 初始化tableView
    private func configTable() {
        tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.backgroundColor = BACKGROUNDCOLOR
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 20))
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        view.addSubview(tableView)
    }
    
    /// 取消tableView分割线
    func cancelTableViewSeparatorLine() {
        tableView.separatorStyle = .none
    }
    
    /// 展示加载等待
    ///
    /// - Parameters:
    ///   - loadWay: 网络请求类型，= .normal才显示
    ///   - superView: 父视图
    ///   - message: 文字提示
    func tableShowLoadingView(_ loadWay: NCNetworkLoadWay, _ superView: UIView, _ message: String = "") {
        if loadWay == .normal {
            showWaitingView(superView, message)
        }
    }
    
    /// 隐藏加载等待
    ///
    /// - Parameter loadWay: 网络请求类型
    func tableHiddenLoadingView(_ loadWay: NCNetworkLoadWay) {
        if loadWay == .normal {
            hiddenWaitingView()
        }
    }
    
    /// 处理数据，并刷新tableView
    ///
    /// - Parameters:
    ///   - loadWay: 加载方式
    ///   - listData: 数据
    func dealWithListDataAndRefresh(_ loadWay: NCNetworkLoadWay, _ listData: [AnyObject]) {
        switch loadWay {
        case .normal, .refresh:
            dataSource = listData
        case .more:
            for data in listData {
                dataSource.append(data)
            }
        }
        if listData.count < pageSize {
            tableView.nc_endRefreshingWithNoMoreData()
        } else {
            tableView.nc_resetNotMoreData()
        }
        tableView.reloadData()
    }
    
    /// 清空数据并刷新tableView
    func clearAllDataAndRefreshTableView() {
        self.loadPage = 1
        dataSource.removeAll()
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /// 初始化下拉刷新
    func configPullDownRefreshHeader(_ action: (()->())? = nil) {
        tableView.nc_addRefreshHeader { [weak self] in
            if action != nil {
                action?()
            } else {
                self?.pullDownRefresh()
            }
        }
    }
    
    /// 初始化上拉加载控件
    func configPullUpLoadMoreFooter(_ action: (()->())? = nil) {
        tableView.nc_addLoadMoreFooter { [weak self] in
            if action != nil {
                action?()
            } else {
                self?.pullUpLoadMore()
            }
        }
    }
    
    /// 下拉刷新，子类需重写
    @objc func pullDownRefresh() {
        loadPage = 1
    }
    
    /// 上拉加载更多，子类需重写
    @objc func pullUpLoadMore() {
        loadPageAutoIncrement()
    }
    
    /// 分页页数自增
    func loadPageAutoIncrement() {
        if dataSource.count == 0 {
            loadPage = 1
        } else {
            loadPage += 1
        }
    }
    
    /// 分页页数自减
    func loadPageAutoDecrease() {
        if loadPage > 1 {
            loadPage -= 1
        }
    }
    
    /// 结束刷新或者加载更多
    func endRefreshOrLoadMore() {
        tableView.nc_endRefresh()
    }
}

//MARK:  ********* 上拉加载，下拉刷新相关
extension BaseTableViewController {
    /// 初始化下拉刷新控件

}

//MARK:  ********* UITableViewDelegate, UITableViewDataSource
extension BaseTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
