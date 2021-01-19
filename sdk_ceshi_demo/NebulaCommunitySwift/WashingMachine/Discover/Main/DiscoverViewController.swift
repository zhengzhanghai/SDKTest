//
//  DiscoverViewController.swift
//  WashingMachine
//
//  Created by Harious on 2018/1/12.
//  Copyright © 2018年 Eteclabeteclab. All rights reserved.
//

import UIKit

class DiscoverViewController: BaseViewController {
    
    var menuView: DiscoverMenuView!
    var contentScrollView: UIScrollView!
    
    /// 资讯控制器
    fileprivate lazy var newsVC: NewsViewController = {
        return NewsViewController()
    }()
    /// 留言板控制器
    fileprivate lazy var messageBoradVC: FeedBackViewController = {
        return FeedBackViewController()
    }()
    /// 创业控制器
    fileprivate lazy var entrepreneurshipVC: EntrepreneurshipViewController = {
        return EntrepreneurshipViewController()
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// 设置导航栏上一些非自定义按钮的的颜色
        self.navigationController?.navigationBar.tintColor = UIColor.black
        /// 取消导航栏半透明效果
        self.navigationController?.navigationBar.isTranslucent = false
        
        self.makeUI()
        
        self.addChildVC(0)
    }
    
    /// 添加子控制器
    fileprivate func addChildVC(_ index: Int) {
        
        guard !isExistVC(index) && index >= 0 && index < 3 else {
            return
        }
        
        let vc = self.currentVC(index)
        self.addChild(vc)
        vc.didMove(toParent: self)
        contentScrollView.addSubview(vc.view)
        vc.view.snp.makeConstraints { (make) in
            make.left.equalTo(BOUNDS_WIDTH*CGFloat(index))
            make.width.top.height.equalToSuperview()
        }
    }
    
    /// 根据序号判断子视图上是否已经存在应有的VC
    fileprivate func isExistVC(_ index: Int) -> Bool {
        return self.children.contains(self.currentVC(index))
    }
    
    /// 根据index获取子视图上的VC
    fileprivate func currentVC(_ index: Int) -> BaseViewController {
        if index == 0 {
            return newsVC
        } else if index == 1 {
            return messageBoradVC
        } else {
            return entrepreneurshipVC
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
 
}

//MARK: --------------- 处理一些事件 ------------------
extension DiscoverViewController {
    //TODO: ------ ➡️ ----- 点击上面的菜单会响应的事件 ------------------
    fileprivate func didSelectedMenuItem(_ itemType: DiscoverMenuView.ItemType) {
        UIView.animate(withDuration: 0.2) {
            self.contentScrollView.contentOffset = CGPoint(x: CGFloat(itemType.rawValue)*BOUNDS_WIDTH, y: 0)
        }
        
        switch itemType {
        case .messageBoard:
            self.addChildVC(1)
        case .entrepreneurship:
            self.addChildVC(2)
        default: ZZPrint("0000")
            
        }
    }
}

//MARK: --------------- 创建本页的一些视图 ------------------
extension DiscoverViewController {
    fileprivate func makeUI() {
        menuView = DiscoverMenuView()
        self.view.addSubview(menuView)
        menuView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(NAVIGATIONBAR_HEIGHT+STATUSBAR_HEIGHT)
        }
        // 点击顶部菜单回调闭包
        menuView.didselectedItem = { [unowned self] itemType in
            self.didSelectedMenuItem(itemType)
        }
        
        contentScrollView = UIScrollView()
        contentScrollView.delegate = self
        contentScrollView.isPagingEnabled = true
        contentScrollView.showsHorizontalScrollIndicator = false
        contentScrollView.contentSize = CGSize(width: BOUNDS_WIDTH*CGFloat(DiscoverMenuView.titles.count), height: 0)
        self.view.addSubview(contentScrollView)
        contentScrollView.snp.makeConstraints { (make) in
            make.top.equalTo(menuView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(-TABBAR_HEIGHT)
        }
    }
}

//MARK: --------------- UIScrollViewDelegate ------------------
extension DiscoverViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        /// 根据scrollview滚动的位置联动上面菜单
        self.menuView.fixMenuView.currentIndex = lround(Double(scrollView.contentOffset.x/scrollView.hz_width))
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = lround(Double(scrollView.contentOffset.x/scrollView.hz_width))
        self.menuView.fixMenuView.currentIndex = index
        self.addChildVC(index)
    }
    
}




