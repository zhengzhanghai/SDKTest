//
//  EntrepreneurshipDetailsViewController.swift
//  WashingMachine
//
//  Created by Harious on 2018/2/8.
//  Copyright © 2018年 Eteclabeteclab. All rights reserved.
//

import UIKit
import Kingfisher

class EntrepreneurshipDetailsViewController: BaseViewController {
    
    /// 创业项目ID, 需要传入
    var entrepreneurshipId: String = ""
    
    /// 点赞和评论后会调用次闭包(闭包第一个参数：项目id，第二个参数：数量，第三个参数类型)
    var refreshCount:((String, NSNumber?, EntrepreneurshipEventType)->())?
    
    /// 项目详情
    var entrepreneurshipPlan: EntrepreneurshipPlan?
    /// 项目图片
    var images: [EntrepreneurshipImage] = [EntrepreneurshipImage]()
    /// 专家评论
    var expertComments: [EntrepreneurshipExpertComment] = [EntrepreneurshipExpertComment]()
    /// 用户评论
    var userComments: [EntrepreneurshipUserComment] = [EntrepreneurshipUserComment]()
   
    /// 用户评论页数
    var userCommentLoadPage: Int = 1
    /// 用户评论每页数量
    var userCommentLoadSize: Int = 10
   
    /// 是否是给cell的内容评论
    var isCellComment: Bool = false
    /// 如果是给cell评论，记录的indexPath
    var cellIndexPath: IndexPath?
    
    /// 缓存用户评论cell的布局
    fileprivate let userCellLayoutCache = NSCache<NSNumber, UserCommentCellLayout>()
    
    lazy var vm: ViewModel = {
        return ViewModel(self)
    }()
    
