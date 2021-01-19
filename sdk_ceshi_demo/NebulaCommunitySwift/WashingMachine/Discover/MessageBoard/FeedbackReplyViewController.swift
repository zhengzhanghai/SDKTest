//
//  FeedbackReplyViewController.swift
//  WashingMachine
//
//  Created by zzh on 2017/6/20.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

import UIKit

// 评论后的通知
internal let CommentReplySuccessNotifation = "CommentReplySuccessNotifation"
// 删除后的通知
internal let CommentDeleteSuccessNotifation = "CommentDeleteSuccessNotifation"

class FeedbackReplyViewController: NCTableListViewController {
    private let bottomHeight: CGFloat = 60
    var commentModel: CommentModel?
    var tableHeader: FeedbackReplyHeaderView!
    var replyView: FeedbackReplyView?
    var thumbsUpSuccessClourse: ((_ commentId: String, _ isLike: Bool, _ goodCount: Int)->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "详情"
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.makeBottomComplaint()
        self.configTableViewHeader()
        self.loadReplyList(.normal)
        NotificationCenter.default.addObserver(self, selector: #selector(commentReplySuccessNotifation), name: NSNotification.Name(rawValue: CommentReplySuccessNotifation), object: nil)
        tableView.snp.updateConstraints { (make) in
            make.bottom.equalTo(-bottomHeight)
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "three_point_black"), style: .plain, target: self, action: #selector(clickRightItem))
    }
    
    @objc func commentReplySuccessNotifation() {
        loadPage = 1
        loadReplyList(.normal)
    }
    
    private func makeBottomComplaint() {
        let complaintView = FeedbackComplainView(frame: CGRect.zero, "  有话就说，看对眼就上！")
        complaintView.clickComplaintClourse = { [unowned self] in
            windowRootView?.addSubview(self.replyView ?? self.createReplyView())
            self.replyView?.textView.becomeFirstResponder()
        }
        self.view.addSubview(complaintView)
        complaintView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(bottomHeight)
        }
    }
    
    private func createReplyView() -> FeedbackReplyView {
        replyView = FeedbackReplyView(frame: CGRect(x: 0, y: 0, width: BOUNDS_WIDTH, height: BOUNDS_HEIGHT))
        replyView?.cancelClourse = { [weak self] in
            self?.replyView?.removeFromSuperview()
        }
        replyView?.sendClourse = { [weak self] content in
            self?.replyView?.removeFromSuperview()
            self?.replyComment(content)
        }
        return replyView ?? FeedbackReplyView()
    }
    
    @objc func clickRightItem() {
        windowUserEnabled(false)
        let sheetVC = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let reportAction = UIAlertAction(title: "举报", style: .default) { (_) in
            self.popReportView()
        }
        let deleteAction = UIAlertAction(title: "删除", style: .default) { (_) in
            self.commentDelete(self.commentModel)
        }
        sheetVC.addAction(cancelAction)
        sheetVC.addAction(reportAction)
        sheetVC.addAction(deleteAction)
        self.present(sheetVC, animated: true) { 
            windowUserEnabled(true)
        }
    }
    
    func popReportView() {
        windowUserEnabled(false)
        let reportView = FeedbackReportView(frame: CGRect(x: 0, y: 0, width: BOUNDS_WIDTH, height: BOUNDS_HEIGHT))
        weak var weakView = reportView
        reportView.commitClourse = { (reportIds, reportContent) in
            self.commentReport(self.commentModel, reportId: reportIds.first ?? "", desp: reportContent)
            windowUserEnabled(false)
            reportView.hiddenWithAnimation({ 
                weakView?.removeFromSuperview()
                windowUserEnabled(true)
            })
        }
        reportView.cancelClourse = {
            windowUserEnabled(false)
            weakView?.hiddenWithAnimation({
                weakView?.removeFromSuperview()
                windowUserEnabled(true)
            })
        }
        windowRootView?.addSubview(reportView)
        reportView.showWithAnimation {
            windowUserEnabled(true)
        }
    }
    
