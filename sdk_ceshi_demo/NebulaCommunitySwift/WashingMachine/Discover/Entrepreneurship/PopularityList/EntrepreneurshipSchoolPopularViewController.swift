//
//  EntrepreneurshipSchoolPopularViewController.swift
//  WashingMachine
//
//  Created by Harious on 2018/2/3.
//  Copyright © 2018年 Eteclabeteclab. All rights reserved.
//

import UIKit

class EntrepreneurshipSchoolPopularViewController: NCTableListViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = EntrepreneurshipConfig.backgroundColor
        tableView.separatorStyle = .none
        EntrepreneurshopPlanSchoolCell.register(toTabeView: tableView)
        
        loadPorject(.normal)
        
        addNoticationObserver(self, #selector(refreshAboutLogin), LOGIN_SUCCESS_NOTIFICATION, nil)
        addNoticationObserver(self, #selector(refreshAboutLogin), LOGIN_OUT_NOTIFICATION, nil)
    }
    
    @objc fileprivate func refreshAboutLogin() {
        self.pullDownRefresh()
    }

    override func pullDownRefresh() {
        super.pullDownRefresh()
        
        loadPorject(.refresh)
    }
    override func pullUpMore() {
        super.pullUpMore()
        
        loadPorject(.more)
    }
    
    func loadPorject(_ loadWay: NCNetworkLoadWay) {
        
        self.showWaitView(loadWay, view)
        
        NetworkEngine.get(api_get_cy_popularity + "2",
                          parameters: ["page": loadPage,
                                       "size": loadSize,
                                       "userId": getUserId()])
        { (result) in
            
            self.hiddenWaitingView(loadWay)
            
            self.tableView.nc_endRefresh()
            
            guard result.isSuccess || result.code == 204 else {
                self.loadPageReduce()
                return
            }
            
            var models = [AnyObject]()
            if let list = (result.dataObj as? [String: AnyObject])?["data"] as? [[String: Any]] {
                for dict in list {
                    models.append(EntrepreneurshipPlanSchoolRanking.create(dict))
                }
                self.dealWithDataAndRefreshTable(loadWay, models)
            }
        }
    }
}


//MARK: --------------- tableView 代理相关 ------------------
extension EntrepreneurshipSchoolPopularViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return (EntrepreneurshopPlanSchoolCell.create(tableView, indexPath) as! EntrepreneurshopPlanSchoolCell)
            .config(dataSource[indexPath.row] as! EntrepreneurshipPlanSchoolRanking, indexPath: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let school = dataSource[indexPath.row] as! EntrepreneurshipPlanSchoolRanking
        guard let schoolId = school.schoolId?.stringValue, let schoolName = school.schoolName else {
            return
        }
        let vc = EntrepreneurshipSchoolProjectPopularViewController()
        vc.schoolId = schoolId
        vc.schoolName = schoolName
        self.pushViewController(vc)
    }
}