    lazy var tableView: UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.backgroundColor = EntrepreneurshipConfig.backgroundColor
        table.delegate = self
        table.dataSource = self
        table.rowHeight = UITableView.automaticDimension
        table.estimatedRowHeight = 100
        table.tableFooterView = UIView()
        table.separatorStyle = .none
        table.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 0.001))
        CycleImageCell.register(toTabeView: table)
        ExamineStatusCell.register(toTabeView: table)
        ContentCell.register(toTabeView: table)
        ExpertCommentCell.register(toTabeView: table)
        UserCommentCell.register(toTabeView: table)
        
        return table
    }()
    lazy var bottomView: BottomView = {
        
        let view = BottomView()
        view.isUserInteractionEnabled = false
        
        view.didSelectedItem = { [unowned self] itemType in
            
            switch itemType {
            case .support:
                ZZPrint("项目点赞")
                self.projectSupport()
            case .comment:
                ZZPrint("点击项目评论")
                
                self.isCellComment = false;
                self.cellIndexPath = nil;
                
                self.promptCommentView()
            case .share:
                ZZPrint("点击项目分享")
            }
        }
        return view
    }()
    lazy var commentView: FeedbackReplyView = {
        let replyView = FeedbackReplyView(frame: CGRect(x: 0, y: 0, width: BOUNDS_WIDTH, height: BOUNDS_HEIGHT),
                                          placeholder: "请输入评论")
        replyView.cancelClourse = { [unowned self] in
            replyView.removeFromSuperview()
        }
        replyView.sendClourse = { [unowned self] content in
            replyView.removeFromSuperview()
            
            if self.isCellComment {
                
                guard let indexPath = self.cellIndexPath else {return}
                self.commentReply(indexPath, content: content)
                
            } else {
                
                self.sendComment(content)
            }
        }
        return replyView
    }()
    lazy var expertCommentHeader: TableExpertCommentHeader = {
        let header = TableExpertCommentHeader()
        header.frame = CGRect(x: 0, y: 0, width: BOUNDS_WIDTH, height: 30)
        return header
    }()
    lazy var userCommentHeader: TableUserCommentHeader = {
        let header = TableUserCommentHeader()
        header.frame = CGRect(x: 0, y: 0, width: BOUNDS_WIDTH, height: 92)
        header.didTapComment = { [unowned self] in
            
            self.isCellComment = false
            self.cellIndexPath = nil
            self.promptCommentView()
        }
        return header
    }()
    lazy var backBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(#imageLiteral(resourceName: "back_white_shadow"), for: .normal)
        btn.addTarget(self, action: #selector(clickBackBtn), for: .touchUpInside)
        return btn
    }()
    lazy var moreBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(#imageLiteral(resourceName: "three_point_white_shadow"), for: .normal)
        btn.addTarget(self, action: #selector(clickMoreBtn), for: .touchUpInside)
        return btn
    }()
    
    //MARK: --------------- viewDidLoad ------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard entrepreneurshipId != "" else {
            return
        }
        
        setUpUI()
        
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        refreshBottomCountAndStatus()
        
        loadDetails()
        loadImages()
        
        guard let plan = entrepreneurshipPlan else {
            return
        }
        
        if plan.publishStatus == .passed {
            loadExpertsComment()
            loadUserComment()
            
            tableView.nc_addLoadMoreAutoFooter({ [unowned self] in
                if self.userComments.count == 0 {
                    self.userCommentLoadPage = 1
                } else {
                    self.userCommentLoadPage += 1
                }
                
                self.loadUserComment()
            })
        }
    }
    
    /// 刷新底部的点赞评论分享数量
    fileprivate func refreshBottomCountAndStatus() {
        if let plan = entrepreneurshipPlan {
            
            self.bottomView.isUserInteractionEnabled = true
            
            self.bottomView.setCount(plan.goodCount?.intValue ?? 0, itemType: .support)
            self.bottomView.setCount(plan.commentCount?.intValue ?? 0, itemType: .comment)
            
            self.bottomView.supportBtn?.isSelected = plan.isGood?.boolValue ?? false
        }
    }
    
    @objc fileprivate func clickBackBtn() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //TODO: ------ ➡️ ----- 点击右上角三点响应事件 ------------------
    @objc fileprivate func clickMoreBtn() {
        
        guard let project = entrepreneurshipPlan else {
            return
        }
        
        let alertVC = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (_) in
            
        }
        alertVC.addAction(cancelAction)
        
        if project.publishStatus == .unpublished || project.publishStatus == .notPass {
            let editAction = UIAlertAction(title: "编辑", style: .default) { (_) in
                let vc = PublishEntrepreneurshipProjectViewController()
                vc.removeControllerCount = 1
                vc.plan = project
                self.pushViewController(vc)
            }
            alertVC.addAction(editAction)
        }
        
        let deleteAction = UIAlertAction(title: "删除", style: .default) { (_) in
            
            /// 删除二次提示
            let confirmAlert = UIAlertController(title: "确定删除吗？", message: nil, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (_) in
                
            }
            let sureAction = UIAlertAction(title: "确认", style: .default) { (_) in
                self.vm.delete(self.entrepreneurshipId)
            }
            confirmAlert.addAction(cancelAction)
            confirmAlert.addAction(sureAction)
            self.present(confirmAlert, animated: true, completion: nil)
        }
        alertVC.addAction(deleteAction)
        
        self.present(alertVC, animated: true, completion: nil)
        ZZPrint("点击了更多按钮")
    }
    
    fileprivate func setNavigationBar(isTranslucent: Bool, tintColor: UIColor, backgroundImage: UIImage?, shadowImage: UIImage?) {
        self.navigationController?.navigationBar.isTranslucent = isTranslucent
        self.navigationController?.navigationBar.tintColor = tintColor
        self.navigationController?.navigationBar.setBackgroundImage(backgroundImage, for: .default)
        self.navigationController?.navigationBar.shadowImage = shadowImage
    }
    
    fileprivate func setUpUI() {
        
        if entrepreneurshipPlan?.publishStatus == .passed {
            view.addSubview(bottomView)
            bottomView.snp.makeConstraints { (make) in
                make.left.bottom.right.equalToSuperview()
                make.height.equalTo(50)
            }
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            if entrepreneurshipPlan?.publishStatus != .passed {
                make.bottom.equalToSuperview()
            } else {
                make.bottom.equalTo(self.bottomView.snp.top)
            }
        }
        
        self.view.addSubview(backBtn)
        backBtn.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(topHeight-40)
            make.width.height.equalTo(30)
        }
        
    }
    
    /// 添加右上角更多操作按钮(获取项目详情后方可调用)
    fileprivate func addMoreOpreationBtn() {
        
        guard let project = entrepreneurshipPlan else { return }
        
        guard project.userId?.stringValue == getUserId() else { return }
        
        /// 当是自己发布的才添加右上角的按钮
        ///  点击事件来自这个按钮
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 0, y: 0, width: 31.66, height: 30)
        btn.addTarget(self, action: #selector(clickMoreBtn), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: btn)
        
        /// 这个只是做显示，不会响应点击操作
        self.view.addSubview(moreBtn)
        moreBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-10)
            make.top.equalTo(topHeight-40)
            make.width.height.equalTo(30)
        }
    }
    
    /// 弹出评论框
    fileprivate func promptCommentView() {
        windowRootView?.addSubview(self.commentView)
        self.commentView.textView.text = ""
        self.commentView.textView.becomeFirstResponder()
    }
    
    fileprivate func loadDetails() {
        
        vm.loadProjectDetails(entrepreneurshipId) { (project, message) in
            
            guard let entrepreneurship = project else { return }
            
            self.entrepreneurshipPlan = entrepreneurship
            
            self.refreshBottomCountAndStatus()
            
            self.tableView.beginUpdates()
            self.tableView.reloadSections(NSIndexSet(index: 2) as IndexSet, with: .automatic)
            self.tableView.endUpdates()
            
            
            if entrepreneurship.publishStatus == .passed {
                self.bottomView.setIsSupport(isSupport: entrepreneurship.isGood?.boolValue ?? false)
            }
            
            self.addMoreOpreationBtn()
        }
    }
    
    fileprivate func loadImages() {
        vm.loadImages(projectId: entrepreneurshipId) {  (imageModels, imageUrlStrs) in
            
            guard let images = imageModels else { return }
            
            self.tableView.beginUpdates()
            self.images = images
            self.tableView.reloadSections(NSIndexSet(index: 0) as IndexSet, with: .automatic)
            self.tableView.endUpdates()
        }
    }
    
    fileprivate func loadExpertsComment() {
        vm.loadExpertsComment(projectId: entrepreneurshipId) { (comments) in
            
            guard let expertComments = comments else { return }
            
            self.tableView.beginUpdates()
            self.expertComments = expertComments
            self.tableView.reloadSections(NSIndexSet(index: 3) as IndexSet, with: .automatic)
            self.tableView.endUpdates()
        }
    }
    
    fileprivate func loadUserComment() {
        
        vm.loadUserComment(projectId: entrepreneurshipId, page: userCommentLoadPage, size: userCommentLoadSize) { (comments) in
            
            self.tableView.nc_endFooterRefresh()
            
            guard let userComments = comments else {
                if self.userCommentLoadPage > 1 {
                    self.userCommentLoadPage -= 1
                }
                return
            }
            
            if self.userCommentLoadPage == 1 {
                self.userComments = userComments
            } else {
                for model in userComments {
                    self.userComments.append(model)
                }
            }
            
            for comment in userComments {
                self.cacheUserCellLayout(comment)
            }
            
            self.tableView.reloadData()
            
            if userComments.count < self.userCommentLoadSize {
                self.tableView.nc_endRefreshingWithNoMoreData()
            }
        }
    }
    
    /// 发送评论
    fileprivate func sendComment(_ content: String) {
        
        self.showWaitingView(appRootView ?? self.view)
        vm.sendComment(projectId: entrepreneurshipId, content: content) { (isSuccess, message) in
            
            self.hiddenWaitingView()
            
            if isSuccess {
                
                self.loadUserComment()
                
                if let project = self.entrepreneurshipPlan {
                    
                    project.commentCount = ((project.commentCount ?? 0).intValue + 1) as NSNumber
                    
                    self.refreshCount?(self.entrepreneurshipId, project.commentCount, .comment)
                    
                    self.refreshBottomCountAndStatus()
                }
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.4, execute: {
                    showSucccess("评论成功", superView: self.view)
                })
                
            } else {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.4, execute: {
                    showError(message, superView: self.view)
                })
            }
        }
    }
    
    /// 给项目点赞
    func projectSupport() {
        
        bottomView.supportBtn?.isEnabled = false
        
        vm.projectSupport(entrepreneurshipId) { (isSuccess, isError204, message) in
            
            self.bottomView.supportBtn?.isEnabled = true
            
            guard isSuccess || isError204 else {
                
                showError(message, superView: self.view)
                
                return
            }
            
            func setBottomSupportView(isSupport: Bool) {
                
                if let project = self.entrepreneurshipPlan {
                    
                    project.goodCount = ((project.goodCount ?? 0).intValue + (isSupport ? 1 : -1)) as NSNumber
                    if project.goodCount?.intValue ?? 0 < 0 {
                        project.goodCount = NSNumber(value: 0)
                    }
                    
                    project.isGood = NSNumber(value: isSupport)
                    
                    self.refreshCount?(self.entrepreneurshipId, project.goodCount, .support)
                    
                    self.refreshBottomCountAndStatus()
                    
                    postNotication(entrepreneurshipSupportNoticationName,
                                   nil,
                                   ["support" : EntrepreneurshipSupportItem(projectId: project.id?.stringValue ?? "",
                                                                            isSupport: project.isGood?.boolValue ?? false,
                                                                            supportCount: project.goodCount?.intValue ?? 0)])
                }
            }
            
            if isSuccess {
                
                showSucccess("点赞成功", superView: self.view)
                setBottomSupportView(isSupport: true)
                
            } else if isError204 {
                showError(message, superView: self.view)
                setBottomSupportView(isSupport: false)
            }
        }
    }
    
    /// 给项目评论点赞
    func commentSupport(commentId: String) {
        
        vm.projectCommentSupport(entrepreneurshipId, commentId: commentId) { (isSuccess, isError204, message) in
            
            guard isSuccess || isError204 else {
                
                self.findVisibleUserCommentCell(commentId: commentId)?.supportBtn.isEnabled = true
                showError(message, superView: self.view)
                
                return
            }
            
            func setBottomSupportView(isSupport: Bool) {
                
                guard let index = self.findUserCommentIndexInDataSource(commentId: commentId) else { return }
                
                let model = self.userComments[index]
                
                model.goodCount = NSNumber(value: (model.goodCount ?? 0).intValue + (isSupport ? 1 : -1))
                if model.goodCount?.intValue ?? 0 < 0 {
                    model.goodCount = NSNumber(value: 0)
                }
                model.isGood = NSNumber(value: isSupport)
                
                guard let cell = self.findVisibleUserCommentCell(indexPath: IndexPath(row: index, section: 4)) else { return }
                
                cell.supportBtn.isEnabled = true
                cell.supportBtn.isSelected = isSupport
                cell.supportBtn.setTitle(model.goodCount?.stringValue ?? "0", for: .normal)
            }
            
            if isSuccess {
                
                showSucccess("点赞成功", superView: self.view)
                setBottomSupportView(isSupport: true)
                
            } else if isError204 {
                showError(message, superView: self.view)
                setBottomSupportView(isSupport: false)
            }

        }
    }
    
    /// 给评论回复
    func commentReply(_ indexPath: IndexPath, content: String) {
        
        let comment = userComments[indexPath.row]
        
        guard let receiveId = comment.sendId?.stringValue,
            let parentId = comment.id?.stringValue else {
            return
        }
        
        self.showWaitingView(windowRootView ?? self.view)
        
        vm.commentReply(sendId: getUserId(), receiveId: receiveId, parentId: parentId, projectId: entrepreneurshipId, content: content) { (isSuccess, message) in
            
            self.hiddenWaitingView()
            
            if isSuccess {
                
                showSucccess("评论成功", superView: self.view)
                
                self.loadUserComment()
                
            } else {
                
                showError(message, superView: self.view)
                
            }
            
        }
        
    }
    

    
}