    private func configTableViewHeader() {
        tableHeader = FeedbackReplyHeaderView(commentModel ?? CommentModel(), CGRect.zero)
        tableView.tableHeaderView = tableHeader
        tableHeader.clickLikeClorse = { [weak self] in
            self?.thumbsUp(self?.commentModel?.id?.stringValue ?? "", nil)
        }
        tableHeader.clickPhotoClourse = { [weak self] index in
            self?.presentPhotoBrower(index)
        }
        tableHeader.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.width.equalTo(BOUNDS_WIDTH)
            
        }
        self.tableView.layoutIfNeeded()
    }
    
    func presentPhotoBrower(_ index: Int) {
        let vc = PhotoBrowser(showByViewController: self, delegate: self)
        vc.pageControlDelegate = PhotoBrowserDefaultPageControlDelegate(numberOfPages: commentModel?.imageModels?.count ?? 0)
        vc.show(index: index)
    }
    
    override func pullDownRefresh() {
        super.pullDownRefresh()
        self.loadReplyList(.refresh)
    }
    
    override func pullUpMore() {
        super.pullUpMore()
        self.loadReplyList(.more)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

//MARK: --------------- UITableView  代理 ------------------
extension FeedbackReplyViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = FeedbackReplyTableViewCell.create(tableView: tableView, indexPath: indexPath)
        cell.config(dataSource[indexPath.row] as! CommentModel)
        cell.likeClourse = { [unowned self] (commitId, indexPa) in
            self.thumbsUp(commitId, indexPa)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let secHeaderLabel = UILabel()
        secHeaderLabel.frame = CGRect(x: 0, y: 0, width: BOUNDS_WIDTH, height: 40)
        secHeaderLabel.textAlignment = NSTextAlignment.center
        secHeaderLabel.font = UIFont.boldSystemFont(ofSize: 15)
        secHeaderLabel.textColor = UIColorRGB(51, 51, 51, 1)
        secHeaderLabel.text = "评论"
        secHeaderLabel.backgroundColor = UIColor.white
        return secHeaderLabel;
    }
}

//MARK: --------------- 查找项目在数据源的序列，查找项目在可视范围内的cell ------------------
extension FeedbackReplyViewController {
    func findIndexInDataSource(projectId: String) -> Int? {
        
        for (index , model) in (self.dataSource as! [CommentModel]).enumerated() {
            
            guard let modelId = model.id?.stringValue else { continue }
            
            if projectId == modelId {
                return index
            }
        }
        
        return nil
    }
    
    func findVisibleCell(projectId: String) -> FeedbackReplyTableViewCell? {
        
        guard let index = findIndexInDataSource(projectId: projectId) else {
            return nil
        }
        
        return findVisibleCell(indexPath: IndexPath(row: index, section: 0))
    }
    
    func findVisibleCell(indexPath: IndexPath) -> FeedbackReplyTableViewCell? {
        
        guard let indexPaths = self.tableView.indexPathsForVisibleRows else { return nil }
        
        guard indexPaths.contains(indexPath) else { return nil }
        
        return self.tableView.cellForRow(at: indexPath) as? FeedbackReplyTableViewCell
    }
}

extension FeedbackReplyViewController {
    func loadReplyList(_ loadWay: NCNetworkLoadWay) {
        let url = API_GET_COMMENT_LIST
            + "?userId=\(getUserId())"
            + "&commentId=\(commentModel?.id?.stringValue ?? "")"
            + "&page=\(loadPage)"
            + "&size=\(loadSize)"
            + "&schoolId=\(getUserSchoolId())"
        NetworkEngine.get(url, parameters: nil) { (result) in
            self.tableView.nc_endRefresh()
            guard (result.isSuccess || result.code == 204) else {
                self.resetListAndTableView()
                showError(result.message, superView: self.view)
                return
            }
            var models = [AnyObject]()
            if let list = result.dataObj["data"] as? [[String: AnyObject]] {
                for json in list {
                    models.append(CommentModel.cre(json))
                }
            }
            self.dealWithDataAndRefreshTable(loadWay, models)
        }
    }
    
