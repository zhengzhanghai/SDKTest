//
//  EntrepreneurshipViewController.swift
//  WashingMachine
//
//  Created by Harious on 2018/1/12.
//  Copyright © 2018年 Eteclabeteclab. All rights reserved.
//

import UIKit

class EntrepreneurshipViewController: NCTableListViewController {
    
    var bannerModels : [NewsModel]?
    
    /// TableView 头视图
    lazy var tableHeader: TableViewHeader = {
        
        let header = TableViewHeader(frame: CGRect(x: 0, y: 0, width: BOUNDS_WIDTH, height: 100+BOUNDS_WIDTH/2))
        
        //TODO: ------ ➡️ ----- 点击了创业人气榜、创业资讯、我的创业项目 ------------------
        header.didSelectedItem = { [unowned self] itemType in
            switch itemType {
            case .popularityList:
                self.pushViewController(EntrepreneurshipPopularityViewController())
            case .news:
                self.pushViewController(EntrepreneurshipNewsViewController())
            case .myProject:
                if isLogin() {
                    self.pushViewController(EntrepreneurshipMyProjectViewController())
                } else {
                    LoginViewModel.pushLoginController(self)
                }
            }
            ZZPrint(itemType)
        }
        header.didSelectedImageBannerItem = { [unowned self] index in
            
            guard let news = self.bannerModels else { return }
            guard news.count > index else { return }
            
            NewsViewModel.pushNewDetails((news[index]), self)
        }
        return header
    }()
    /// TableView 组头视图
    lazy var tableSectionHeader: SectionHeader = {
        return SectionHeader(frame: CGRect(x: 0,
                                           y: 0,
                                           width: BOUNDS_WIDTH,
                                           height: tableView(tableView, heightForHeaderInSection: 0)))
    }()
    
    //MARK: --------------- viewDidLoad ------------------
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.backgroundColor = EntrepreneurshipConfig.backgroundColor
        EntrepreneurshipPlanCell.register(toTabeView: tableView)
        
        tableView.tableHeaderView = tableHeader
        tableView.mj_footer = nil
        
        loadBanner()
        loadRecommendPorject(.normal)
        
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
        