//MARK: ---------------  查找用户评论可视Cell相关 ------------------
extension EntrepreneurshipDetailsViewController {
    func findUserCommentIndexInDataSource(commentId: String) -> Int? {
        
        for (index , model) in userComments.enumerated() {
            
            guard let modelId = model.id?.stringValue else { continue }
            
            if commentId == modelId {
                return index
            }
        }
        
        return nil
    }
    
    func findVisibleUserCommentCell(commentId: String) -> UserCommentCell? {
        
        guard let index = findUserCommentIndexInDataSource(commentId: commentId) else {
            return nil
        }
        
        return findVisibleUserCommentCell(indexPath: IndexPath(row: index, section: 4))
    }
    
    func findVisibleUserCommentCell(indexPath: IndexPath) -> UserCommentCell? {
        
        guard let indexPaths = self.tableView.indexPathsForVisibleRows else { return nil }
        
        guard indexPaths.contains(indexPath) else { return nil }
        
        return self.tableView.cellForRow(at: indexPath) as? UserCommentCell
    }
}

//MARK: --------------- 有关缓存及读取用户评论cell的布局 ------------------
extension EntrepreneurshipDetailsViewController {

    /// 缓存用户评论cell的布局
    func cacheUserCellLayout(_ comment: EntrepreneurshipUserComment) {
        
        guard let commentId = comment.id else { return }
        
        /// 先从缓存中找, 如果EntrepreneurshipUserComment跟缓存中的没有变化不必再重新缓存
        if let layout = userCellLayoutCache.object(forKey: commentId) {
            if layout.comment == comment {
                return
            }
        }
        
        // 缓存布局
        userCellLayoutCache.setObject(UserCommentCellLayout(comment), forKey: commentId)
    }
    
    /// 从缓存中读取用户评论cell的布局
    func readUserCellLayout(_ comment: EntrepreneurshipUserComment) -> UserCommentCellLayout? {
        
        guard let commentId = comment.id else { return nil }
        
        return userCellLayoutCache.object(forKey: commentId)
    }
}

//MARK: --------------- 用户评论cell布局类 ------------------
extension EntrepreneurshipDetailsViewController {
    
    class UserCommentCellLayout {
        /// 整个cell高度
        var cellHeight: CGFloat = 0
        /// 评论内容高度
        var contentHeight: CGFloat = 0
        /// 回复那个tableview高度
        var replyHeight: CGFloat = 0
        var comment: EntrepreneurshipUserComment
        
        init(_ comment: EntrepreneurshipUserComment) {
            
            self.comment = comment
            
            if let content = comment.content {
                self.contentHeight = content.sizeWithFont(font_PingFangSC_Regular(15),
                                                          CGSize(width: BOUNDS_WIDTH-24, height: CGFloat.greatestFiniteMagnitude)).height
            }
            if let replys = comment.replyModels, replys.count != 0 {
                
                replyHeight = 10 //
                
                for model in replys {
                    let str = (model.sendAccountName ?? "") + "：" + (model.content ?? "")
                    replyHeight += str.sizeWithFont(font_PingFangSC_Regular(14), CGSize(width: BOUNDS_WIDTH-44, height: CGFloat.greatestFiniteMagnitude)).height + 10
                }
                
                cellHeight = contentHeight + replyHeight + 100
                
            } else {
                replyHeight = 0
                
                cellHeight = contentHeight + 100
            }
        }
    }
}

