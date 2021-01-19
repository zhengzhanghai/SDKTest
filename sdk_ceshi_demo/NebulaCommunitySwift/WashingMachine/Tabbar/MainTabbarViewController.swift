//
//  MainTabbarViewController.swift
//  TabbarTest
//
//  Created by 郑章海 on 2020/12/10.
//

import UIKit

class MainTabbarViewController: UITabBarController {
    
    let homeVC = HomeViewController()
    let discoverVC = DiscoverViewController()
    let meVC = MeViewController()
    let adsWebVC = DiscoverADSViewController()
    /// 是否展示
    var canShowADS = false
    
    lazy var mainView: MainTabbarView = {
        let view = MainTabbarView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupChildVC()
        addEvent()
    }
    
    func changeToADSPageFromDiscover(adsURL: URL, itemTitle: String, itemImage: UIImage) {
        canShowADS = true
        adsWebVC.url = adsURL
        mainView.changeToAdsItemFromDiscoverItem(title: itemTitle, image: itemImage)
        var controllers = viewControllers
        controllers?.remove(at: 1)
        viewControllers = controllers
    }
    
    func setupChildVC() {
        homeVC.tabBarItem.title = "首页"
        discoverVC.tabBarItem.title = "发现"
        meVC.tabBarItem.title = "我的"
        
        viewControllers = [
            MianNavigationController(rootViewController: homeVC),
            MianNavigationController(rootViewController: discoverVC),
            MianNavigationController(rootViewController: meVC)
        ]
    }
    
    func setupUI() {
        tabBar.addSubview(mainView)
    }
    
    override func viewDidLayoutSubviews() {
        mainView.frame = tabBar.bounds
        
        // 删除tabbar上原来的item，否则会影响mainView上item的响应
        for view in tabBar.subviews {
            if !view.isKind(of: MainTabbarView.self) {
                view.removeFromSuperview()
            }
        }
    }
    
    override var selectedIndex: Int {
        didSet {
            var type: MainTabbarView.ItemType = .home
            if selectedIndex == 0 {
                type = .home
            } else if selectedIndex == 1 {
                type = canShowADS ? .me : .discover
            } else if selectedIndex == 2 {
                type = .me
            }
            mainView.selectItem(selectedItemType: type)
        }
    }
}

fileprivate extension MainTabbarViewController {
    
    func addEvent() {
        mainView.didSelectedItem = { [unowned self] type in
            switch type {
            case .home:
                self.selectedIndex = 0
            case .discover:
                self.selectedIndex = 1
            case .me:
                self.selectedIndex = canShowADS ? 1 : 2
            case .ads:
                adsWebVC.modalPresentationStyle = .fullScreen
                self.present(adsWebVC, animated: true, completion: nil)
            }
        }
    }
}