    func replyComment(_ content: String) {
        let url = API_POST_REPLY_COMMENT
        var params = [String: String]()
        params["sendId"] = getUserId()
        params["content"] = content
        params["parentId"] = commentModel?.id?.stringValue ?? ""
        params["receiveId"] = "0"
        params["schoolId"] = getUserSchoolId()
        NetworkEngine.postJSON(url, parameters: params) { (result) in
            if result.isSuccess {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: CommentReplySuccessNotifation), object: nil)
                showSucccess("评论成功", superView: self.view, afterHidden: 1.3)
            } else {
                showError(result.message, superView: self.view, afterHidden: 1.3)
            }
        }
    }
    
    ///  点赞，如果 IndexPath == nil给留言点赞， 否则给留言回复点赞
    func thumbsUp(_ commitId: String, _ indexPath: IndexPath?) {
        let url = API_GET_COMMENT_THUMBS
            + "?commentId=" + commitId
            + "&userId=\(getUserId())"
        NetworkEngine.get(url, parameters: nil) { (result) in
            
            guard result.isSuccessOr204 else  {
                if indexPath == nil {
                    self.tableHeader.setLikeEnabled(true)
                } else {
                    (self.tableView.cellForRow(at: indexPath!) as? FeedbackReplyTableViewCell)?.setLikeEnabled(true)
                }
                
                showError(result.message, superView: self.view)
                return
            }
            
            
            if indexPath != nil {
                
                guard let index = self.findIndexInDataSource(projectId: commitId) else { return }
                guard let model = self.dataSource[index] as? CommentModel else { return }
                
                model.isGood = result.isSuccess as NSNumber
                model.goodCount = ((model.goodCount?.intValue ?? 0) + (result.isSuccess ? 1 : -1)) as NSNumber
                if (model.goodCount?.intValue ?? 0) < 0 {
                    model.goodCount = 0 as NSNumber
                }
                
                guard let cell = self.findVisibleCell(indexPath: IndexPath(row: index, section: 0)) else  { return }
                
                cell.setLikeEnabled(true)
                cell.setLikeBtnSelected(model.isGood?.boolValue ?? false)
                cell.setLikeCountText("\(model.goodCount?.intValue ?? 0)")
                
            } else {
                
                guard let model = self.commentModel else { return }
                
                model.isGood = result.isSuccess as NSNumber
                model.goodCount = ((model.goodCount?.intValue ?? 0) + (result.isSuccess ? 1 : -1)) as NSNumber
                if (model.goodCount?.intValue ?? 0) < 0 {
                    model.goodCount = 0 as NSNumber
                }
                
                self.tableHeader.setLikeEnabled(true)
                self.tableHeader.setLikeBtnSelected(model.isGood?.boolValue ?? false)
                self.tableHeader.setLikeCountText(model.goodCount?.stringValue)
                self.thumbsUpSuccessClourse?(commitId, result.isSuccess, model.goodCount?.intValue ?? 0)
            }

        }
    }
    
    func commentDelete(_ commentModel: CommentModel?) {
        if commentModel?.sendId?.stringValue != getUserId() {
            showError("只有本人才能删除", superView: self.view, afterHidden: 1.5)
            return
        }
        showWaitingView(self.view, "")
        let url = API_GET_COMMENT_DELETE + (commentModel?.id?.stringValue ?? "")
        NetworkEngine.get(url, parameters: nil) { (result) in
            self.hiddenWaitingView()
            if result.isSuccess {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: CommentDeleteSuccessNotifation), object: nil)
                showSucccess("删除成功", superView: appRootView ?? self.view, afterHidden: 1.5)
                self.navigationController?.popViewController(animated: true)
            } else {
                showError(result.message, superView: self.view, afterHidden: 1.5)
            }
        }
    }
    
    func commentReport(_ commentModel: CommentModel?, reportId: String, desp: String) {
        let url = API_POST_COMMENT_REPORT
        let dict = ["commenId": commentModel?.id?.stringValue ?? "",
                    "userId": getUserId(),
                    "reportType": reportId,
                    "desp": desp]
        showWaitingView(self.view, "")
        NetworkEngine.postJSON(url, parameters: dict) { (result) in
            self.hiddenWaitingView()
            if result.isSuccess {
                showSucccess("举报成功", superView: self.view, afterHidden: 1.5)
            } else {
                showSucccess(result.message, superView: self.view, afterHidden: 1.5)
            }
        }
        
    }
}

//MARK:  *********  PhotoBrowserDelegate  **********
extension FeedbackReplyViewController: PhotoBrowserDelegate {
    func numberOfPhotos(in photoBrowser: PhotoBrowser) -> Int {
        return commentModel?.imageModels?.count ?? 0
    }
    
    /// 缩放起始视图
    func photoBrowser(_ photoBrowser: PhotoBrowser, thumbnailViewForIndex index: Int) -> UIView? {
        return tableHeader.imageViews[index]
    }
    
    /// 图片加载前的placeholder
    func photoBrowser(_ photoBrowser: PhotoBrowser, thumbnailImageForIndex index: Int) -> UIImage? {
        return tableHeader.imageViews[index].image
    }
    
    /// 高清图
    func photoBrowser(_ photoBrowser: PhotoBrowser, highQualityUrlForIndex index: Int) -> URL? {
        let imageStr = commentModel?.imageModels?[index].url ?? ""
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