//MARK: --------------- viewWillAppear、 viewWillDisappear ------------------
extension EntrepreneurshipDetailsViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setNavigationBar(isTranslucent: true,
                         tintColor: UIColor.clear,
                         backgroundImage: UIImage.create(color: UIColor.clear),
                         shadowImage: UIImage())
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        backBtn.isHidden = true
        setNavigationBar(isTranslucent: false,
                         tintColor: UIColor.black,
                         backgroundImage: UIImage.create(color: UIColor.clear),
                         shadowImage: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        backBtn.isHidden = false
        setNavagationBarAlpha()
    }
    
    fileprivate func setNavagationBarAlpha() {
//        var offectY = tableView.contentOffset.y
//        if offectY < 0  {
//            offectY = 0
//        }
//        if offectY > 100 {
//            offectY = 100
//        }
//        let ratio = offectY/100
//
//        setNavigationBar(isTranslucent: true,
//                         tintColor: UIColor.white,
//                         backgroundImage: UIImage.create(color: UIColor.clear),
//                         shadowImage: UIImage())
    }
}


//MARK: --------------- UIScrollViewDelegate ------------------
extension EntrepreneurshipDetailsViewController {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        setNavagationBarAlpha()
    }
}

//MARK: --------------- UITableViewDelegate、UITableViewDataSource ------------------

