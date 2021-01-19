//
//  EntrepreneurshipPopularityViewController.swift
//  WashingMachine
//
//  Created by Harious on 2018/2/2.
//  Copyright © 2018年 Eteclabeteclab. All rights reserved.
//

import UIKit

class EntrepreneurshipPopularityViewController: BaseViewController {
    
    lazy var projectVC: EntrepreneurshipProjectPopularViewController = {
        return EntrepreneurshipProjectPopularViewController()
    }()
    lazy var schoolVC: EntrepreneurshipSchoolPopularViewController = {
        return EntrepreneurshipSchoolPopularViewController()
    }()
    
    lazy var menuView: HZFixationMenuView = {
        let view = HZFixationMenuView(["项目人气排行", "校园人气排行"], true)
        view.itemWidth = 100
        view.bottomLineSize = CGSize(width: 100, height: 2)
        view.textFont = font_PingFangSC_Regular(12)
        view.normalColor = UIColor_0x(0x333333)
        view.startMakeItem()
        view.didSelectedItem = {[unowned self] index in
            UIView.animate(withDuration: 0.3, animations: {
                self.scrollView.contentOffset = CGPoint(x: BOUNDS_WIDTH*CGFloat(index), y: 0)
            }, completion: { (_) in
                
            })
            self.addChildVC(index)
        }
        return view
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = false
        scrollView.contentSize = CGSize(width: BOUNDS_WIDTH*2, height: 0)
        return scrollView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "创业人气榜"
        makeUI()
        
        self.addChildVC(0)
    }

    func makeUI() {
        self.view.addSubview(menuView)
        menuView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        
        self.view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.top.equalTo(self.menuView.snp.bottom)
            make.left.bottom.right.equalToSuperview()
        }
    }
    
    func addChildVC(_ index: Int) {
        
        let vc = index == 0 ? projectVC : schoolVC
        
        if self.children.contains(vc) {
            return
        }
        
        self.addChild(vc)
        vc.didMove(toParent: self)
        scrollView.addSubview(vc.view)
        vc.view.snp.makeConstraints { (make) in
            make.left.equalTo(BOUNDS_WIDTH*CGFloat(index))
            make.top.width.height.equalToSuperview()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    


}
