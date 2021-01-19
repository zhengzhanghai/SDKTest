//
//  EntrepreneurshipSchoolProjectPopularViewController.swift
//  WashingMachine
//
//  Created by Harious on 2018/2/5.
//  Copyright © 2018年 Eteclabeteclab. All rights reserved.
//

import UIKit

class EntrepreneurshipSchoolProjectPopularViewController: NCTableListViewController {

    var schoolId: String = ""
    var schoolName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = schoolName
        
        tableView.backgroundColor = EntrepreneurshipConfig.backgroundColor
        tableView.separatorStyle = .none
        TableViewCell.register(toTabeView: tableView)
        
        loadPorject(.normal)
        
        addNoticationObserver(self, #selector(refreshAboutLogin), LOGIN_SUCCESS_NOTIFICATION, nil)
        addNoticationObserver(self, #selector(refreshAboutLogin), LOGIN_OUT_NOTIFICATION, nil)
        addNoticationObserver(self, #selector(supportRefresh), entrepreneurshipSupportNoticationName, nil)
    }
    
    @objc fileprivate func refreshAboutLogin() {
        self.pullDownRefresh()
    }
    
    /// 在其他地方点赞后通知该页面点赞
    @objc fileprivate func supportRefresh(notication: Notification) {
        
        /// 先通过项目id找到在数据源中的下标，然后再更新数据源
        /// 再查找当前id所属cell是否在可视范围内，如果在可视范围内，更新cell，如果不在可视范围内可不用管
        
        guard let supportItem = (notication.userInfo as? [String: Any])?["support"] as? EntrepreneurshipSupportItem else { return }
        
        guard let index = self.findIndexInDataSource(projectId: supportItem.projectId) else { return }
        
        guard let project = self.dataSource[index] as? EntrepreneurshipPlan else { return }
        
        project.isGood = NSNumber(value: supportItem.isSupport)
        project.goodCount = NSNumber(value: supportItem.supportCount)
        
        guard let cell = self.findVisibleCell(indexPath: IndexPath(row: index, section: 0)) else { return }
        
        cell.supportBtn.isSelected = supportItem.isSupport
        cell.supportBtn.setTitle("\(supportItem.supportCount)", for: .normal)
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
        
        NetworkEngine.get(api_get_cy_school_project + schoolId,
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
                    models.append(EntrepreneurshipPlan.create(dict))
                }
                self.dealWithDataAndRefreshTable(loadWay, models)
            }
        }
    }
    
    /// 给项目点赞
    func projectSupport(_ projectId: String) {
        
        let parameters = ["userId" : getUserId(), "projectId" : projectId]
        
        NetworkEngine.get(api_get_cy_project_support(projectId: projectId), parameters: parameters) { (result) in
            
            guard result.isSuccessOr204 else {
                
                self.findVisibleCell(projectId: projectId)?.supportBtn.isEnabled = true
                showError(result.message, superView: self.view)
                
                return
            }
            
            func updateSupportCell(isSupport: Bool) {
                
                guard let index = self.findIndexInDataSource(projectId: projectId) else { return }
                
                guard let model = self.dataSource[index] as? EntrepreneurshipPlan else { return }
                
                model.goodCount = NSNumber(value: (model.goodCount ?? 0).intValue + (isSupport ? 1 : -1))
                if model.goodCount?.intValue ?? 0 < 0 {
                    model.goodCount = NSNumber(value: 0)
                }
                model.isGood = NSNumber(value: isSupport)
                
                guard let cell = self.findVisibleCell(indexPath: IndexPath(row: index, section: 0)) else { return }
                
                cell.supportBtn.isEnabled = true
                cell.supportBtn.isSelected = isSupport
                cell.supportBtn.setTitle(model.goodCount?.stringValue ?? "0", for: .normal)
                
                postNotication(entrepreneurshipSupportNoticationName,
                               nil,
                               ["support" : EntrepreneurshipSupportItem(projectId: model.id?.stringValue ?? "",
                                                                        isSupport: model.isGood?.boolValue ?? false,
                                                                        supportCount: model.goodCount?.intValue ?? 0)])
            }
            
            if result.isSuccess {
                
                /// 点赞成功
                showSucccess("点赞成功", superView: self.view)
                
                updateSupportCell(isSupport: true)
                
            } else if result.isError204 {
                
                /// 取消点赞
                showError(result.message, superView: self.view)
                
                updateSupportCell(isSupport: false)
            }
            
        }
        
    }
    
    func findIndexInDataSource(projectId: String) -> Int? {
        
        for (index , model) in (self.dataSource as! [EntrepreneurshipPlan]).enumerated() {
            
            guard let modelId = model.id?.stringValue else { continue }
            
            if projectId == modelId {
                return index
            }
        }
        
        return nil
    }
    
    func findVisibleCell(projectId: String) -> EntrepreneurshipPlanCell? {
        
        guard let index = findIndexInDataSource(projectId: projectId) else {
            return nil
        }
        
        return findVisibleCell(indexPath: IndexPath(row: index, section: 0))
    }
    
    func findVisibleCell(indexPath: IndexPath) -> EntrepreneurshipPlanCell? {
        
        guard let indexPaths = self.tableView.indexPathsForVisibleRows else { return nil }
        
        guard indexPaths.contains(indexPath) else { return nil }
        
        return self.tableView.cellForRow(at: indexPath) as? EntrepreneurshipPlanCell
    }

}


//MARK: --------------- tableView 代理相关 ------------------
extension EntrepreneurshipSchoolProjectPopularViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = TableViewCell.create(tableView, indexPath) as! TableViewCell
        
        cell.config(dataSource[indexPath.row] as! EntrepreneurshipPlan)
        
        cell.clickSupportClosures = {[unowned self] projectId in
            self.projectSupport(projectId)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard isLogin() else {
            LoginViewModel.pushLoginController(self)
            return
        }
        
        let entrepreneurship = dataSource[indexPath.row] as! EntrepreneurshipPlan
        guard let entrepreneurshipId = entrepreneurship.id?.stringValue else {
            return
        }
        
        let vc = EntrepreneurshipDetailsViewController()
        vc.entrepreneurshipId = entrepreneurshipId
        vc.entrepreneurshipPlan = entrepreneurship
        self.pushViewController(vc)
    }
}

extension EntrepreneurshipSchoolProjectPopularViewController {
    class TableViewCell: EntrepreneurshipPlanCell {
        
        override func createUI() {
            super.createUI()
            
            bgView.snp.updateConstraints { (make) in
                make.top.equalTo(12)
            }
        }

    }
}
