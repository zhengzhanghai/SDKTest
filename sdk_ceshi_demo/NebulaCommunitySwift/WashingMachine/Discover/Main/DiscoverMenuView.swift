//
//  DiscoverMenuView.swift
//  WashingMachine
//
//  Created by Harious on 2018/1/12.
//  Copyright © 2018年 Eteclabeteclab. All rights reserved.
//

import UIKit

class DiscoverMenuView: UIView {
    
    /// ⚠️ ⚠️ ⚠️ ⚠️跟下面的这个枚举在顺序和个数上要对应上(包括初始化方法)
//    static let titles = ["资讯", "池塘", "创业"]
    static let titles = ["资讯"]
    
    enum ItemType: Int {
        case news = 0
        case messageBoard = 1
        case entrepreneurship = 2
        /// 如果不在预定范围内，将返回news
        init (_ tag: Int) {
            switch tag {
            case 0: self = .news
            case 1: self = .messageBoard
            case 2: self = .entrepreneurship
            default: self = .news
            }
        }
    }
    
    var fixMenuView: HZFixationMenuView
    var didselectedItem: ((DiscoverMenuView.ItemType)->())?
    lazy var sepLine: UIView = {
        let sep = UIView()
        sep.backgroundColor = UIColor_0x(0xaaaaaa)
        return sep
    }()
    
    override init(frame: CGRect) {
        fixMenuView = HZFixationMenuView(DiscoverMenuView.titles, false)
        super.init(frame: frame)
        
        fixMenuView.itemWidth = 100
        fixMenuView.startMakeItem()
        self.addSubview(fixMenuView)
        
        fixMenuView.didSelectedItem = { [unowned self] index in
            self.didselectedItem?(DiscoverMenuView.ItemType(index))
        }
        
        self.addSubview(sepLine)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        fixMenuView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(43.5)
            make.bottom.equalTo(-0.5)
        }
        sepLine.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
}
