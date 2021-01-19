//
//  NewsDetailsViewController.swift
//  WashingMachine
//
//  Created by zzh on 16/11/21.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//


import UIKit
import WebKit
import JavaScriptCore

fileprivate let jsCommentAction = "commentHandler"
fileprivate let jsPriseAction = "favoriteHandler"
fileprivate let jsNewsAction = "newsHandler"
fileprivate let jsNewsPriseAction = "newsPriseHandler"

fileprivate let bottomHeight: CGFloat = 50

class NewsDetailsViewController: BaseViewController {
    var newsModel: NewsModel?
    fileprivate var shareView: NCShareView?
    fileprivate var wkUserController: WKUserContentController?
    fileprivate var replyView: FeedbackReplyView?
    fileprivate var navBar:UIView? = nil
    fileprivate var isFinishLoadWeb = false
    fileprivate var recommendNewsArr = [NewsModel]()
    fileprivate var commentArr = [NewsComment]()
    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationItem.title = "资讯详情"
        self.makeWebView()
        self.loadRecommentNews()
        self.loadCommentList()
        self.configMoreBtn()
        self.showWaitingView(self.view)
        self.loadNewsDetails()
        addNoticationObserver(self, #selector(loginRefresh), LOGIN_SUCCESS_NOTIFICATION, nil)
    }
    
    @objc func loginRefresh() {
        self.loadNewsDetails()
        self.loadCommentList()
    }
    
    func refreshRecommendNews(_ noti: Notification) {
        if let newsModel = noti.userInfo?["newsModel"] as? NewsModel {
            for (index, model) in recommendNewsArr.enumerated() {
                if model.id?.intValue == newsModel.id?.intValue {
                    recommendNewsArr.remove(at: index)
                    recommendNewsArr.insert(newsModel, at: index)
                    return
                }
            }
        }
    }
    