        loadBanner()
        loadRecommendPorject(.refresh)
    }
    override func pullUpMore() {
        super.pullUpMore()
        
        loadRecommendPorject(.more)
    }
    
    func loadRecommendPorject(_ loadWay: NCNetworkLoadWay) {
        
        self.showWaitView(loadWay, view)
        
        NetworkEngine.get(api_get_cy_recommend,
                          parameters: ["userId": getUserId(),
                                       "page": loadPage,
                                       "size": 5])
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
    
    /// 获取顶部轮播图
    fileprivate func loadBanner() {
        NewsViewModel.loadNewsList(getUserId(), "2", nil, 1, "\(loadPage)", "20") { (models, message) in
            
            guard let images = models, images.count > 0 else { return }
            
            self.bannerModels = models
            
            var imageUrls : [String] = [String]()
            for model in images {
                imageUrls.append(model.logo ?? "")
            }
            
            self.tableHeader.cycleView.imageURLStringArr = imageUrls
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
                
                /// 先通过项目id找到在数据源中的下标，然后再更新数据源
                /// 再查找当前id所属cell是否在可视范围内，如果在可视范围内，更新cell，如果不在可视范围内可不用管
                
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
extension EntrepreneurshipViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = EntrepreneurshipPlanCell.create(tableView, indexPath) as! EntrepreneurshipPlanCell
        
        cell.config(dataSource[indexPath.row] as! EntrepreneurshipPlan)
        
        cell.clickSupportClosures = {[unowned self] projectId in
            self.projectSupport(projectId)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableSectionHeader
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
        
        vc.refreshCount = { (projectId, count, itemType) in
            if let models = self.dataSource as? [EntrepreneurshipPlan] {
                for (index , plan) in models.enumerated() {
                    
                    guard let planId = plan.id?.stringValue else { continue }
                    
                    guard planId == projectId else { continue }
                    
                    if itemType == .support {
                        plan.goodCount = count
                    } else if itemType == .comment {
                        plan.commentCount = count
                    }
                    
                    let indexP = IndexPath(row: index, section: 0)
                    guard self.tableView.cellForRow(at: indexP) != nil else { return }
                    self.tableView.reloadRows(at: [indexP], with: .none)
                    
                    break
                }
            }
        }
        self.pushViewController(vc)
    }
}

//MARK: --------------- TableViewHeader ------------------
extension EntrepreneurshipViewController {
    
    class TableViewHeader: UIView {
        
        var didSelectedItem: ((ItemType)->())?
        var didSelectedImageBannerItem: ((Int)->())?
        
        lazy var cycleView: HZCycleView = {
            let cyView = HZCycleView(frame: CGRect(x: 0, y: 0, width: BOUNDS_WIDTH, height: BOUNDS_WIDTH/2))
            cyView.imageViewContentMode = .scaleAspectFill
            
            cyView.didSelectedItem = { [unowned self] index in
                
                ZZPrint("index  \(index)")
                self.didSelectedImageBannerItem?(index)
            }
            return cyView
        }()
        
//        let titles = ["创业人气榜", "创业资讯", "我的创业项目"]
//        let images = [#imageLiteral(resourceName: "cy_popular"), #imageLiteral(resourceName: "cy_news"), #imageLiteral(resourceName: "cy_myproject")]
        
        let titles = ["创业人气榜", "我的创业项目"]
        let images = [#imageLiteral(resourceName: "cy_popular"), #imageLiteral(resourceName: "cy_myproject")]
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            backgroundColor = UIColor.white
            
            addSubview(cycleView)
            addSubview(itemBGview)
            addSubview(sepline)
            
            sepline.snp.makeConstraints { (make) in
                make.left.bottom.right.equalToSuperview()
                make.height.equalTo(5)
            }
            itemBGview.snp.makeConstraints { (make) in
                make.top.equalTo(self.cycleView.snp.bottom)
                make.left.right.equalToSuperview()
                make.bottom.equalTo(self.sepline.snp.top)
            }
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        lazy var itemBGview: UIView = {
            let view = UIView()
            
            for (index, title) in titles.enumerated() {
                let btn = UIButton(type: .custom)
                btn.tag = index
                btn.setTitle(title, for: .normal)
                btn.setImage(images[index], for: .normal)
                btn.setTitleColor(UIColor_0x(0x333333), for: .normal)
                btn.titleLabel?.font = font_PingFangSC_Regular(12)
                btn.addTarget(self, action: #selector(clickItem(_:)), for: .touchUpInside)
                view.addSubview(btn)
                btn.snp.makeConstraints({ (make) in
                    make.centerY.equalToSuperview()
                    make.centerX.equalTo(BOUNDS_WIDTH/CGFloat(2*titles.count)*CGFloat(1+2*index))
                    make.height.equalTo(70)
                    make.width.equalTo(80)
                })
                
                btn.layout(forEdgeInsetsStyle: .up, imageTitleSpace: 3)
            }
            
            return view
        }()
        
        lazy var sepline: UIView = {
            let view = UIView()
            view.backgroundColor = UIColor_0x(0xf3f3f3)
            return view
        }()
        
        //TODO: ------ ➡️ ----- 点击了item ------------------
        @objc fileprivate func clickItem(_ btn: UIButton) {
            if btn.tag == 0 {
                didSelectedItem?(.popularityList)
            } else if btn.tag == 1 {
                didSelectedItem?(.myProject)
            }
            
        }
        
    }
}

extension EntrepreneurshipViewController.TableViewHeader {
    
    enum ItemType: Int {
        case popularityList
        case news
        case myProject
    }
}

//MARK: --------------- SectionHeader ------------------
extension EntrepreneurshipViewController {
    
    class SectionHeader: UIView {
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            backgroundColor = UIColor.white
            
            addSubview(titleLabel)
            addSubview(cirViewLeft)
            addSubview(cirViewRight)
            
            titleLabel.snp.makeConstraints { (make) in
                make.centerX.centerY.equalToSuperview()
            }
            cirViewLeft.snp.makeConstraints { (make) in
                make.right.equalTo(self.titleLabel.snp.left).offset(-11)
                make.centerY.equalTo(self.titleLabel)
                make.width.height.equalTo(6)
            }
            cirViewRight.snp.makeConstraints { (make) in
                make.left.equalTo(self.titleLabel.snp.right).offset(11)
                make.centerY.equalTo(self.titleLabel)
                make.width.height.equalTo(self.cirViewLeft)
            }
        }
        
        lazy var titleLabel: UILabel = {
            let label = UILabel()
            label.font = font_PingFangSC_Medium(14)
            label.textColor = UIColor_0x(0x333333)
            label.text = "推荐创业计划书"
            return label
        }()
        lazy var cirViewLeft: CircleView = {
            return CircleView()
        }()
        lazy var cirViewRight: CircleView = {
            return CircleView()
        }()
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}

extension EntrepreneurshipViewController.SectionHeader {
    class CircleView: UIView {
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            self.layer.cornerRadius = 3
            self.layer.borderColor = UIColor_0x(0x333333).cgColor
            self.layer.borderWidth = 1
            self.clipsToBounds = true
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}
