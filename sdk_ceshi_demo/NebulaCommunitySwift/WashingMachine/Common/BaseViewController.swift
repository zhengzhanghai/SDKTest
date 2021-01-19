//
//  BaseViewController.swift
//  WashingMachine
//
//  Created by zzh on 16/10/27.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//
//  导航栏带返回按钮
//
import UIKit
import MBProgressHUD
class BaseViewController: UIViewController {
    
    /// 如果存在导航控制器，移除该控制器导航控制器下的往前的控制器数量
    var removeControllerCount = 0
    /// 内存警告次数
    var memoryWarningCount = 0
    /// 进入该控制器次数(如果该控制器销毁，将重计)，以viewDidAppear方法为准
    var enterCount: Int = 0
    /// viewWillAppear 调用次数
    fileprivate(set) var viewWillAppearCount: Int = 0
    /// viewDidAppear 调用次数
    fileprivate(set) var viewDidAppearCount: Int = 0
    
    fileprivate var loadingView: MBProgressHUD!
    fileprivate var loadingCount = 0
    
    var isFirstViewWillAppear: Bool {
        return (viewWillAppearCount <= 1)
    }
    
    var isFirstViewDidAppear: Bool {
        return (viewDidAppearCount <= 1)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        }
        return .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reSetNavigationBackBarButtonItem()
        
        view.backgroundColor = UIColor.white
        removeNaviSubController()
        
        ZZPrint("\n------------------   token  --------------\n"
            + UserInfoModel.newUserId()
            + "\n"
            + UserInfoModel.newToken()
            + "\n------------------   token  --------------")
    }
    
    /// 设置上一个导航栏控制器的返回按钮
    func reSetNavigationBackBarButtonItem() {
        guard let naviControllers = navigationController?.viewControllers else { return }
        guard let index = naviControllers.index(of: self) else { return }
        guard (index-1 >= 0) && (index-1 < naviControllers.count-1) else { return }
        let previousVC = naviControllers[index-1]
        
        // 去掉导航栏返回按钮文字，并使用新的返回按钮图标
        let item = UIBarButtonItem(image: UIImage(named: "nav_back"), style: .plain, target: self, action: nil)
        previousVC.navigationItem.backBarButtonItem = item
        
        // 去掉导航栏返回按钮系统默认的箭头
        self.navigationController?.navigationBar.backIndicatorImage = UIImage()
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewWillAppearCount += 1
                
        keyWindowUserInteractionEnabled(false)
        if let scrollView = self.view.subviews.first as? UIScrollView {
            scrollView.nc_hiddenRefreshHeader(true)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        keyWindowUserInteractionEnabled(true)
        
        viewDidAppearCount += 1
        
        if let scrollView = self.view.subviews.first as? UIScrollView {
            scrollView.nc_hiddenRefreshHeader(false)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        keyWindowUserInteractionEnabled(false)
        if let scrollView = self.view.subviews.first as? UIScrollView {
            scrollView.nc_hiddenRefreshHeader(true)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super .viewDidDisappear(animated)
        keyWindowUserInteractionEnabled(true)
        if let scrollView = self.view.subviews.first as? UIScrollView {
            scrollView.nc_hiddenRefreshHeader(false)
        }
    }
    
    fileprivate func removeNaviSubController() {
        if removeControllerCount > 0 {
            if var subControllers = self.navigationController?.viewControllers {
                for _ in 0 ..< removeControllerCount {
                    subControllers.remove(at: subControllers.count-2)
                }
                self.navigationController?.viewControllers = subControllers
            }
        }
    }
    
    @objc func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        memoryWarningCount += 1
    }
    
    // MARK: - 加载菊花
    /**
     * 展示等待加载
     */
    func showWaitingView(_ superView: UIView, _ message: String = "") {
        if loadingView == nil {
            self.createLoadingView(superView, message)
        }
        loadingCount = loadingCount + 1
    }
    
    /**
     * 隐藏等待加载
     */
    func hiddenWaitingView() {
        if loadingCount > 0 {
            loadingCount = loadingCount - 1
        }
        if loadingCount == 0 {
            loadingView?.hide(animated: true)
            loadingView = nil
        }
    }
    
    fileprivate func createLoadingView(_ superView: UIView, _ message: String) {
        loadingView = MBProgressHUD.showAdded(to: superView, animated: true)
        loadingView!.label.text = message
        loadingView?.label.font = UIFont.systemFont(ofSize: 16.0)
        loadingView?.margin = 20.0
        loadingView?.removeFromSuperViewOnHide = true
        loadingView?.contentColor = UIColor.white
        loadingView?.bezelView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
    
    // 提示，只有确定按钮，无其他操作
    func alertSurePrompt(message: String?, sureAction: ((UIAlertAction) -> Void)? = nil) {
        if message == nil {
            return
        }
        let alertVC = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
        let sureAction = UIAlertAction(title: "确定", style: .default, handler: sureAction)
        alertVC.addAction(sureAction)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    /// 所属导航控制器push控制器
    ///
    /// - Parameters:
    ///   - vc: 控制器
    ///   - hidesBottomBar: 是否隐藏tabbar，默认true
    ///   - animated: 是否展示动画，默认true
    func pushViewController(_ vc: UIViewController, hidesBottomBar: Bool = true, animated: Bool = true) {
        vc.hidesBottomBarWhenPushed = true
        if let navc = vc as? UINavigationController {
            navc.pushViewController(vc, animated: animated)
        } else {
            self.navigationController?.pushViewController(vc, animated: animated)
        }
    }
    
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        viewControllerToPresent.modalPresentationStyle = .fullScreen
        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        ZZPrint("------ deinit ------ \n"
            + (NSStringFromClass(self.classForCoder).components(separatedBy: ".").last ?? "deinit")
            + "\n-------------------")
    }
}