    fileprivate func makeWebView() {
        let delegateController = WKDelegateController()
        delegateController.delegate = self
        wkUserController = WKUserContentController()
        wkUserController?.add(delegateController, name: jsCommentAction)
        wkUserController?.add(delegateController, name: jsPriseAction)
        wkUserController?.add(delegateController, name: jsNewsAction)
        wkUserController?.add(delegateController, name: jsNewsPriseAction)
        let wkConfiguration = WKWebViewConfiguration()
        wkConfiguration.userContentController = wkUserController!
        webView = WKWebView(frame: CGRect.zero, configuration: wkConfiguration)
        webView.allowsLinkPreview = true
        webView.alpha = 0
        webView.frame = CGRect(x: 0, y: 0, width: BOUNDS_WIDTH, height: contentHeightNoTop-bottomHeight)
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.load(self.getHtmlURL())
        webView.backgroundColor = UIColor.clear
        view.addSubview(webView)
        webView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
//            make.bottom.equalTo(-bottomHeight)
            make.bottom.equalToSuperview()
        }
    }
    
    private func configMoreBtn() {
        
        let moreItem = UIBarButtonItem(image:  #imageLiteral(resourceName: "three_point_black"), style: .plain, target: self, action: #selector(clickMoreBtn))
        self.navigationItem.rightBarButtonItem = moreItem
    }
    
    @objc fileprivate func clickMoreBtn() {
        let sheetVC = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let favoriteAction = UIAlertAction(title: "收藏", style: .default) { (_) in
            if isLogin() {
                self.newsOperat(.favorite)
            } else {
                LoginViewModel.pushLoginController(self)
            }
        }

        sheetVC.addAction(cancelAction)
        sheetVC.addAction(favoriteAction)
        DispatchQueue.main.async {
            self.present(sheetVC, animated: true, completion: { 
                
            })
        }
    }
    
    @objc private func clickShare() {
        windowRootView?.addSubview(shareView ?? createShareView())
        shareView?.showAnimation(nil)
    }
    
    fileprivate func makeBottomCommentView() {
        let commentView = FeedbackComplainView(frame: CGRect.zero, "  有想法就说，看对眼就上")
        commentView.clickComplaintClourse = { [weak self] in
            if isLogin() {
                windowRootView?.addSubview(self?.createReplyView() ?? FeedbackReplyView())
            } else {
                LoginViewModel.pushLoginController(self)
            }
        }
        self.view.addSubview(commentView)
        commentView.snp.makeConstraints { (make) in
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
            if isLogin() {
                self?.sendComment(content)
            } else {
                LoginViewModel.pushLoginController(self)
            }
        }
        return replyView ?? FeedbackReplyView()
    }
    
    private func createShareView() -> NCShareView {
        shareView = NCShareView(frame: CGRect(x: 0, y: 0, width: BOUNDS_WIDTH, height: BOUNDS_HEIGHT))
        shareView?.shareClourse = { [weak self] shareType in
            let share = WeChatShare()
            share.title = "星云社区"
            share.desp = "让校园生活更美好"
            share.webpageUrl = "https://nebulaedu.com/h5.html"
            share.image = UIImage(named: "logo")
            if shareType == .wxFriends {
                share.type = .friend
            } else if shareType == .wxCircleOfFriend {
                share.type = .circleFriend
            }
            WeChatManager.shareWebpage(share, notInstanceApp: {
                
            })
            self?.shareView?.animationHiddenAndRemoveFromSuperView()
        }
        return shareView!
    }
    
    fileprivate func setDetilasContent() {
        if newsModel != nil {
            var content = newsModel?.content ?? ""
            content = content.replacingOccurrences(of: "\r\n", with: "</br>")
            content = content.replacingOccurrences(of: "\"", with: "'")
            webView.evaluateJavaScript("setTitle('\(newsModel?.title ?? "")')", completionHandler: { (ss, error) in
                ZZPrint(ss)
                ZZPrint(error)
            })
            webView.evaluateJavaScript("setTitle('\(newsModel?.title ?? "")')", completionHandler: nil)
            webView.evaluateJavaScript("setContent(\"\(content)\")", completionHandler: nil)
            webView.evaluateJavaScript("setSource('编辑：\(newsModel?.createBy ?? "")')", completionHandler: nil)
            webView.evaluateJavaScript("setPuttime('\(timeStringFromTimeStampNotYear(timeStamp: (newsModel?.createTime ?? 0).doubleValue))')", completionHandler: nil)
            setNewsPriseCount(newsModel?.goodCount?.intValue ?? 0, newsModel?.isGood?.boolValue ?? false)
            webView.evaluateJavaScript("setFontSize\(String(describing: UserDefaults.standard.value(forKey: "fontSize")))", completionHandler: nil)
        }
    }
    
    // MARK: - 通知新类容页面的html格式化模板加载
    /**
     通知新类容页面的html格式化模板加载
     - returns: 返回一个URLRequest
     */
    fileprivate func getHtmlURL()->URLRequest {
        let filePath = Bundle.main.path(forResource: "news_detail", ofType: "html")
        let url = URL(fileURLWithPath: filePath!)
        let urlRequest = URLRequest(url:url)
        return urlRequest
    }
    
    fileprivate func addRecommendNewsList() {
        if !recommendNewsArr.isEmpty {
            for model in recommendNewsArr {
                insertNews(model)
            }
        }
    }
    
    fileprivate func addCommentList() {
        if !commentArr.isEmpty {
            deleteAllComment()
            for model in commentArr {
                insertComment(model)
            }
        }
    }
    
    deinit {
        wkUserController?.removeAllUserScripts()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

// MARK: 与webView相关的一些代理方法，及与JS间的交互
extension NewsDetailsViewController: WKNavigationDelegate, WKDelegateControllerDelegate, WKUIDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.hiddenWaitingView()
//        self.makeBottomCommentView()
        isFinishLoadWeb = true
        DispatchQueue.main.async {
            self.setDetilasContent()
            self.addRecommendNewsList()
            self.addCommentList()
            webView.alpha = 1
        }
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        switch message.name {
            case jsCommentAction:
                
                print("")
            case jsNewsAction:
                if let index = (message.body as? NSNumber)?.intValue {
                    NewsViewModel.pushNewDetails(recommendNewsArr[index], self, true)
                }
            case jsPriseAction:
                if let indexNum = message.body as? NSNumber {
                    let index = indexNum.intValue
                    if !isLogin() {
                        LoginViewModel.pushLoginController(self)
                        priseBtnAbled(index, true)
                    } else {
                        let model = commentArr[index]
                        self.commentPrise(index, model.id?.stringValue ?? "")
                    }
                }
            case jsNewsPriseAction:
                if isLogin() {
                    newsOperat(.prise)
                } else {
                    self.newsPriseBtnAbled(true)
                    LoginViewModel.pushLoginController(self)
                }
            
            default:
                print("")
        }
    }
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        ZZPrint(message)
        completionHandler()
    }
        
    //MARK: 与JS交互，向推荐新闻列表插入新闻
    func insertNews(_ model: NewsModel) {
        let titleStr = model.title ?? ""
        let timeStr = timeStringFromTimeStamp(timeStamp: (model.createTime?.doubleValue ?? 0))
        let imgStr = model.logo ?? ""
        webView.evaluateJavaScript("insertNewsElement('\(titleStr)','\(timeStr)','\(imgStr)')", completionHandler: nil)
    }
    //MARK: 与JS交互，向推荐新闻列表插入新闻
    func insertComment(_ model: NewsComment) {
        let headIcon = model.userPortrait ?? ""
        let userName = model.userAccountName ?? ""
        let timeStr = timeStringFromTimeStamp(timeStamp: (model.createTime?.doubleValue ?? 0))
        let isPrise = model.isGood?.intValue ?? 0
        let contentStr = model.content ?? ""
        let priseStr = model.goodCount?.stringValue ?? ""
        let commentStr = model.replyCount?.stringValue ?? ""
        webView.evaluateJavaScript("insertCommentElement('\(headIcon)','\(userName)','\(timeStr)',\(isPrise),'\(contentStr)','\(priseStr)','\(commentStr)')", completionHandler: nil)
    }
    //重新设置点赞数量
    func rebulidCommentCount(_ index: Int, _ commentCount: Int, _ isSupport: Bool) {
        webView.evaluateJavaScript("setPriseCount(\(index),'\(commentCount)', \(isSupport))", completionHandler: nil)
    }
    // 删除webView上所有评论
    func deleteAllComment() {
        webView.evaluateJavaScript("deleteAllComment()", completionHandler: nil)
    }
    // 设置点赞按钮是否能点击
    func priseBtnAbled(_ index: Int, _ abled: Bool) {
        let isAbled = abled.hashValue
        webView.evaluateJavaScript("priseUserActiviaty(\(index),\(isAbled))", completionHandler: nil)
    }
    func newsPriseBtnAbled(_ abled: Bool) {
        let isAbled = abled.hashValue
        webView.evaluateJavaScript("setNewsPriseAction(\(isAbled))", completionHandler: nil)
    }
    func setNewsPriseCount(_ count: Int, _ isSelected: Bool) {
        webView.evaluateJavaScript("setNewsPriseCount(\(count),\(isSelected.hashValue))", completionHandler: nil)
    }
}

