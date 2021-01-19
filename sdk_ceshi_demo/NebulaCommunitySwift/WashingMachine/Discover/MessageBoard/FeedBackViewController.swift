
import UIKit

class FeedBackViewController: NCTableListViewController {
    fileprivate let bottomHeight: CGFloat = 60
    fileprivate var sepLine: UIView?

    fileprivate lazy var bottomView: FeedbackComplainView = {
        let complaintView = FeedbackComplainView(frame: CGRect.zero, "  我想说......")
        complaintView.clickComplaintClourse = { [unowned self] in
            if isLogin() {
                let vc = PublishComplaintController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                LoginViewModel.pushLoginController(self)
            }

        }
        return complaintView
    }()
    
    /// 记录点击图片所属model
    fileprivate var photoBrawerCommendModel : CommentModel?
    /// 记录当前点击的图片所属的cell
    fileprivate var photoCell : MessageBoardCell?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "留言板"
        self.loadCommentList()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshListNotifationAction), name: NSNotification.Name(rawValue: CommentReplySuccessNotifation), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshListNotifationAction), name: NSNotification.Name(rawValue: publishCommentSuccessNotifation), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshListNotifationAction), name: NSNotification.Name(rawValue: CommentDeleteSuccessNotifation), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshListNotifationAction), name: NSNotification.Name(rawValue: LOGIN_SUCCESS_NOTIFICATION), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshListNotifationAction), name: NSNotification.Name(rawValue: LOGIN_OUT_NOTIFICATION), object: nil)

        view.addSubview(bottomView)
        bottomView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(bottomHeight)
            if is_iPhoneX {
                make.bottom.equalTo(-34)
            } else {
                make.bottom.equalToSuperview()
            }
        }
        MessageBoardCell.register(toTabeView: tableView)
        tableView.snp.remakeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(self.bottomView.snp.top)
        }

    }

    // 刷新列表的通知事件
    @objc func refreshListNotifationAction() {
        loadPage = 1
        loadCommentList(.normal)
    }

    override func pullDownRefresh() {
        super.pullDownRefresh()
        loadCommentList(.refresh)
    }

    override func pullUpMore() {
        super.pullUpMore()
        loadCommentList(.more)
    }

    func pushCommentDetailsVC(indexPath: IndexPath) {
        let replyVC = FeedbackReplyViewController()
        replyVC.hidesBottomBarWhenPushed = true
        if let model = dataSource[indexPath.row] as? CommentModel {
            replyVC.commentModel = model
        }
        replyVC.thumbsUpSuccessClourse = { (commentId, isSupport, goodCount) in
            
            guard let index = self.findIndexInDataSource(projectId: commentId) else { return }
            
            guard let model = self.dataSource[index] as? CommentModel else { return }
            
            model.isGood = isSupport as NSNumber
            model.goodCount = goodCount as NSNumber
            
            if (model.goodCount?.intValue ?? 0) < 0 {
                model.goodCount = 0 as NSNumber
            }
            
            guard let cell = self.findVisibleCell(indexPath: IndexPath(row: index, section: 0)) else { return }
            cell.setLikeBtnSelected(isSupport)
            cell.setLikeCountText("\(goodCount)")
            
        }
        self.navigationController?.pushViewController(replyVC, animated: true)
    }

    func presentPhotoBrower(_ index: Int) {
        let vc = PhotoBrowser(showByViewController: self, delegate: self)
        vc.pageControlDelegate = PhotoBrowserDefaultPageControlDelegate(numberOfPages: photoBrawerCommendModel?.imageModels?.count ?? 0)
        vc.show(index: index)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

//MARK: **********  tableViewDelegate,tableViewDatasourse  *********
extension FeedBackViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return MessageBoardCell.create(tableView, indexPath)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (self.dataSource[indexPath.row] as! CommentModel).cellHeight
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let messageBoardCell = cell as? MessageBoardCell else {
            return
        }
        
        messageBoardCell.config(self.dataSource[indexPath.row] as! CommentModel)
        
        /// 点赞回调
        messageBoardCell.likeClourse = { [unowned self] (commentId, inPath) in
            if isLogin() {
                self.thumbsUp(commentId, inPath)
            } else {
                messageBoardCell.setLikeEnabled(true)
                LoginViewModel.pushLoginController(self)
            }
        }
        /// 点击cell上图片回调
        messageBoardCell.clickImageClourse = { [unowned self] (index, cell, commentModel) in
            self.photoBrawerCommendModel = commentModel
            self.photoCell = cell
            self.presentPhotoBrower(index)
            ZZPrint("（已回调到控制器）点击了cell上的图片:  \(index)")
        }
        /// 点击更多评论回调
        messageBoardCell.moreReplyClourse = { [unowned self] (commentId) in
            if isLogin() {
                self.pushCommentDetailsVC(indexPath: indexPath)
            } else {
                LoginViewModel.pushLoginController(self)
            }
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isLogin() {
            pushCommentDetailsVC(indexPath: indexPath)
        } else {
            LoginViewModel.pushLoginController(self)
        }
    }
}

