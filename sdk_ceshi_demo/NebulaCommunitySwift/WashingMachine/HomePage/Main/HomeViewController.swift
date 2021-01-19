

import UIKit
import CoreLocation
import MJRefresh
import Kingfisher
import Alamofire


public protocol HomeViewControllerReloadData {
    var tableViewReloadDataClourse: (()->())? { set get }
}

fileprivate let auxiliaryScrollViewTag = 34764
fileprivate let deviceMenuViewHeight: CGFloat = 44

extension HomeViewController {
    enum MenuDirection {
        case up
        case down
    }
}

//MARK: --------------- Class  HomeViewController ------------------

class HomeViewController: BaseViewController {
    
    /// 悬浮广告model
    fileprivate var adsSuspensionModel: ADSModel?
    /// 列表底部广告model
    fileprivate var adsListBottomModel: ADSModel?
    /// 当前蓝色菜单所处位置
    fileprivate var currentMenuDirection: MenuDirection = .down

    fileprivate lazy var topView: HomeTopView = {
        let view = HomeTopView()
        return view
    }()
    /// 两个自控制器视图承载器
    fileprivate lazy var contentScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.tag = auxiliaryScrollViewTag
        scrollView.isScrollEnabled = false
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentSize = CGSize(width: BOUNDS_WIDTH*2, height: 0)
        return scrollView
    }()
    /// 中间的菜单视图
    fileprivate lazy var deviceMenuView: HZFixationMenuView = {
        let deviceView = HZFixationMenuView(["当前", "订单"], true)
        deviceView.layoutType = .left
        deviceView.textFont = font_PingFangSC_Semibold(14)
        deviceView.textSelectedFont = font_PingFangSC_Semibold(18)
        deviceView.normalColor = UIColor(rgb: 0x999999)
        deviceView.selectedColor = UIColor(rgb: 0x333333)
        deviceView.lineColor = UIColor(rgb: 0x3399ff)
        deviceView.startMakeItem()
        return deviceView
    }()
    /// 订单历史控制器
    fileprivate lazy var orderHistoryVC: OrderHistoryViewController = {
        let vc = OrderHistoryViewController()
        vc.scrollMoveDirectionClourse = { [unowned self] direction in
//            self.topMenuMove(direction)
        }
        return vc
    }()
    /// 首页设备控制器
    fileprivate lazy var deviceVC: HomeDeviceViewController = {
        let vc = HomeDeviceViewController()
        vc.scrollMoveDirectionClourse = { [unowned self] direction in
//            self.topMenuMove(direction)
        }
        return vc
    }()
    /// 悬浮广告的视图
    fileprivate lazy var adsSuspensionView: UIView = {
        
        let bgView = UIView()
        
        let closeBtn = UIButton(type: .custom)
        closeBtn.setImage(#imageLiteral(resourceName: "close_cir"), for: .normal)
        closeBtn.addTarget(self, action: #selector(closeSuspensionADSView(_:)), for: .touchUpInside)
        bgView.addSubview(closeBtn)
        closeBtn.snp.makeConstraints({ (make) in
            make.top.right.equalToSuperview()
            make.width.height.equalTo(20)
        })
        
        let imageView = UIImageView()
        imageView.tag = 666
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.clipsToBounds = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickSuspensionADSGesture(_:))))
        
        bgView.addSubview(imageView)
        imageView.snp.makeConstraints({ (make) in
            make.top.equalTo(closeBtn.snp.bottom)
            make.right.equalTo(closeBtn.snp.left)
            make.width.equalTo(0)
            make.height.equalTo(0)
        })
        
        return bgView
    }()
    /// 底部广告视图
    fileprivate lazy var adsBottomView: UIView = {
        let bgView = UIView()
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.clipsToBounds = true
        imageView.tag = 666
        bgView.addSubview(imageView)
        imageView.snp.makeConstraints({ (make) in
            make.top.equalTo(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(0)
            make.height.equalTo(0)
        })
        
        let closeBtn = UIButton(type: .custom)
        closeBtn.setImage(#imageLiteral(resourceName: "close_black"), for: .normal)
        closeBtn.addTarget(self, action: #selector(closeBottomADSView(_:)), for: .touchUpInside)
        imageView.addSubview(closeBtn)
        closeBtn.snp.makeConstraints({ (make) in
            make.top.right.equalToSuperview()
            make.width.height.equalTo(30)
        })
        
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickBottomADSGesture(_:))))
        return bgView
    }()
    
    fileprivate var adsController: StartingADSController = {
        return StartingADSController()
    }()
    
    @objc fileprivate func closeSuspensionADSView(_ btn: UIButton) {
        animateRemoveSuspensionADSView()
    }
    
    /// 动画移除广告
    fileprivate func animateRemoveSuspensionADSView() {
        self.adsSuspensionView.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.5, animations: {
            self.adsSuspensionView.alpha = 0
        }) { (_) in
            self.adsSuspensionView.removeFromSuperview()
            self.adsSuspensionView.isUserInteractionEnabled = true
        }
    }
    
    @objc fileprivate func clickSuspensionADSGesture(_ tap: UITapGestureRecognizer) {
        animateRemoveSuspensionADSView()
        
        let adsWebVC = AdsWebViewController()
        adsWebVC.titleStr = self.adsSuspensionModel?.name ?? ""
        adsWebVC.urlStr = self.adsSuspensionModel?.redirectAddress ?? ""
        self.pushViewController(adsWebVC)
    }
    
    @objc fileprivate func closeBottomADSView(_ btn: UIButton) {
        animateRemoveBottomADSView()
    }
    
    /// 动画移除广告
    fileprivate func animateRemoveBottomADSView() {
        self.adsBottomView.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.5, animations: {
            self.adsBottomView.alpha = 0
        }) { (_) in
            self.deviceVC.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: BOUNDS_WIDTH, height: 20))
            self.adsBottomView.isUserInteractionEnabled = true
        }
    }
    
    @objc fileprivate func clickBottomADSGesture(_ tap: UITapGestureRecognizer) {
        animateRemoveBottomADSView()
        
        let adsWebVC = AdsWebViewController()
        adsWebVC.titleStr = self.adsListBottomModel?.name ?? ""
        adsWebVC.urlStr = self.adsListBottomModel?.redirectAddress ?? ""
        self.pushViewController(adsWebVC)
    }
    
    
    
    //MARK: --------------- viewWillAppear ------------------
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
            if self.adsSuspensionModel == nil {
                self.loadADS(1)
            }
            if self.adsListBottomModel == nil {
                self.loadADS(2)
            }
        }
        
        guard isLogin() else {
            /// 处理未登录的情况
            AuthSchool.clear()
            return
        }
        
        if isFirstViewWillAppear {
            /// 第一次进来，先显示缓存的信息，再从服务器获取用户认证的学校信息并更新
            if AuthSchool.isExist {
                self.topView.locationLabel.text = AuthSchool.name
            }
            self.loadSchoolMessage()
        } else {
            /// 非第一次进，如果缓存中没有才去从服务器获取用户认证信息
            if !AuthSchool.isExist {
                self.loadSchoolMessage()
            } else {
                self.topView.locationLabel.text = AuthSchool.name
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    //MARK: --------------- viewDidLoad ------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "洗衣"
        self.view.backgroundColor = BACKGROUNDCOLOR
        
        self.addGuidancePage()
        self.setNaviBar()
        self.makeUI()
        
        self.addEvent()
        
        self.addChildVC(deviceVC, 0)
                
        // 开启定位,并将定位信息存在NCLocation类属性和沙河中
        NCLocation.startLocation { (locationMessage, isNew) in
            // 当定位成功,并且缓存中没有用户认证信息,将定位地址显示
            if locationMessage.isSuccess && !AuthSchool.isExist {
                self.topView.locationLabel.text = locationMessage.address
            }
        }
    }
    
    /// 添加子控制器
    fileprivate func addChildVC(_ vc: BaseViewController, _ index: Int) {
        
        self.addChild(vc)
        vc.didMove(toParent: self)
        contentScrollView.addSubview(vc.view)
        vc.view.snp.makeConstraints { (make) in
            make.top.width.height.equalToSuperview()
            make.left.equalTo(BOUNDS_WIDTH*CGFloat(index))
        }
    }
    
    private func addGuidancePage() {
        // 判断该版本是否是第一次启动
        if let guideValue = UserDefaults.standard.value(forKey: guidePageViewControllerUserDefaultkey) as? String {
            if guideValue == guidePageViewControllerUserDefaultValue+HZApp.appVersion {
                self.adsController.showADS(self)
                return
            }
        }
        // 判断该版本是第一次启动，添加引导页
        let contentView = GuidePageContentView(frame: keyWindow.bounds)
        contentView.startUseClourse = { [weak self] in

        }
        keyWindow.addSubview(contentView)
    }
    
    fileprivate func setNaviBar() {
        // 取消导航栏半透明效果
        self.navigationController?.navigationBar.isTranslucent = false
        // 设置导航栏背景色
        self.navigationController?.navigationBar.barTintColor = .white
        // 设置导航栏上一些非自定义按钮颜色
        self.navigationController?.navigationBar.tintColor = .black
        // 设置导航栏标题文字颜色及字体
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor(rgb: 0x333333),
            NSAttributedString.Key.font:font_PingFangSC_Medium(14)
        ]
        
        // 取消导航栏分割线
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        
    }
    
    fileprivate func showSuspensionADSView(_ adsM: ADSModel) {
        
        /// 当悬浮广告在视图上，不再继续加载
        guard self.adsSuspensionView.superview == nil else { return }
        
        guard let url = URL(string: adsM.image) else { return }
        
        /// 下载图片
        KingfisherManager.shared.retrieveImage(with: url,
                                               options: [.transition(ImageTransition.fade(1))],
                                               progressBlock: nil)
        { (image, error, cacheType, url) in
            
            guard error == nil else {
                ZZPrint("download ads image error")
                return
            }
            
            guard let image = image else { return }
            
            self.adsSuspensionView.alpha = 0
            
            guard let imageView = self.adsSuspensionView.viewWithTag(666) as? UIImageView else { return }
            imageView.image = image
            
            self.view.addSubview(self.adsSuspensionView)
            
            var width = image.size.width
            var height = image.size.height
            if width > 85 || height > 85 {
                if width > height {
                    width = 85
                    height = image.size.height * width / image.size.width
                } else {
                    height = 85
                    width = image.size.width * height / image.size.height
                }
            }
            
            imageView.snp.updateConstraints({ (make) in
                make.width.equalTo(width)
                make.height.equalTo(height)
            })
            
            self.adsSuspensionView.snp.makeConstraints({ (make) in
                make.right.equalTo(-10)
                make.bottom.equalTo(-TABBAR_HEIGHT-20)
                make.width.equalTo(width+20)
                make.height.equalTo(height+20)
            })
            
            self.adsSuspensionView.isUserInteractionEnabled = false
            UIView.animate(withDuration: 0.5, animations: {
                self.adsSuspensionView.alpha = 1
            }, completion: { (_) in
                self.adsSuspensionView.isUserInteractionEnabled = true
            })
        }
    }
    
    fileprivate func showBottomAdsView(_ adsM: ADSModel) {
        /// 当底部广告在视图上，不再继续加载
        guard self.adsBottomView.superview == nil else { return }
        
        guard let url = URL(string: adsM.image) else { return }
        /// 下载图片
        KingfisherManager.shared.retrieveImage(with: url,
                                               options: [.transition(ImageTransition.fade(1))],
                                               progressBlock: nil)
        { (image, error, cacheType, url) in
            
            guard error == nil else {
                ZZPrint("download ads image error")
                return
            }
            
            guard let image = image else { return }
            
            self.adsBottomView.alpha = 0
            guard let imageView = self.adsBottomView.viewWithTag(666) as? UIImageView else {
                return
            }
            imageView.image = image
            
            let imageViewWidth = image.size.width > BOUNDS_WIDTH-30 ? BOUNDS_WIDTH-30 : image.size.width
            let imageViewHeight = image.size.height * imageViewWidth / image.size.width
            imageView.snp.updateConstraints({ (make) in
                make.width.equalTo(imageViewWidth)
                make.height.equalTo(imageViewHeight)
            })
            
            self.adsBottomView.frame = CGRect(x: 0, y: 0, width: BOUNDS_WIDTH, height: imageViewHeight+40)
            
            self.deviceVC.tableView.tableFooterView = self.adsBottomView
            
            self.adsBottomView.isUserInteractionEnabled = false
            UIView.animate(withDuration: 0.5, animations: {
                self.adsBottomView.alpha = 1
            }, completion: { (_) in
                self.adsBottomView.isUserInteractionEnabled = true
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}


//MARK: ------- 有关UI的创建 -------
fileprivate extension HomeViewController {
    func makeUI() {
        
        view.addSubview(topView)
        topView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
        }
        
        view.addSubview(contentScrollView)

        contentScrollView.snp.makeConstraints { (make) in
            make.top.equalTo(self.topView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(-TABBAR_HEIGHT)
        }
        
    }
}

//MARK: --------------- 事件相关 -------------------

fileprivate extension HomeViewController {
    func addEvent() {
        // 点击扫描设备
        topView.scanClosure = { [unowned self] in
            guard isLogin() else {
                LoginViewModel.pushLoginController(self)
                return
            }
            DeviceViewModel.pushScanVC(self)
        }
        // 点击附近设备
        topView.nearbyDeviceClosure = { [unowned self] in
            guard isLogin() else {
                LoginViewModel.pushLoginController(self)
                return
            }
            DeviceViewModel.pushNebyFloorVC(AuthSchool.id, self)
        }
        // 点击地址
        topView.clickAddressClourse = { [unowned self] in
            if isLogin() {
                let vc = SchoolAccreditationController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                LoginViewModel.pushLoginController(self)
            }
        }
        // 点击通知
        topView.clickNoticeClourse = { [unowned self] in
            if isLogin() {
                let vc = NoticeCenterViewController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                LoginViewModel.pushLoginController(self)
            }
        }
        // 点击当前或者历史
        topView.pageMenuView.didSelectedItem = { [unowned self] index in
            UIView.animate(withDuration: 0.2) {
                self.contentScrollView.contentOffset = CGPoint(x: CGFloat(index) * BOUNDS_WIDTH, y: 0)
            }
            if index == 1 {
                // 如果已经添加，不再往后执行
                if self.children.contains(orderHistoryVC) { return }
                self.addChildVC(orderHistoryVC, index)
            }
        }
    }
}

//MARK: --------------- 网络请求 ------------------
fileprivate extension HomeViewController {
    
    /// 获取认证的学校信息
    func loadSchoolMessage() {
        MeViewModel.loadAuthenticationSchool(getUserId()) { (authSchool, message) in
            if let schoolId = authSchool?.schoolId {
                
                let schoolName = authSchool?.schoolName ?? ""
                
                AuthSchool.modifyAndSave(schoolId, schoolName)
                
                self.topView.locationLabel.text = schoolName
            }
        }
    }
    
    
    /// 获取广告， 并处理获取的广告结果
    ///
    /// - Parameter type: 1 ,首页右下角  2：首页底部
    func loadADS(_ type: Int) {
        let url = API_GET_ADS
        /// location 0:启动页 1:首页右下角 2:首页底部 3:运行中的订单详情页
        let parameters = ["location": type]
        NetworkEngine.get(url, parameters: parameters) { (result) in
            
            guard result.isSuccess else { return }
            guard let dataDict = (result.dataObj as? [String: AnyObject])?["data"] as? [String: Any] else { return }
            guard let model = ADSModel.create(withDict: dataDict) else { return }
            
            if type == 1 {
                self.adsSuspensionModel = model
                self.showSuspensionADSView(model)
            } else if type == 2 {
                self.adsListBottomModel = model
                self.showBottomAdsView(model)
            }
        }
    }
}