//    MARK:加载网络数据
extension NewsDetailsViewController {
    func loadNewsDetails() {
        NewsViewModel.loadNewsDetails(newsModel?.id?.stringValue ?? "", getUserId()) { (model, message) in
            if let newsModel = model {
                self.newsModel = newsModel
                if self.isFinishLoadWeb {
                    self.setDetilasContent()
                }
            } else {
                showError(message, superView: self.view)
            }
        }
    }
    
    func loadRecommentNews() {
        NewsViewModel.loadNewsList(getUserId(), "1", "2", 1, "1", "3") { (models, message) in
            if let newModels = models {
                self.recommendNewsArr = newModels
                if self.isFinishLoadWeb {
                    self.addRecommendNewsList()
                }
            }
        }
    }
    
    func sendComment(_ content: String) {
        NewsViewModel.publishComment(newsModel?.id?.stringValue ?? "", getUserId(), content) { (isSuccess, message) in
            if isSuccess {
                self.deleteAllComment()
                self.loadCommentList()
            } else {
                showError(message, superView: self.view)
            }
        }
    }
    
    func loadCommentList() {
//        NewsViewModel.loadCommentList(newsModel?.id?.stringValue ?? "", getUserId(),"1", "1000") { (commentList, message) in
//            if let list = commentList {
//                self.commentArr = list
//                if self.isFinishLoadWeb {
//                    self.addCommentList()
//                }
//            }
//        }
    }
    
    func commentPrise(_ index: Int, _ commentId: String) {
        NewsViewModel.commentPrise(commentId, getUserId()) { (isSuccess, isError204, message) in
            
            guard isSuccess || isError204 else {
                showError(message, superView: self.view, afterHidden: 2)
                return
            }
            
            if isSuccess {
                let comment = self.commentArr[index]
                comment.goodCount = NSNumber(value: (comment.goodCount?.intValue ?? 0) + 1)
                self.rebulidCommentCount(index, comment.goodCount?.intValue ?? 0, true)
            } else if isError204 {
                let comment = self.commentArr[index]
                comment.goodCount = NSNumber(value: (comment.goodCount?.intValue ?? 0) - 1)
                self.rebulidCommentCount(index, comment.goodCount?.intValue ?? 0, false)
            }

            self.priseBtnAbled(index, true)
        }
    }
    
    func newsOperat(_ type: NewsPriseOrFavorite) {
        NewsViewModel.priseOrFavorite(newsModel?.id?.stringValue ?? "", getUserId(), type) { (isSuccess, isSure, count, message) in
            if isSuccess {
                postNotication(newsFavoriteAboutNotication, nil, nil)
                if type == .prise {
                    self.newsPriseBtnAbled(true)
                    self.newsModel?.goodCount = count
                    self.newsModel?.isGood = isSure
                    self.setNewsPriseCount(count.intValue, isSure.boolValue)
                } else {
                    self.newsModel?.isCollection = isSure
                }
            } else {
                if type == .prise {
                    self.newsPriseBtnAbled(true)
                }
            }
            showSucccess(message, superView: self.view)
        }
    }
}

