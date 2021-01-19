//
//  NoticeCenterViewController.swift
//  WashingMachine
//
//  Created by 张丹丹 on 16/11/2.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

import UIKit
import MJRefresh

class NoticeCenterViewController: BaseTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationItem.title = "消息盒子"
        self.configPullDownRefreshHeader()
        self.configPullUpLoadMoreFooter()
        self.cancelTableViewSeparatorLine()
        self.loadNoticeList(.normal)
        tableView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
    }
    
    override func pullDownRefresh() {
        super.pullDownRefresh()
        self.loadNoticeList(.refresh)
    }
    
    override func pullUpLoadMore() {
        super.pullUpLoadMore()
        self.loadNoticeList(.more)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:NoticeCell = NoticeCell.createCell(tableView: tableView, indexPath: indexPath, isLast: (indexPath.row == self.dataSource.count-1))
        if let model = self.dataSource[indexPath.row] as? NoticeModel {
            cell.makeNoticeCellWithModel(model,indexPath: indexPath)
        }
        return cell
    }
    
    fileprivate func loadNoticeList(_ loadWay: NCNetworkLoadWay) {
        self.tableShowLoadingView(loadWay, self.view)
        MeViewModel.loadNoticeList(getUserId(), "\(loadPage)", "\(pageSize)") { (models, message, error) in
            self.tableHiddenLoadingView(loadWay)
            self.endRefreshOrLoadMore()
            guard let notices = models else {
                self.clearAllDataAndRefreshTableView()
                showError(message, superView: self.view)
                return
            }
            self.dealWithListDataAndRefresh(loadWay, notices)
        }
    }
}
