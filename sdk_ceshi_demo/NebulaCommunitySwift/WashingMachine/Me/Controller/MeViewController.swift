//
//  MeViewController.swift
//  WashingMachine
//
//  Created by Moguilay on 2016/10/25.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

import UIKit

let notificationInfoRefresh = "notificationInfoRefresh"
///// cell标题数组
//fileprivate let meTitles = ["消息中心", "我的收藏", "学校认证", "常见问题", "推荐给好友", "设置", "服务条款"]
///// cell  Icon 数组
//fileprivate let meIcons = ["me_message","me_favorite","school","me_common_problem","me_share","me_setting", "me_terms_of_service"]
///// cell 标题 对应的VC
//fileprivate func cellSkipViewController(title: String) -> BaseViewController? {
//    switch title {
//    case "消息中心": return  NoticeCenterViewController()
//    case "学校认证": return  SchoolAccreditationController()
//    case "意见反馈": return  FeedBackViewController()
//    case "常见问题": return  CommonProblemViewController()
//    case "我的收藏": return  MyFavoriteNewsViewController()
//    case "绑定账号": return  AuthTradingAccountViewController()
//    case "服务条款": return  TeamOfServiceViewController()
//    default:       return nil
//    }
//}

/// cell标题数组
fileprivate let meTitles = ["我的钱包", "消息中心", "我的收藏", "学校认证", "常见问题", "推荐给好友", "设置", "服务条款"]
/// cell  Icon 数组
fileprivate let meIcons = ["me_wallet", "me_message","me_favorite","school","me_common_problem","me_share","me_setting", "me_terms_of_service"]
/// cell 标题 对应的VC
fileprivate func cellSkipViewController(title: String) -> BaseViewController? {
    switch title {
    case "我的钱包": return  StarCoinsViewController()
    case "消息中心": return  NoticeCenterViewController()
    case "学校认证": return  SchoolAccreditationController()
    case "意见反馈": return  FeedBackViewController()
    case "常见问题": return  CommonProblemViewController()
    case "我的收藏": return  MyFavoriteNewsViewController()
    case "绑定账号": return  AuthTradingAccountViewController()
    case "服务条款": return  TeamOfServiceViewController()
    default:       return nil
    }
}

class MeViewController: BaseViewController {

