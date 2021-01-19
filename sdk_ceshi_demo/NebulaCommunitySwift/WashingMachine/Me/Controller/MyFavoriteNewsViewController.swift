//
//  MyFavoriteNewsViewController.swift
//  WashingMachine
//
//  Created by zzh on 2017/8/25.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

import UIKit

class MyFavoriteNewsViewController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "我的收藏"
        RecommendNewsCell.register(toTabeView: self.tableView)
        configPullDownRefreshHeader()
        configPullUpLoadMoreFooter()
        loadFavoriteList(.normal)
        addNoticationObserver(self, #selector(notiRefresh), newsFavoriteAboutNotication, nil)
    }
    
    @objc func notiRefresh() {
        loadFavoriteList(.normal)
    }
    
    override func pullDownRefresh() {
        super.pullDownRefresh()
        self.loadFavoriteList(.refresh)
    }
    
    override func pullUpLoadMore() {
        super.pullUpLoadMore()
        self.loadFavoriteList(.more)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = RecommendNewsCell.create(tableView, indexPath)
        (cell as? RecommendNewsCell)?.config(dataSource[indexPath.row] as? NewsModel)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
        NewsViewModel.pushNewDetails(dataSource[indexPath.row] as? NewsModel, self)
    }
    
    fileprivate func loadFavoriteList(_ loadWay: NCNetworkLoadWay) {
        self.tableShowLoadingView(loadWay, self.view)
        NewsViewModel.loadFavoriteList(getUserId(), "\(loadPage)", "\(pageSize)") { (models, message) in
            self.endRefreshOrLoadMore()
            self.tableHiddenLoadingView(loadWay)
            guard let newModels = models else {
                self.loadPageAutoDecrease()
                return
            }
            self.dealWithListDataAndRefresh(loadWay, newModels)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