//MARK: --------------- 查找项目在数据源的序列，查找项目在可视范围内的cell ------------------
extension FeedBackViewController {
    func findIndexInDataSource(projectId: String) -> Int? {
        
        for (index , model) in (self.dataSource as! [CommentModel]).enumerated() {
            
            guard let modelId = model.id?.stringValue else { continue }
            
            if projectId == modelId {
                return index
            }
        }
        
        return nil
    }
    
    func findVisibleCell(projectId: String) -> MessageBoardCell? {
        
        guard let index = findIndexInDataSource(projectId: projectId) else {
            return nil
        }
        
        return findVisibleCell(indexPath: IndexPath(row: index, section: 0))
    }
    
    func findVisibleCell(indexPath: IndexPath) -> MessageBoardCell? {
        
        guard let indexPaths = self.tableView.indexPathsForVisibleRows else { return nil }
        
        guard indexPaths.contains(indexPath) else { return nil }
        
        return self.tableView.cellForRow(at: indexPath) as? MessageBoardCell
    }
}

//MARK: 网络请求相关 ************
extension FeedBackViewController {
    func loadCommentList(_ loadWay: NCNetworkLoadWay = .normal) {
        showWaitView(loadWay, self.view)
        let url = API_GET_COMMENT_LIST + "?userId=\(getUserId())" + "&page=\(loadPage)" + "&size=\(loadSize)" + "&schoolId=\(getUserSchoolId())"
        NetworkEngine.get(url, parameters: nil) { (result) in
            self.hiddenWaitingView(loadWay)
            self.tableView.nc_endRefresh()

            guard result.isSuccess || result.code == 204 else {
                //  如果数据异常,重置数据和列表
                self.resetListAndTableView()
                showError(result.message, superView: self.view)
                return
            }
            var models = [AnyObject]()
            if let list = result.dataObj["data"] as? [[String: AnyObject]] {
                for json in list {
                    let model = CommentModel.cre(json)
                    model.calculateCellHeight()
                    models.append(model)
                }
                self.dealWithDataAndRefreshTable(loadWay, models)
            }
        }
    }

    func thumbsUp(_ commitId: String, _ indexPath: IndexPath) {

        let url = API_GET_COMMENT_THUMBS
            + "?commentId=" + commitId
            + "&userId=\(getUserId())"
        NetworkEngine.get(url, parameters: nil) { (result) in
            
            
            guard result.isSuccessOr204 else {
                self.findVisibleCell(projectId: commitId)?.setLikeEnabled(true)
                showError(result.message, superView: self.view)
                return
            }
            
            func updateDataAndTable(isLike: Bool) {
                
                guard let index = self.findIndexInDataSource(projectId: commitId) else { return }
                
                guard let model = self.dataSource[index] as? CommentModel else { return }
                
                model.isGood = isLike as NSNumber
                model.goodCount = NSNumber(value: (model.goodCount?.intValue ?? 0) + (isLike ? 1 : -1))
                if (model.goodCount?.intValue ?? 0) < 0 {
                    model.goodCount = 0 as NSNumber
                }
                
                guard let cell = self.findVisibleCell(indexPath: IndexPath(row: index, section: 0)) else { return }
                
                cell.setLikeEnabled(true)
                cell.setLikeCountText(model.goodCount?.stringValue)
                cell.setLikeBtnSelected(isLike)
            }
            
            if result.isSuccess {
                
                showSucccess("点赞成功", superView: self.view)
                updateDataAndTable(isLike: true)
                
            } else if result.isError204 {

                showError(result.message, superView: self.view)
                updateDataAndTable(isLike: false)
                
            }
//
//            /// 根据id到数据源中匹配
//            for (index , model) in (self.dataSource as! [CommentModel]).enumerated() {
//
//                guard let modelId = model.id?.stringValue else { continue }
//
//                if modelId == commitId {
//
//                    let inPath = IndexPath(row: index, section: 0)
//                    let cell = self.tableView.cellForRow(at: inPath) as? MessageBoardCell
//                    cell?.setLikeEnabled(true)
//
//                    if result.isSuccess {
//                        model.isGood = 1
//                        model.goodCount = NSNumber(value: (model.goodCount?.intValue ?? 0) + 1)
//                        cell?.setLikeCountText(model.goodCount?.stringValue)
//                        cell?.setLikeBtnSelected(true)
//                        showSucccess("点赞成功", superView: self.view)
//                    } else {
//                        showError(result.message, superView: self.view)
//                    }
//
//                    break
//                }
//            }
        }
    }
}

//MARK:  *********  PhotoBrowserDelegate  **********
extension FeedBackViewController: PhotoBrowserDelegate {
    func numberOfPhotos(in photoBrowser: PhotoBrowser) -> Int {
        return photoBrawerCommendModel?.imageModels?.count ?? 0
    }

    /// 缩放起始视图
    func photoBrowser(_ photoBrowser: PhotoBrowser, thumbnailViewForIndex index: Int) -> UIView? {
        return photoCell?.imageViewArray[index]
    }

    /// 图片加载前的placeholder
    func photoBrowser(_ photoBrowser: PhotoBrowser, thumbnailImageForIndex index: Int) -> UIImage? {
        return photoCell?.imageViewArray[index].image
    }

    /// 高清图
    func photoBrowser(_ photoBrowser: PhotoBrowser, highQualityUrlForIndex index: Int) -> URL? {
        let imageStr = photoBrawerCommendModel?.imageModels?[index].url ?? ""
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


