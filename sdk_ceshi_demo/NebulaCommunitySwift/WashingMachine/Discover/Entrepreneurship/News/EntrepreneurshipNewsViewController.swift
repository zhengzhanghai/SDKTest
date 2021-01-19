//
//  EntrepreneurshipNewsViewController.swift
//  WashingMachine
//
//  Created by Harious on 2018/2/5.
//  Copyright © 2018年 Eteclabeteclab. All rights reserved.
//

import UIKit

class EntrepreneurshipNewsViewController: NCTableListViewController {

    fileprivate var topNewsArray: [NewsModel] = [NewsModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "创业资讯"
        NewsTablewCell.register(toTabeView: tableView)
        loadNewsList(.normal)
    }
    
    override func pullDownRefresh() {
        super.pullDownRefresh()
        loadNewsList(.refresh)
    }
    
    override func pullUpMore() {
        super.pullUpMore()
        loadNewsList(.more)
    }
    
    fileprivate func loadNewsList(_ loadWay: NCNetworkLoadWay) {
        showWaitView(loadWay, self.view)
        NewsViewModel.loadNewsList(getUserId() , "1", nil, 1, "\(loadPage)", "\(loadSize)") { (models, message) in
            self.hiddenWaitingView(loadWay)
            self.tableView.nc_endRefresh()
            
            guard let newsModels = models else {
                self.loadPageReduce()
                return
            }
            
            self.dealWithDataAndRefreshTable(loadWay, newsModels)
        }
    }

}

//MARK: --------------- UITableViewDelegate、UITableViewDataSource ------------------
extension EntrepreneurshipNewsViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = NewsTablewCell.create(tableView, indexPath)
        (cell as? NewsTablewCell)?.config(dataSource[indexPath.row] as! NewsModel)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NewsViewModel.pushNewDetails(dataSource[indexPath.row] as? NewsModel, self)
    }
}
