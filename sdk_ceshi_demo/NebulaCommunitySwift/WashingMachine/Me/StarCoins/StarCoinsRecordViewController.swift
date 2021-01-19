//
//  StarCoinsRecordViewController.swift
//  WashingMachine
//
//  Created by Harious on 2018/3/30.
//  Copyright © 2018年 Eteclabeteclab. All rights reserved.
//

import UIKit

enum StarCoinsRecordType {
    case consumption /// 消费
    case recharge  /// 充值
}

class StarCoinsRecordViewController: BaseViewController {
    
    /// 第一次进入展示的类型，默认消费
    var type: StarCoinsRecordType = .consumption
    
    let menuTitles = ["消费记录", "充值记录"]
    
    /// 星币消费记录控制器
    lazy var consumptionVC: StarCoinsConsumptionRecordViewController = {
        return StarCoinsConsumptionRecordViewController()
    }()
    /// 星币充值记录控制器
    lazy var rechargeVC: StarCoinsRechargeRecordViewController = {
        return StarCoinsRechargeRecordViewController()
    }()
    
    lazy var menuView: HZFixationMenuView = { [unowned self] in
        let fixView = HZFixationMenuView(menuTitles, true)
        fixView.itemWidth = 100
        fixView.startMakeItem()
        fixView.didSelectedItem = { [unowned self] index in
            
            UIView.animate(withDuration: 0.2) {
                self.contentScrollView.contentOffset = CGPoint(x: CGFloat(index)*BOUNDS_WIDTH, y: 0)
            }
            self.addChildVC(type: (index == 0) ? .consumption : .recharge)
        }
        return fixView
    }()
    
    lazy var contentScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: BOUNDS_WIDTH*CGFloat(menuTitles.count), height: 0)
        scrollView.backgroundColor = UIColor.white
        scrollView.isPagingEnabled = true
        return scrollView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 设置导航栏背景色
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        // 设置导航栏上一些非自定义按钮颜色
        self.navigationController?.navigationBar.tintColor = UIColor.black
        // 设置导航栏标题文字颜色及字体
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                                                                        NSAttributedString.Key.font:UIFont.systemFont(ofSize: 18)]
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // 设置导航栏背景色
        self.navigationController?.navigationBar.barTintColor = THEMECOLOR
        // 设置导航栏上一些非自定义按钮颜色
        self.navigationController?.navigationBar.tintColor = UIColor.white
        // 设置导航栏标题文字颜色及字体
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
                                                                        NSAttributedString.Key.font:UIFont.systemFont(ofSize: 18)]
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "明细"
        
        self.view.addSubview(menuView)
        menuView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(35)
        }
        
        self.view.addSubview(contentScrollView)
        contentScrollView.snp.makeConstraints { (make) in
            make.top.equalTo(self.menuView.snp.bottom)
            make.left.bottom.right.equalToSuperview()
        }
        
        if self.type == .recharge {
            self.menuView.currentIndex = 1
            self.contentScrollView.contentOffset = CGPoint(x: BOUNDS_WIDTH, y: 0)
        }
        self.addChildVC(type: type)
    }
    
    fileprivate func addChildVC(type: StarCoinsRecordType) {
        
        guard !isExistChildVC(type: type) else { return }
        
        let vc = (type == .consumption) ? consumptionVC : rechargeVC
        self.addChild(vc)
        vc.didMove(toParent: self)
        contentScrollView.addSubview(vc.view)
        vc.view.snp.makeConstraints { (make) in
            make.left.equalTo(BOUNDS_WIDTH*CGFloat(type == .consumption ? 0 : 1))
            make.width.top.height.equalToSuperview()
        }
    }
    
    fileprivate func isExistChildVC(type: StarCoinsRecordType) -> Bool {
        return self.children.contains(type == .consumption ? consumptionVC : rechargeVC)
    }
}

extension StarCoinsRecordViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        /// 根据scrollview滚动的位置联动上面菜单
        self.menuView.currentIndex = lround(Double(scrollView.contentOffset.x/scrollView.hz_width))
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let offectX = scrollView.contentOffset.x
        
        guard offectX >= 0 && offectX <= CGFloat(menuTitles.count)*scrollView.hz_width else { return }
        
        let index = lround(Double(offectX/scrollView.hz_width))
        self.menuView.currentIndex = index
        self.addChildVC(type: index == 0 ? .consumption : .recharge)
    }
}