extension EntrepreneurshipDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0: return images.isEmpty ? 0 : 1
        case 1: return (entrepreneurshipPlan?.publishStatus != .passed) ? 1: 0
        case 2: return (entrepreneurshipPlan == nil) ? 0 : 1
        case 3: return expertComments.count
        case 4: return userComments.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            var imageStrings = [String]()
            for imageModel in self.images {
                imageStrings.append(imageModel.url ?? "")
            }
            return (CycleImageCell.create(tableView, indexPath) as! CycleImageCell).configImages(imageStrings, vc: self)
            
        case 1:
            return (ExamineStatusCell.create(tableView, indexPath) as! ExamineStatusCell).config(entrepreneurshipPlan?.publishStatusStr ?? "",
                                                                                                 entrepreneurshipPlan?.publishStatusExplainStr ?? "")
            
        case 2:
            return (ContentCell.create(tableView, indexPath) as! ContentCell).config(entrepreneurshipPlan ?? EntrepreneurshipPlan(), isHiddenBrowse: entrepreneurshipPlan?.publishStatus != .passed)
            
        case 3:
            return (ExpertCommentCell.create(tableView, indexPath) as! ExpertCommentCell).config(expertComments[indexPath.row])
            
        default:
            let comment = userComments[indexPath.row]
            let cell = (UserCommentCell.create(tableView, indexPath) as! UserCommentCell).config(comment, layout: self.readUserCellLayout(comment))
            cell.action = { [unowned self] (type, commentId) in
                if type == .support {
                    self.commentSupport(commentId: commentId)
                } else if type == .comment {
                    self.isCellComment = true
                    self.cellIndexPath = indexPath
                    
                    self.promptCommentView()
                }
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 3: return expertComments.isEmpty ? 0.0001 : 30
        case 4: return (entrepreneurshipPlan?.publishStatus != .passed) ? 0.0001 : 92
        default:
            return 0.0001
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 3: return expertComments.isEmpty ? nil : expertCommentHeader
        case 4: return (entrepreneurshipPlan?.publishStatus != .passed) ? nil : userCommentHeader
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        switch section {
        case 0:
            return self.images.isEmpty ? 0.0001 : 12
        case 1:
            return (entrepreneurshipPlan?.publishStatus != .passed) ? 12 : 0.0001
        case 2:
            return (self.entrepreneurshipPlan == nil) ? 0.0001 : 12
        case 3:
            return self.expertComments.isEmpty ? 0.0001 : 12
        default:
            return 0.0001
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    
}


//MARK: --------------- 最底部的视图(包括点赞、评论、分享数量) ------------------
extension EntrepreneurshipDetailsViewController {
    class BottomView: UIView {
        
        /// 点击按钮回调
        var didSelectedItem: ((ItemType)->())?
        /// 用于存储item按钮
        var items: [UIButton] = [UIButton]()
        
        var commentBtn : UIButton? {
            return items.first
        }
        
        var supportBtn : UIButton? {
            return items.last
        }
        
//        let images = [#imageLiteral(resourceName: "comment"), #imageLiteral(resourceName: "support"), #imageLiteral(resourceName: "like_normal")]
        let images = [#imageLiteral(resourceName: "comment"), #imageLiteral(resourceName: "support")]
        let imageSelecteds = [#imageLiteral(resourceName: "comment"), #imageLiteral(resourceName: "support_ed")]
        let marginRatio : CGFloat = CGFloat(5)/320
        var countFloat: CGFloat  {
            return CGFloat(images.count)
        }
        var widthRatio: CGFloat {
            return (1-marginRatio*(countFloat*2))/countFloat
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            backgroundColor = UIColor.white
            
            setUpUI()
        }
        
        /// 添加点赞、评论、分享按钮
        fileprivate func setUpUI() {
            
            for (index, image) in images.enumerated() {
                
                let button = UIButton(type: .custom)
                button.tag = index
                button.setImage(image, for: .normal)
                button.setImage(imageSelecteds[index], for: .selected)
                button.setTitle("0", for: .normal)
                button.titleLabel?.font = font_PingFangSC_Regular(14)
                button.setTitleColor(UIColor_0x(0xaaaaaa), for: .normal)
                button.layout(forEdgeInsetsStyle: .left, imageTitleSpace: 3)
                button.addTarget(self, action: #selector(clickItem(_:)), for: .touchUpInside)
                items.append(button)
                addSubview(button)
                button.snp.makeConstraints({ (make) in
                    make.top.equalTo(5)
                    make.bottom.equalTo(-5)
                    make.left.equalTo(self.snp.right).multipliedBy((2*CGFloat(index)+1)*marginRatio + CGFloat(index)*widthRatio)
                    make.right.equalTo(self.snp.right).multipliedBy((2*CGFloat(index)+1)*marginRatio + CGFloat(index+1)*widthRatio)
                })
            }
        }
        
        /// 设置数量
        func setCount(_ count: Int, itemType: ItemType) {
            
            var item : UIButton!
            
            switch itemType {
            case .support:
                item = items[1]
            case .comment:
                item = items[0]
            case .share:
                item = items[2]
            }
            
            item.setTitle(count.stringValue, for: .normal)
        }
        
        func setIsSupport(isSupport: Bool) {
            items[1].isSelected = isSupport
        }
        
        @objc private func clickItem(_ btn: UIButton) {
            
            guard let itemType = ItemType(rawValue: btn.tag) else { return }
            
            didSelectedItem?(itemType)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        /// 画分割线
        override func draw(_ rect: CGRect) {
            let path = UIBezierPath(rect: self.bounds)
            path.lineWidth = 0.5
            UIColor_0x(0xd5d5d5).setStroke()
            
            path.move(to: CGPoint.zero)
            path.addLine(to: CGPoint(x: self.frame.maxX, y: 0))

            let selfWidth = self.bounds.width
            
            for index in 1 ..< images.count {
                let indexCGFloat = CGFloat(index)*selfWidth
                let dX = indexCGFloat*2*marginRatio + indexCGFloat*widthRatio
                path.move(to: CGPoint(x: dX, y: 10))
                path.addLine(to: CGPoint(x: dX, y: self.frame.height-10))
            }
            
            path.close()
            path.stroke()
            
        }
        
    }
}

extension EntrepreneurshipDetailsViewController.BottomView {
    enum ItemType: Int {
        case comment = 0 // 评论
        case support = 1 // 点赞
        case share = 2   // 分享
    }
}

//MARK: --------------- tableView 专家点评头视图类 ------------------
extension EntrepreneurshipDetailsViewController {
    
    class TableExpertCommentHeader: UIView {
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            backgroundColor = UIColor.white
            
            let leftView = UIView()
            leftView.layer.cornerRadius = 6
            leftView.layer.borderWidth = 2.5
            leftView.layer.borderColor = THEMECOLOR.cgColor
            leftView.clipsToBounds = true
            addSubview(leftView)
            leftView.snp.makeConstraints { (make) in
                make.left.equalTo(15)
                make.centerY.equalToSuperview()
                make.width.height.equalTo(12)
            }
            
            createLabel("专家点评",
                        textColor: UIColor_0x(0x4f4f4f),
                        font: font_PingFangSC_Regular(15),
                        superView: self)
                .snp.makeConstraints { (make) in
                    make.centerY.equalTo(leftView)
                    make.left.equalTo(leftView.snp.right).offset(8)
            }
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}

//MARK: --------------- tableView 用户评论头视图类 ------------------
extension EntrepreneurshipDetailsViewController {

    class TableUserCommentHeader: UIView {
        
        var didTapComment: (()->())?
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            backgroundColor = UIColor.white
            
            let titleLabel = createLabel("最新评论",
                                         textColor: UIColor_0x(0x4f4f4f),
                                         font: font_PingFangSC_Regular(15),
                                         superView: self)
            titleLabel.snp.makeConstraints { (make) in
                make.top.equalTo(10)
                make.left.equalTo(11)
            }
            
            let commentBtn = UIButton(type: .custom)
            commentBtn.backgroundColor = UIColor_0x(0xf5f5f5)
            commentBtn.titleLabel?.font = font_PingFangSC_Regular(15)
            commentBtn.setTitle("快发表一下你的看法吧......", for: .normal)
            commentBtn.setTitleColor(UIColor_0x(0xc2c2c2), for: .normal)
            commentBtn.contentHorizontalAlignment = .left
            commentBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
            commentBtn.layer.cornerRadius = 18
            commentBtn.clipsToBounds = true
            commentBtn.addTarget(self, action: #selector(clickComment), for: .touchUpInside)
            addSubview(commentBtn)
            commentBtn.snp.makeConstraints { (make) in
                make.top.equalTo(titleLabel.snp.bottom).offset(13)
                make.left.equalTo(15)
                make.right.equalTo(-15)
                make.height.equalTo(36)
            }
            
        }
        
        @objc fileprivate func clickComment() {
            didTapComment?()
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}

//MARK: --------------- 上面轮播图图片cell ------------------
extension EntrepreneurshipDetailsViewController {
    
    class CycleImageCell: BaseTableViewCell {
        
        weak var vc: BaseViewController?
        var imageUrls: [String]?
        
        lazy var cycleView: HZCycleView = {
            let cyView = HZCycleView(frame: CGRect(x: 0, y: 0, width: BOUNDS_WIDTH, height: BOUNDS_WIDTH*245/375))
            cyView.imageViewContentMode = .scaleAspectFill
            cyView.didSelectedItem = { [unowned self] index in

                self.presentPhotoBrowser(index: index)
                ZZPrint("index  \(index)")
            }
            return cyView
        }()
        
        func presentPhotoBrowser(index: Int) {
            
            guard let vc = self.vc else { return }
            guard let imageUrlStrs = self.imageUrls, imageUrlStrs.count > 0 else { return }

            let browserVC = PhotoBrowser(showByViewController: vc, delegate: self)
            browserVC.pageControlDelegate = PhotoBrowserDefaultPageControlDelegate(numberOfPages: imageUrlStrs.count)
            browserVC.show(index: index)
        }
        
        override func createUI() {
            
            self.selectionStyle = .none
            
            contentView.addSubview(cycleView)

            cycleView.snp.makeConstraints { (make) in
                make.left.top.right.bottom.equalToSuperview()
                make.height.equalTo(BOUNDS_WIDTH*245/375)
            }
        }
        
        @discardableResult
        func configImages(_ imageUrlStrs: [String], vc: BaseViewController) -> Self {
            
            self.vc = vc
            self.imageUrls = imageUrlStrs

            cycleView.imageURLStringArr = imageUrlStrs

            return self
        }
        

    }
}

//MARK: --------------- PhotoBrowserDelegate ------------------
extension EntrepreneurshipDetailsViewController.CycleImageCell: PhotoBrowserDelegate {
    
    func numberOfPhotos(in photoBrowser: PhotoBrowser) -> Int {
        return self.imageUrls?.count ?? 0
    }
    
    /// 缩放起始视图
    func photoBrowser(_ photoBrowser: PhotoBrowser, thumbnailViewForIndex index: Int) -> UIView? {
        return self.cycleView.collectionView(self.cycleView.collectionView, cellForItemAt: IndexPath(row: index, section: 0))
    }
    
    /// 图片加载前的placeholder
    func photoBrowser(_ photoBrowser: PhotoBrowser, thumbnailImageForIndex index: Int) -> UIImage? {
        return nil
    }
    
    /// 高清图url
    func photoBrowser(_ photoBrowser: PhotoBrowser, highQualityUrlForIndex index: Int) -> URL? {
        
        guard let imageStr = self.imageUrls?[index] else {
            return nil
        }
        return URL(string: imageStr)
    }
    
    /// 长按图片
    func photoBrowser(_ photoBrowser: PhotoBrowser, didLongPressForIndex index: Int, image: UIImage) {
        //        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        //        let saveImageAction = UIAlertAction(title: "保存图片", style: .default) { (_) in
        //            print("保存图片：\(image)")
        //        }
        //        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        //
        //        actionSheet.addAction(saveImageAction)
        //        actionSheet.addAction(cancelAction)
        //        photoBrowser.present(actionSheet, animated: true, completion: nil)
    }
}

//MARK: --------------- 审核状态cell ------------------
extension EntrepreneurshipDetailsViewController {
    
    class ExamineStatusCell: BaseTableViewCell {
        
        lazy var examineStatusLabel: UILabel = {
            return createLabel("",
                               textColor: UIColor_0x(0xc70000),
                               font: font_PingFangSC_Regular(13),
                               superView: contentView)
        }()
        lazy var explainLabel: UILabel = {
            let label = createLabel("",
                                    textColor: UIColor_0x(0x5f5f5f),
                                    font: font_PingFangSC_Regular(12),
                                    superView: contentView)
            label.numberOfLines = 0
            return label
        }()
        
        override func createUI() {
            
            self.selectionStyle = .none
            self.contentView.backgroundColor = UIColor_0x(0xfffde4)
            
            examineStatusLabel.snp.makeConstraints { (make) in
                make.left.equalTo(15)
                make.top.equalTo(9)
                make.right.equalTo(-15)
            }
            explainLabel.snp.makeConstraints { (make) in
                make.top.equalTo(self.examineStatusLabel.snp.bottom).offset(5)
                make.left.right.equalTo(self.examineStatusLabel)
                make.bottom.equalTo(-15)
            }
        }
        
        @discardableResult
        func config(_ statusStr: String, _ explainStr: String) -> Self {
            examineStatusLabel.text = statusStr
            explainLabel.text = explainStr
            return self
        }
    }
}

//MARK: --------------- 详情cell ------------------
extension EntrepreneurshipDetailsViewController {
    
    class ContentCell: BaseTableViewCell {
        
        lazy var titleLabel: UILabel = {
            let label = createLabel("",
                                    textColor: UIColor_0x(0x414141),
                                    font: font_PingFangSC_Regular(20),
                                    superView: contentView)
            label.numberOfLines = 0
            return label
        }()
        
        lazy var createrTitleLabel: UILabel = {
            return createLabel("创始人",
                               textColor: UIColor_0x(0xcbcbcb),
                               font: font_PingFangSC_Regular(13),
                               superView: contentView)
        }()
        lazy var schoolTitleLabel: UILabel = {
            return createLabel("所属院校",
                               textColor: UIColor_0x(0xcbcbcb),
                               font: font_PingFangSC_Regular(13),
                               superView: contentView)
        }()
        lazy var teamNumberTitleLabel: UILabel = {
            return createLabel("团队人数",
                               textColor: UIColor_0x(0xcbcbcb),
                               font: font_PingFangSC_Regular(13),
                               superView: contentView)
        }()
        lazy var createrLabel: UILabel = {
            return createLabel("",
                               textColor: UIColor_0x(0x464646),
                               font: font_PingFangSC_Regular(13),
                               superView: contentView)
        }()
        lazy var schoolLabel: UILabel = {
            return createLabel("",
                               textColor: UIColor_0x(0x464646),
                               font: font_PingFangSC_Regular(13),
                               superView: contentView)
        }()
        lazy var teamNumberLabel: UILabel = {
            return createLabel("",
                               textColor: UIColor_0x(0x464646),
                               font: font_PingFangSC_Regular(13),
                               superView: contentView)
        }()
        lazy var despTitleLabel: UILabel = {
            return createLabel("项目介绍",
                               textColor: UIColor_0x(0xcbcbcb),
                               font: font_PingFangSC_Regular(13),
                               superView: contentView)
        }()
        lazy var contentLabel: UILabel = {
            let label = createLabel("",
                                    textColor: UIColor_0x(0x464646),
                                    font: font_PingFangSC_Regular(15),
                                    superView: contentView)
            label.numberOfLines = 0
            return label
        }()
        lazy var publishTimeLabel: UILabel = {
            return createLabel("",
                               textColor: UIColor_0x(0xcbcbcb),
                               font: font_PingFangSC_Regular(12),
                               superView: contentView)
        }()
        lazy var browseNumberLabel: UILabel = {
            return createLabel("",
                               textColor: UIColor_0x(0xcbcbcb),
                               font: font_PingFangSC_Regular(12),
                               superView: contentView)
        }()
        lazy var investedIcon: UIImageView = {
            return UIImageView(image: #imageLiteral(resourceName: "invest_ed"))
        }()
        
        override func createUI() {
            
            self.selectionStyle = .none
            
            contentView.addSubview(investedIcon)

            titleLabel.snp.makeConstraints { (make) in
                make.top.equalTo(20)
                make.left.equalTo(16)
                make.right.equalTo(-16)
            }
            createrTitleLabel.snp.makeConstraints { (make) in
                make.left.equalTo(18)
                make.top.equalTo(self.titleLabel.snp.bottom).offset(26)
                make.width.equalTo(80)
            }
            createrLabel.snp.makeConstraints { (make) in
                make.left.equalTo(self.createrTitleLabel.snp.right).offset(2)
                make.centerY.equalTo(self.createrTitleLabel)
                make.right.equalTo(-15)
            }
            schoolTitleLabel.snp.makeConstraints { (make) in
                make.top.equalTo(self.createrTitleLabel.snp.bottom).offset(12)
                make.left.width.equalTo(self.createrTitleLabel)
            }
            schoolLabel.snp.makeConstraints { (make) in
                make.centerY.equalTo(self.schoolTitleLabel)
                make.right.width.equalTo(self.createrLabel)
            }
            teamNumberTitleLabel.snp.makeConstraints { (make) in
                make.top.equalTo(self.schoolTitleLabel.snp.bottom).offset(12)
                make.left.width.equalTo(self.createrTitleLabel)
            }
            teamNumberLabel.snp.makeConstraints { (make) in
                make.centerY.equalTo(self.teamNumberTitleLabel)
                make.right.width.equalTo(self.createrLabel)
            }
            despTitleLabel.snp.makeConstraints { (make) in
                make.left.equalTo(18)
                make.top.equalTo(self.teamNumberTitleLabel.snp.bottom).offset(30)
            }
            contentLabel.snp.makeConstraints { (make) in
                make.top.equalTo(self.despTitleLabel.snp.bottom).offset(9)
                make.left.equalTo(18)
                make.height.equalTo(0)
                make.right.equalTo(-12)
            }
            publishTimeLabel.snp.makeConstraints { (make) in
                make.left.equalTo(18)
                make.top.equalTo(self.contentLabel.snp.bottom).offset(10)
                make.width.lessThanOrEqualTo((BOUNDS_WIDTH-46)/2)
            }
            browseNumberLabel.snp.makeConstraints { (make) in
                make.centerY.equalTo(self.publishTimeLabel)
                make.right.equalTo(-18)
                make.bottom.equalTo(-20)
                make.width.lessThanOrEqualTo((BOUNDS_WIDTH-46)/2)
            }
            investedIcon.snp.makeConstraints { (make) in
                make.top.equalTo(20)
                make.right.equalTo(-30)
                make.width.height.equalTo(90)
            }
        }
        
        @discardableResult
        func config(_ plan: EntrepreneurshipPlan, isHiddenBrowse: Bool) -> Self {
            titleLabel.text = plan.name
            createrLabel.text = plan.realName
            schoolLabel.text = plan.schoolName
            teamNumberLabel.text = plan.teamNumberStr
            contentLabel.text = plan.content
            
            /// 修正iOS 10下自动计算高度不够问题
            contentLabel.snp.updateConstraints { (make) in
                make.height.equalTo((contentLabel.text ?? "").sizeWithFont(contentLabel.font, CGSize(width: BOUNDS_WIDTH-30, height: CGFloat.greatestFiniteMagnitude)).height + 1)
            }
            
            publishTimeLabel.text = plan.commitTime?.timeStr() ?? ""
            investedIcon.isHidden = !plan.isInvested
            
            browseNumberLabel.isHidden = isHiddenBrowse
            if !isHiddenBrowse {
                browseNumberLabel.text = "\(plan.views ?? 0)浏览"
            }
            
            return self
        }

    }
}

//MARK: --------------- 专家点评cell ------------------
extension EntrepreneurshipDetailsViewController {
    
    class ExpertCommentCell: BaseTableViewCell {
        
        lazy var expertIcon: UIImageView = {
            return createCornerRadiusImageView(20, superVeiw: contentView)
        }()
        lazy var expertNameLabel: UILabel = {
            return createLabel("", textColor: UIColor_0x(0x4f4f4f),
                               font: font_PingFangSC_Regular(15),
                               superView: contentView)
        }()
        lazy var expertTypeLabel: UILabel = {
            return createLabel("", textColor: UIColor_0x(0xadadad),
                               font: font_PingFangSC_Regular(12),
                               superView: contentView)
        }()
        lazy var contentLabel: UILabel = {
            let label = createLabel("", textColor: UIColor_0x(0x777777),
                                    font: font_PingFangSC_Regular(13),
                                    superView: contentView)
            label.numberOfLines = 0
            return label
        }()
        
        override func createUI() {
            
            self.selectionStyle = .none
            
            expertIcon.snp.makeConstraints { (make) in
                make.top.equalTo(17)
                make.left.equalTo(15)
                make.width.height.equalTo(40)
            }
            expertNameLabel.snp.makeConstraints { (make) in
                make.top.equalTo(self.expertIcon)
                make.left.equalTo(self.expertIcon.snp.right).offset(13)
                make.right.equalTo(-15)
                make.height.equalTo(20)
            }
            expertTypeLabel.snp.makeConstraints { (make) in
                make.left.right.equalTo(self.expertNameLabel)
                make.bottom.equalTo(self.expertIcon)
                make.height.equalTo(17)
            }
            contentLabel.snp.makeConstraints { (make) in
                make.top.equalTo(self.expertIcon.snp.bottom).offset(14)
                make.left.equalTo(16)
                make.right.equalTo(-9)
                make.bottom.equalTo(-14)
            }
        }
        
        func config(_ comment: EntrepreneurshipExpertComment) -> Self {
            expertIcon.kf.setImage(with: URL.init(string: comment.portrait ?? ""),
                                   placeholder: UIImage.init(named: "header_moren"),
                                   options: [.transition(ImageTransition.fade(1))])
            expertNameLabel.text = comment.name
            expertTypeLabel.text = comment.desp
            contentLabel.text = comment.content
            
            return self
        }
        
    }
}


//MARK: --------------- 用户评论cell ------------------
extension EntrepreneurshipDetailsViewController {
    
    class UserCommentCell: BaseTableViewCell {
        
        var action:((EntrepreneurshipEventType, String)->())?
        
        var comment: EntrepreneurshipUserComment?
        
        lazy var userIcon: UIImageView = {
            return createCornerRadiusImageView(20, superVeiw: contentView)
        }()
        lazy var nickNameLabel: UILabel = {
            return createLabel("", textColor: UIColor_0x(0x4f4f4f),
                               font: font_PingFangSC_Regular(15),
                               superView: contentView)
        }()
        lazy var commentTimeLabel: UILabel = {
            return createLabel("", textColor: UIColor_0x(0xadadad),
                               font: font_PingFangSC_Regular(12),
                               superView: contentView)
        }()
        lazy var contentLabel: UILabel = {
            let label = createLabel("", textColor: UIColor_0x(0x5f5f5f),
                                    font: font_PingFangSC_Regular(15),
                                    superView: contentView)
            label.numberOfLines = 0
            return label
        }()
        lazy var commentBtn: UIButton = {
            let button = UIButton(type: .custom)
            button.setImage(#imageLiteral(resourceName: "comment"), for: .normal)
            button.setTitleColor(UIColor_0x(0x979797), for: .normal)
            button.titleLabel?.font = font_PingFangSC_Regular(13)
            return button
        }()
        lazy var supportBtn: UIButton = {
            let button = UIButton(type: .custom)
            button.setImage(#imageLiteral(resourceName: "support"), for: .normal)
            button.setImage(#imageLiteral(resourceName: "support_ed"), for: .selected)
            button.setTitleColor(UIColor_0x(0x979797), for: .normal)
            button.titleLabel?.font = font_PingFangSC_Regular(13)
            return button
        }()
        lazy var triangularView: HZTriangularView = {
            return HZTriangularView(frame: CGRect.zero, fillColor: EntrepreneurshipConfig.backgroundColor)
        }()
        lazy var tableView: UITableView = {
            let table = UITableView(frame: CGRect.zero, style: .plain)
            table.backgroundColor = EntrepreneurshipConfig.backgroundColor
            table.delegate = self
            table.dataSource = self
            table.rowHeight = UITableView.automaticDimension
            table.estimatedRowHeight = 100
            table.isScrollEnabled = false
            table.showsVerticalScrollIndicator = false
            table.showsHorizontalScrollIndicator = false
            table.separatorStyle = .none
            table.tableFooterView = UIView()
            Cell.register(toTabeView: table)
            return table
        }()
        lazy var sepline: UIView = {
            let view = UIView()
            view.backgroundColor = UIColor_0x(0xcccccc)
            return view
        }()
        
        @objc fileprivate func clickComment(_ btn: UIButton) {
            
            guard let commentId = self.comment?.id?.stringValue else {
                return
            }
            
            action?(.comment, commentId)
        }
        
        @objc fileprivate func clickSupport(_ btn: UIButton) {
            
            guard let commentId = self.comment?.id?.stringValue else {
                return
            }
            
            btn.isEnabled = false
            action?(.support, commentId)
        }
        
        override func createUI() {
            
            commentBtn.addTarget(self, action: #selector(clickComment(_:)), for: .touchUpInside)
            supportBtn.addTarget(self, action: #selector(clickSupport(_:)), for: .touchUpInside)
            
            self.selectionStyle = .none
            contentView.addSubview(commentBtn)
            contentView.addSubview(supportBtn)
            contentView.addSubview(triangularView)
            contentView.addSubview(tableView)
            contentView.addSubview(sepline)
            
            userIcon.snp.makeConstraints { (make) in
                make.top.equalTo(17)
                make.left.equalTo(15)
                make.width.height.equalTo(40)
            }
            nickNameLabel.snp.makeConstraints { (make) in
                make.top.equalTo(self.userIcon)
                make.left.equalTo(self.userIcon.snp.right).offset(13)
                make.right.equalTo(-15)
                make.height.equalTo(20)
            }
            commentTimeLabel.snp.makeConstraints { (make) in
                make.left.right.equalTo(self.nickNameLabel)
                make.bottom.equalTo(self.userIcon)
                make.height.equalTo(17)
            }
            contentLabel.snp.makeConstraints { (make) in
                make.top.equalTo(self.userIcon.snp.bottom).offset(14)
                make.left.equalTo(15)
                make.right.equalTo(-9)
            }
            supportBtn.snp.makeConstraints { (make) in
                make.top.equalTo(self.contentLabel.snp.bottom).offset(14)
                make.right.equalTo(-14)
                make.height.equalTo(20)
            }
            commentBtn.snp.makeConstraints { (make) in
                make.top.height.equalTo(self.supportBtn)
                make.right.equalTo(self.supportBtn.snp.left).offset(-25)
            }
            triangularView.snp.makeConstraints { (make) in
                make.top.equalTo(self.commentBtn.snp.bottom)
                make.centerX.equalTo(self.commentBtn)
                make.width.equalTo(20)
                make.height.equalTo(10)
            }
            tableView.snp.makeConstraints { (make) in
                make.top.equalTo(self.triangularView.snp.bottom)
                make.left.right.equalTo(self.contentLabel)
                make.height.equalTo(1)
            }
            sepline.snp.makeConstraints { (make) in
                make.top.equalTo(self.tableView.snp.bottom).offset(14)
                make.left.equalTo(15)
                make.right.equalToSuperview()
                make.height.equalTo(0.5)
                
                make.bottom.equalToSuperview()
            }
        }
        
        func config(_ comment: EntrepreneurshipUserComment, layout: UserCommentCellLayout?) -> Self {
            
            self.comment = comment
            
            userIcon.kf.setImage(with: URL.init(string: comment.sendPortrait ?? ""),
                                 placeholder: UIImage.init(named: "header_moren"),
                                 options: [.transition(ImageTransition.fade(1))])
            nickNameLabel.text = comment.sendAccountName
            commentTimeLabel.text = comment.createTime?.timeStr()
            contentLabel.text = comment.content
            supportBtn.setTitle(comment.goodCount?.stringValue ?? "0", for: .normal)
            commentBtn.setTitle(comment.replyCount?.stringValue ?? "0", for: .normal)
            
            supportBtn.isSelected = comment.isGood?.boolValue ?? false
            supportBtn.isEnabled = true
            
            tableView.reloadData()
            
            layoutIfNeeded()
            
            if self.comment?.replyModels == nil || (self.comment?.replyModels)!.count == 0 {
                tableView.isHidden = true
                triangularView.isHidden = true
                tableView.snp.updateConstraints { (make) in
                    make.height.equalTo(0)
                }
            } else {
                tableView.isHidden = false
                triangularView.isHidden = false
                tableView.snp.updateConstraints { (make) in
                    make.height.equalTo(layout?.replyHeight ?? tableView.contentSize.height)
                }
            }
            
            return self
        }
  
    }
}

extension EntrepreneurshipDetailsViewController.UserCommentCell: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.comment?.replyModels?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let comment = self.comment?.replyModels?[indexPath.row] else {
            return (Cell.create(tableView, indexPath) as! Cell).config(EntrepreneurshipUserComment())
        }
        return (Cell.create(tableView, indexPath) as! Cell).config(comment)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
}

extension EntrepreneurshipDetailsViewController.UserCommentCell {
    
    class Cell: BaseTableViewCell {
        
        lazy var contentLabel: UILabel = {
            let label = createLabel("",
                                    textColor: UIColor_0x(0x2f2f2f),
                                    font: font_PingFangSC_Regular(14),
                                    superView: contentView)
            label.numberOfLines = 0
            return label
        }()
        
        @discardableResult
        func config(_ comment: EntrepreneurshipUserComment) -> Self {
            contentLabel.text = (comment.sendAccountName ?? "") + "：" + (comment.content ?? "")
            
            return self
        }
        
        override func createUI() {
            super.createUI()
            
            selectionStyle = .none
            contentView.backgroundColor = EntrepreneurshipConfig.backgroundColor
            
            contentLabel.snp.makeConstraints { (make) in
                make.top.equalTo(5)
                make.left.equalTo(10)
                make.right.equalTo(-10)
                make.bottom.equalTo(-5)
            }
        }
        
    }
}


