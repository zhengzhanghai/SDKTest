//
//  TaskViewController.swift
//  WashingMachine
//
//  Created by Moguilay on 2016/10/25.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

import UIKit
import StoreKit
import MJRefresh

class NewsViewController: NCTableListViewController {
    
    fileprivate var topNewsArray: [NewsModel] = [NewsModel]()
    fileprivate var bannerADSModel: SSPADSModel?
    fileprivate var ADSModels = [SSPADSModel]()
    fileprivate var tableDataSources = [AnyObject]()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadBannerADS()
        loadTableListADS()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NewsTablewCell.register(toTabeView: tableView)
        NewsADSCell.register(toTabeView: tableView)
        loadTopList()
        loadNewsList(.normal)
    }
    
    override func pullDownRefresh() {
        super.pullDownRefresh()
        loadTopList()
        loadNewsList(.refresh)
    }
    
    override func pullUpMore() {
        super.pullUpMore()
        loadNewsList(.more)
    }
    
    /// 混合新闻数据和广告数据,并刷新UI
    func mixDataSourceAndRefreshUI() {
        tableDataSources = dataSource
        for index in 0 ..< ADSModels.count {
            let newIndex = 2 + index * 5
            if tableDataSources.count < newIndex {
                tableDataSources.append(ADSModels[index])
            } else {
                tableDataSources.insert(ADSModels[index], at: newIndex)
            }
        }
        self.tableView.reloadData()
    }
    
    /// 创建或更新轮播图
    func makeOrUpdateTableHeader() {
        if topNewsArray.isEmpty {
            return
        }
        let cycleView = HZCycleView(frame: CGRect(x: 0, y: 0, width: BOUNDS_WIDTH, height: BOUNDS_WIDTH/2.0))
        cycleView.imageViewContentMode = .scaleAspectFill
        cycleView.pageControl.pageIndicatorTintColor = UIColor.white
        cycleView.pageControl.currentPageIndicatorTintColor = THEMECOLOR
        var imgUrls = [String]()
        if let adsImageUrl = bannerADSModel?.image {
            imgUrls.append(adsImageUrl)
        }
        for model in topNewsArray {
            imgUrls.append(model.logo ?? "")
        }
        cycleView.imageURLStringArr = imgUrls
        cycleView.didSelectedItem = { [unowned self] index in
            if self.topNewsArray.count > index || self.bannerADSModel != nil {
                if let adsModel = self.bannerADSModel {
                    if index == 0 {
                        ADSManager.onClick(adsModel: adsModel, vc: self, tapPoint: nil, adsSize: CGSize(width: BOUNDS_WIDTH * 2, height: BOUNDS_WIDTH/2 * 2))
                    } else {
                        NewsViewModel.pushNewDetails((self.topNewsArray[index - 1]), self)
                    }
                } else {
                    NewsViewModel.pushNewDetails((self.topNewsArray[index]), self)
                }
            }
        }
        self.tableView?.tableHeaderView = cycleView
    }
    
    fileprivate func loadTopList() {
        NewsViewModel.loadNewsList(getUserId(), "2", nil, 1, "\(loadPage)", "20") { (models, message) in
            if !(models?.isEmpty ?? true) {
                if let newsModels = models {
                    self.topNewsArray = newsModels
                    self.makeOrUpdateTableHeader()
                }
            }
        }
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
            
            self.dealWithDataAndRefreshTable(loadWay, newsModels, false)
            self.mixDataSourceAndRefreshUI()
          }
    }

}

//MARK: --------------- UITableViewDelegate、UITableViewDataSource ------------------
extension NewsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableDataSources.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = tableDataSources[indexPath.row]
        if let newModel = model as? NewsModel {
            let cell = NewsTablewCell.create(tableView, indexPath)
            (cell as? NewsTablewCell)?.config(newModel)
            return cell
        } else {
            let cell = NewsADSCell.create(tableView, indexPath)
            (cell as? NewsADSCell)?.config(model as! SSPADSModel)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let adsModel = tableDataSources[indexPath.row] as? SSPADSModel { // 广告
            ADSManager.reportAfterShowed(adsModel: adsModel)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let adsModel = tableDataSources[indexPath.row] as? SSPADSModel { // 广告
            ADSManager.onClick(adsModel: adsModel, vc: self, tapPoint: nil, adsSize: CGSize(width: 80, height: 80))
        } else { // 新闻
            NewsViewModel.pushNewDetails(tableDataSources[indexPath.row] as? NewsModel, self)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableDataSources[indexPath.row].isKind(of: NewsModel.self) ? 150 : 120
    }
}

extension NewsViewController {
    func loadBannerADS() {
        ADSManager.getADSList(ADSID: ADSManager.newsBannerID, pageKeywords: "社区", adsSize: CGSize(width: BOUNDS_WIDTH, height: BOUNDS_WIDTH/2)) { (adses) in
            if let model = adses.first {
                self.bannerADSModel = model
                self.makeOrUpdateTableHeader()
                ADSManager.reportAfterShowed(adsModel: model)
            }
        }
    }
    
    func loadTableListADS() {
        ADSManager.getADSList(ADSID: ADSManager.newsListID, pageKeywords: "社区", adsSize: CGSize(width: 80, height: 80)) { (adses) in
            self.ADSModels = adses
            self.mixDataSourceAndRefreshUI()
        }
    }
    
}


