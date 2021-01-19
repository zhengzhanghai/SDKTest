//
//  EntrepreneurshipMyProjectViewController.swift
//  WashingMachine
//
//  Created by Harious on 2018/2/5.
//  Copyright © 2018年 Eteclabeteclab. All rights reserved.
//

import UIKit

/// 项目发布状态
enum EntrepreneurshipPlanExamineStatus: Int {
    case unpublished        = 1 // 未发布
    case waitAuditished     = 2 // 等待审核
    case notPass            = 3 // 审核未通过
    case passed             = 4 // 通过审核
}

class EntrepreneurshipMyProjectViewController: NCTableListViewController {
    
    var editingCellIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "我的创业项目"
        
        tableView.backgroundColor = EntrepreneurshipConfig.backgroundColor
        tableView.separatorStyle = .none
        TableViewCell.register(toTabeView: tableView)
        
        let item = UIBarButtonItem(title: "创建项目", style: .plain, target: self, action: #selector(clickNewProjectBtn(_:)))
        item.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor_0x(0x757575),
                                     NSAttributedString.Key.font : font_PingFangSC_Medium(12)],
                                    for: .normal)
        item.setTitleTextAttributes([NSAttributedString.Key.font : font_PingFangSC_Medium(12)], for: .highlighted)
        self.navigationItem.rightBarButtonItem = item
        
        loadMyPorject(.normal)
        
        addNoticationObserver(self, #selector(notifationRefresh), entrepreneurshipProjectModifySuccessNoticationName, nil)
        addNoticationObserver(self, #selector(notifationRefresh), entrepreneurshipDeleteSuccessNoticationName, nil)
        addNoticationObserver(self, #selector(supportRefresh), entrepreneurshipSupportNoticationName, nil)
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.configSwipeButtons()
    }
    
    fileprivate func configSwipeButtons() {
        
        guard let cellIndexPath = editingCellIndexPath else { return }
        guard let model = self.dataSource[cellIndexPath.row] as? EntrepreneurshipPlan else { return }
        
        /// 左滑是否展示编辑
        let isShowEdit: Bool = (model.publishStatus == .unpublished) || (model.publishStatus == .notPass)
        
        if iOS_11_or_more {
            /// 从cell子视图中找出左滑编辑视图，并自定义
            for view in self.tableView.subviews {
                
                ZZPrint(NSStringFromClass(view.classForCoder))
                
                guard (NSStringFromClass(view.classForCoder) as String) == "UISwipeActionPullView" else { continue }
                view.backgroundColor = EntrepreneurshipConfig.backgroundColor
                
                if view.subviews.count >= 1 {
                    if let button = view.subviews[0] as? UIButton {
                        button.backgroundColor = EntrepreneurshipConfig.backgroundColor
                        button.setTitle("", for: .normal)
                        button.setImage(isShowEdit ? #imageLiteral(resourceName: "edit_green") : #imageLiteral(resourceName: "recycle_bin"), for: .normal)
                        
                    }
                }
                
                if view.subviews.count >= 2 {
                    if let button = view.subviews[1] as? UIButton {
                        button.backgroundColor = EntrepreneurshipConfig.backgroundColor
                        button.setTitle("", for: .normal)
                        button.setImage(#imageLiteral(resourceName: "recycle_bin"), for: .normal)
                        
                        view.setNeedsLayout()
                    }
                }
            }
        } else {
            
            guard let cell = tableView.cellForRow(at: cellIndexPath) else { return }
            
            for view in cell.subviews {
                
                if (NSStringFromClass(view.classForCoder) as String) == "UITableViewCellDeleteConfirmationView" {
                    
                    
                    let isShowEdit = (model.publishStatus == .unpublished || model.publishStatus == .notPass)
                    
                    guard view.subviews.count >= 1 else { return }
                    
                    if let button = view.subviews[0] as? UIButton {
                        button.backgroundColor = EntrepreneurshipConfig.backgroundColor
                        button.setTitle("", for: .normal)
                        button.setImage(#imageLiteral(resourceName: "recycle_bin"), for: .normal)
                    }
                    
                    guard view.subviews.count >= 2 && isShowEdit else { return }
                    
                    if let button = view.subviews[1] as? UIButton {
                        button.backgroundColor = EntrepreneurshipConfig.backgroundColor
                        button.setTitle("", for: .normal)
                        button.setImage(#imageLiteral(resourceName: "edit_green"), for: .normal)
                        
                    }
                    
                    return
                }
            }
            
        }
        
    }

    
    @objc fileprivate func notifationRefresh() {
        self.tableView.mj_header.beginRefreshing()
    }
    
    @objc fileprivate func clickNewProjectBtn(_ btn: UIButton) {
        self.pushViewController(PublishEntrepreneurshipProjectViewController())
    }

    override func pullDownRefresh() {
        super.pullDownRefresh()
        
        loadMyPorject(.refresh)
    }
    override func pullUpMore() {
        super.pullUpMore()
        
        loadMyPorject(.more)
    }
    
    func loadMyPorject(_ loadWay: NCNetworkLoadWay) {
        
        self.showWaitView(loadWay, view)
        
        NetworkEngine.get(api_get_cy_my_project + getUserId(),
                          parameters: ["page": loadPage, "size": loadSize])
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
    
    func delete(_ plan: EntrepreneurshipPlan) {
        
        guard let planId = plan.id?.stringValue else { return }
        
        showWaitingView(keyWindow)
        
        let parameters = ["userId" : getUserId()]
        NetworkEngine.delete(api_delete_cy_delete_porject(projectId: planId), parameters: parameters) { (result) in
            
            self.hiddenWaitingView()
            
            if result.isSuccess {
                ZZPrint("删除成功")
                if var dataS = self.dataSource as? [EntrepreneurshipPlan] {
                    
                    for (i, item) in dataS.enumerated() {
                        if item.id == plan.id {
                            dataS.remove(at: i)
                        }
                    }
                    
                    self.tableView.beginUpdates()
                    self.dataSource = dataS
                    UIView.performWithoutAnimation {
                        self.tableView.reloadSections(NSIndexSet(index: 0) as IndexSet, with: .automatic)
                    }
                    self.tableView.endUpdates()
                }
                
            } else {
                showError(result.message, superView: self.view)
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
    
    func findVisibleCell(projectId: String) -> TableViewCell? {
        
        guard let index = findIndexInDataSource(projectId: projectId) else {
            return nil
        }
        
        return findVisibleCell(indexPath: IndexPath(row: index, section: 0))
    }
    
    func findVisibleCell(indexPath: IndexPath) -> TableViewCell? {
        
        guard let indexPaths = self.tableView.indexPathsForVisibleRows else { return nil }
        
        guard indexPaths.contains(indexPath) else { return nil }
        
        return self.tableView.cellForRow(at: indexPath) as? TableViewCell
    }

}

//MARK: --------------- tableView 代理相关 ------------------
extension EntrepreneurshipMyProjectViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = TableViewCell.create(tableView, indexPath) as! TableViewCell
        cell.config(dataSource[indexPath.row] as! EntrepreneurshipPlan )
        
        cell.clickSupportClosures = {[unowned self] projectId in
            self.projectSupport(projectId)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        
        print("willBeginEditingRowAt", indexPath.row)
        
        self.editingCellIndexPath = indexPath
        
        self.configSwipeButtons()
        view.setNeedsLayout()
    }
    
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        
        print("didEndEditingRowAt", indexPath!.row)
        
        self.editingCellIndexPath = nil
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        guard let model = self.dataSource[indexPath.row] as? EntrepreneurshipPlan else {
            return nil
        }
        
        let deleteAction = UITableViewRowAction(style: .normal, title: "删除") { (_, _) in
            
            self.tableView.setEditing(false, animated: true)
            
            /// 删除二次提示
            let confirmAlert = UIAlertController(title: "确定删除吗？", message: nil, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (_) in
                
            }
            let sureAction = UIAlertAction(title: "确认", style: .default) { (_) in
                self.delete(model)
            }
            confirmAlert.addAction(cancelAction)
            confirmAlert.addAction(sureAction)
            self.present(confirmAlert, animated: true, completion: nil)
        }
        
        if model.publishStatus == .unpublished || model.publishStatus == .notPass {
            /// 未发布和审核未通过，可以编辑和删除
            let editAction = UITableViewRowAction(style: .default, title: "编辑") { (_, _) in
                
                self.tableView.setEditing(false, animated: true)
                
                let vc = PublishEntrepreneurshipProjectViewController()
                vc.plan = model
                self.pushViewController(vc)
            }
            return [deleteAction , editAction]
        } else {
            /// 审核中和审核已通过的只能删除
            return [deleteAction]
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let entrepreneurship = dataSource[indexPath.row] as! EntrepreneurshipPlan
        guard let entrepreneurshipId = entrepreneurship.id?.stringValue else {
            return
        }
        
        if entrepreneurship.publishStatus == .unpublished {
            /// 如果未发布，进入编辑界面
            let vc = PublishEntrepreneurshipProjectViewController()
            vc.plan = entrepreneurship
            self.pushViewController(vc)
        } else {
            /// 如果已发布，进入详情页面
            let vc = EntrepreneurshipDetailsViewController()
            vc.entrepreneurshipId = entrepreneurshipId
            vc.entrepreneurshipPlan = entrepreneurship
            
            self.pushViewController(vc)
        }
    }
}

//MARK: --------------- TableViewCell 类 ------------------
extension EntrepreneurshipMyProjectViewController {
    
    class TableViewCell: EntrepreneurshipPlanCell {
        
        @discardableResult
        override func config(_ plan: EntrepreneurshipPlan) -> Self {
            
            super.config(plan)
            
            sendStatusView.set(status: plan.publishStatus)
            
            return self
        }
        
        override func createUI() {
            super.createUI()
            
            bgView.addSubview(sendStatusView)
            
            bgView.snp.updateConstraints { (make) in
                make.top.equalTo(12)
            }
            supportBtn.snp.remakeConstraints { (make) in
                make.left.equalTo(self.lookBtn.snp.right).offset(25)
                make.height.centerY.equalTo(self.lookBtn)
            }
            sendStatusView.snp.makeConstraints { (make) in
                make.top.equalTo(self.lookBtn.snp.bottom).offset(20)
                make.left.equalTo(15)
                make.right.equalTo(-15)
                make.height.equalTo(22)
                make.bottom.equalTo(-16)
            }
        }
        
        lazy var sendStatusView: ReleaseStatusView = {
            return ReleaseStatusView()
        }()
        
    }
}

extension EntrepreneurshipMyProjectViewController {
    enum TableRowActionType {
        case edit   // 编辑
        case delete // 删除
    }
}

extension EntrepreneurshipMyProjectViewController.TableViewCell {
    
    func createRowActionButton(_ image: UIImage?, touchTarget target: Any?, touchAction action: Selector) -> UIButton {
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor.white
        button.clipsToBounds = true
        button.layer.cornerRadius = 20
        button.setImage(image, for: .normal)
        button.addTarget(target, action: action, for: .touchUpInside)
        return button
    }
    
    class ReleaseStatusView: UIView {
        
        func set(status: EntrepreneurshipPlanExamineStatus) {
            
            sendLabel.textColor = UIColor.white
            sendLabel.text = (status == .unpublished) ? "未发布" : "发布成功"
            
            waitAuditishedLabel.textColor = (status != .unpublished) ? UIColor.white : UIColor_0x(0xc6c6c6)
            pointViewTwo.isHidden = (status == .unpublished)
            
            notPassLabel.isHidden = (status != .notPass)
            pointViewThree.isHidden = notPassLabel.isHidden
            
            passLabel.isHidden = (status == .notPass)
            passLabel.textColor = (status == .passed) ? UIColor.white : UIColor_0x(0xc6c6c6)
            
            blueBGView.backgroundColor = (status == .notPass) ? UIColor_0x(0xca3825) : THEMECOLOR
            
            switch status {
            case .unpublished:
                blueBGView.snp.remakeConstraints({ (make) in
                    make.left.top.bottom.equalToSuperview()
                    make.right.equalTo(self.sendLabel.snp.right).offset(11)
                })
            case .waitAuditished:
                blueBGView.snp.remakeConstraints({ (make) in
                    make.left.top.bottom.equalToSuperview()
                    make.right.equalTo(self.waitAuditishedLabel.snp.right).offset(11)
                })
            case .notPass:
                blueBGView.snp.remakeConstraints({ (make) in
                    make.left.top.bottom.equalToSuperview()
                    make.right.equalTo(self.notPassLabel.snp.right).offset(11)
                })
            case .passed:
                blueBGView.snp.remakeConstraints({ (make) in
                    make.left.top.bottom.right.equalToSuperview()
                })
            }
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            backgroundColor = EntrepreneurshipConfig.backgroundColor
            layer.cornerRadius = 11.5
            clipsToBounds = true
            
            addSubElementView()
        }
        
        func addSubElementView() {
            addSubview(blueBGView)
            addSubview(sendLabel)
            addSubview(waitAuditishedLabel)
            addSubview(notPassLabel)
            addSubview(passLabel)
            addSubview(pointViewOne)
            addSubview(pointViewTwo)
            addSubview(pointViewThree)
            
            sendLabel.snp.makeConstraints { (make) in
                make.left.equalTo(11)
                make.centerY.equalToSuperview()
            }
            waitAuditishedLabel.snp.makeConstraints { (make) in
                make.centerX.centerY.equalToSuperview()
            }
            passLabel.snp.makeConstraints { (make) in
                make.right.equalTo(-11)
                make.centerY.equalToSuperview()
            }
            notPassLabel.snp.makeConstraints { (make) in
                make.right.equalTo(self.passLabel.snp.left)
                make.centerY.equalToSuperview()
            }
            pointViewOne.snp.makeConstraints { (make) in
                make.centerX.equalTo(self.sendLabel.snp.left).offset(-3)
                make.centerY.equalToSuperview()
                make.width.height.equalTo(4)
            }
            pointViewTwo.snp.makeConstraints { (make) in
                make.centerX.equalTo(self.waitAuditishedLabel.snp.left).offset(-3)
                make.centerY.equalToSuperview()
                make.width.height.equalTo(4)
            }
            pointViewThree.snp.makeConstraints { (make) in
                make.centerX.equalTo(self.notPassLabel.snp.left).offset(-3)
                make.centerY.equalToSuperview()
                make.width.height.equalTo(4)
            }
        }
        
        lazy var blueBGView: UIView = {
            let view = UIView()
            view.backgroundColor = THEMECOLOR
            view.layer.cornerRadius = 11.5
            view.clipsToBounds = true
            return view
        }()
        lazy var pointViewOne: UIView = {
            return createPointView()
        }()
        lazy var pointViewTwo: UIView = {
            return createPointView()
        }()
        lazy var pointViewThree: UIView = {
            return createPointView()
        }()
        lazy var sendLabel: UILabel = {
            return createStatusLabel()
        }()
        lazy var waitAuditishedLabel: UILabel = {
            return createStatusLabel("等待审核")
        }()
        lazy var notPassLabel: UILabel = {
            return createStatusLabel("审核未通过")
        }()
        lazy var passLabel: UILabel = {
            return createStatusLabel("审核通过")
        }()
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
}

extension EntrepreneurshipMyProjectViewController.TableViewCell.ReleaseStatusView {
    func createPointView() -> UIView {
        let pointView = UIView()
        pointView.backgroundColor = UIColor.white
        pointView.layer.cornerRadius = 2
        pointView.clipsToBounds = true
        return pointView
    }
    
    func createStatusLabel(_ text: String = "") -> UILabel {
        let statusLabel = UILabel()
        statusLabel.font = font_PingFangSC_Regular(9)
        statusLabel.textColor = UIColor.white
        statusLabel.text = text
        return statusLabel
    }
}