    /// 分享视图
    fileprivate var shareView: NCShareView?
    /// 包括用户名头像及其背景图
    fileprivate lazy var tableHeaderView: MeTableHeaderView = {
        let header = MeTableHeaderView(frame: CGRect(x: 0,y: 0,width: BOUNDS_WIDTH,height: BOUNDS_WIDTH*51/75))
        header.clickHeadPortraitClourse = { [unowned self] in
            if isLogin() {
                self.pushProfileVC()
            } else {
                self.pushLoginVC()
//                self.jumpToLoginVC()
            }
        }
        return header
    }()
    fileprivate lazy var tableView: UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .plain)
        table.register(UINib.init(nibName: "MeCell", bundle: nil), forCellReuseIdentifier: "MeCell")
        table.delegate = self
        table.dataSource = self
        table.sectionHeaderHeight = 0.1
        table.tableHeaderView = tableHeaderView
        table.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 30))
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNaviBar()
        self.view.backgroundColor = UIColor(rgb: 0xf9f9f9)
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints({ (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-TABBAR_HEIGHT)
        })
        
        refreshProfileFromLocal()
        
        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        addNoticationObserver(self, #selector(pushOrderVC), "gotoOrderListVC", nil)
        addNoticationObserver(self, #selector(loadInfo), notificationInfoRefresh, nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.refreshProfileFromLocal()
        self.loadInfo()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    fileprivate func setNaviBar() {
        // 取消导航栏半透明效果
        self.navigationController?.navigationBar.isTranslucent = false
        // 设置导航栏背景色
        self.navigationController?.navigationBar.barTintColor = THEMECOLOR
        // 设置导航栏上一些非自定义按钮颜色
        self.navigationController?.navigationBar.tintColor = UIColor.white
        // 设置导航栏标题文字颜色及字体
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
                                                                        NSAttributedString.Key.font:UIFont.systemFont(ofSize: 18)]
        // 取消导航栏分割线
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
    }
    
    /// 模拟懒加载分享视图
    fileprivate func lazyShareView() -> NCShareView {
        if shareView == nil {
            shareView = NCShareView(frame: CGRect(x: 0, y: 0, width: BOUNDS_WIDTH, height: BOUNDS_HEIGHT))
            shareView?.shareClourse = { [weak self] type in
                self?.shareApp(type)
            }
        }
        return shareView!
    }
    
    /// 分享应用
    fileprivate func shareApp(_ type: NCShareViewType) {
        let share = WeChatShare()
        share.title = "星云社区"
        share.desp = "让校园生活更美好"
        share.webpageUrl = "https://nebulaedu.com/h5.html"
        share.image = UIImage(named: "logo")
        switch type {
            case .wxFriends:
                share.type = .friend
            case .wxCircleOfFriend:
                share.type = .circleFriend
        }
        WeChatManager.shareWebpage(share, notInstanceApp: {
            
        })
        shareView?.animationHiddenAndRemoveFromSuperView()
    }
    
    /**
     重新获取用户数据刷新
     */
    //获取用户资料  刷新数据
    @objc fileprivate func loadInfo() {
        if !isLogin() {
            self.tableHeaderView.logoutRefresh()
            return
        }
        
        MeViewModel.loadUserInfo(getUserId()) { (isNormalVisit, baseInfo, message) in
            if isNormalVisit && baseInfo != nil {
                baseInfo?.writeLocal()
                NotificationCenter.default.post(name: Notification.Name(rawValue: LOGIN_SUCCESS_NOTIFICATION), object: nil)
                self.refreshProfileFromLocal()
            }
        }
    }
    
    /// 跳转到登录页
    fileprivate func pushLoginVC() {
        let loginVC = LoginViewController()
        loginVC.passClosures = {() in
            self.refreshProfileFromLocal()
        }
        loginVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
    
    /// 跳转自登录页
    fileprivate func jumpToLoginVC() {
        let vc = LoginRegisterNavigationController.create()
        vc.loginViewController.passClosures = {() in
            self.refreshProfileFromLocal()
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    /// 跳转到个人资料页,及个人资料页的回调
    fileprivate func pushProfileVC() {
        let PersonalInfoVC = PersonalInfoTableViewController()
        PersonalInfoVC.blockClourse = { () in
            self.refreshProfileFromLocal()
        }
        //个人页上传头像后，更新
        PersonalInfoVC.getImageClourse = { () in
            self.refreshProfileFromLocal()
        }
        PersonalInfoVC.getNickNameClourse = { () in
            self.refreshProfileFromLocal()
        }
        PersonalInfoVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(PersonalInfoVC, animated: true)
    }
    
    /// 跳转到订单页
    @objc fileprivate func pushOrderVC() {
        let vc = AllOrderViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    /// 根据本地存储的用户信息刷新UI
    fileprivate func refreshProfileFromLocal() {
        let userModel = UserBaseInfoModel.readFromLocal()
        tableHeaderView.config(userModel.portrait, userModel.nickName)
    }
}

//MARK: UITableViewDelegate,  UITableViewDataSource
extension MeViewController: UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meTitles.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MeCell", for: indexPath) as? MeCell
        cell?.imgView?.image = UIImage(named: meIcons[indexPath.row])
        cell?.titleLabel?.text = meTitles[indexPath.row]
        cell?.selectionStyle = .none
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let title = meTitles[indexPath.row]
        if title == "设置" {
            let vc = SettingViewController()
            vc.blockClourse = { () in
                self.tableHeaderView.logoutRefresh()
            }
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        } else if title == "推荐给好友" {
            appRootView?.addSubview(lazyShareView())
            shareView?.showAnimation(nil)
            ZZPrint("推荐给好友")
        } else {
            if !isLogin() {
                pushLoginVC()
//                jumpToLoginVC()
                return
            }
            
            guard let vc = cellSkipViewController(title: title) else { return }
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
