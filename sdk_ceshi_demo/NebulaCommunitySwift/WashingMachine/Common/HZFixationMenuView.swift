//
//  HZFixationMenuView.swift
//  WashingMachine
//
//  Created by Harious on 2018/1/11.
//  Copyright © 2018年 Eteclabeteclab. All rights reserved.
//

import UIKit

extension HZFixationMenuView {
    enum LayoutType {
        case center
        case left
    }
}

class HZFixationMenuView: UIView {
    
    var layoutType: LayoutType = .center
    var didSelectedItem: ((Int)->())?
    var titles: [String]
    var textFont: UIFont = UIFont.systemFont(ofSize: 15)
    var textSelectedFont: UIFont?
    var normalColor: UIColor = UIColor.black
    var selectedColor: UIColor = UIColor_0x(0x1296db)
    var bottomLineSize: CGSize = CGSize(width: 16, height: 2)
    var itemWidth: CGFloat = 72
    var lineColor: UIColor?
    
    fileprivate(set) var items: [UIButton] = [UIButton]()
    fileprivate(set) var currentItem: UIButton?
    fileprivate(set) var bottomLine: UIView?
    fileprivate(set) lazy var sepLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor_0x(0xcccccc)
        return view
    }()
    
    var currentIndex: Int {
        set {
            if newValue < 0 || newValue >= items.count {
                ZZPrint("⚠️ ⚠️ ⚠️ ⚠️ 传进来的currentIndex 越界 ")
                return
            }
            
            self.currentItem?.isSelected = false
            let btn = self.items[newValue]
            btn.isSelected = true
            currentItem = btn
            
            UIView.animate(withDuration: 0.2) {
                self.bottomLine?.hz_centerX = btn.hz_centerX
            }
        }
        get {
            return (self.currentItem?.tag ?? 0)
        }
    }
    
    init( _ titles: [String], _ hasSepLine: Bool) {
        self.titles = titles
        super.init(frame: CGRect.zero)
        self.backgroundColor = UIColor.white
        
        if hasSepLine {
            self.addSubview(sepLine)
            sepLine.snp.makeConstraints { (make) in
                make.left.right.bottom.equalToSuperview()
                make.height.equalTo(0.5)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc fileprivate func clickItem(_ btn: UIButton) {
        guard btn !== currentItem else {
            return
        }
        
        didSelectedItem?(btn.tag)
        currentItem?.titleLabel?.font = textFont
        btn.titleLabel?.font = selectedFont
        currentItem?.isSelected = false
        btn.isSelected = true
        currentItem = btn
        
        UIView.animate(withDuration: 0.2) {
            self.bottomLine?.hz_centerX = btn.hz_centerX
        }
    }
    
    override func layoutSubviews() {
        if layoutType == .center {
            let leftMargin = (self.hz_width - CGFloat(titles.count)*itemWidth)/2
            for (index ,btn) in items.enumerated() {
                btn.frame = CGRect(x: leftMargin+CGFloat(index)*itemWidth,
                                   y: 0,
                                   width: itemWidth,
                                   height: self.hz_height-bottomLineSize.height-0.5)
            }
        } else if layoutType == .left {
            for (index ,btn) in items.enumerated() {
                btn.frame = CGRect(x: CGFloat(index)*itemWidth,
                                   y: 0,
                                   width: itemWidth,
                                   height: self.hz_height-bottomLineSize.height-0.5)
            }
        }
        
        guard let selectedBtn = currentItem else {
            return
        }
        bottomLine?.frame = CGRect(x: 0,
                                   y: selectedBtn.frame.maxY,
                                   width: bottomLineSize.width,
                                   height: bottomLineSize.height)
        bottomLine?.hz_centerX = selectedBtn.hz_centerX
    }
    
    func startMakeItem() {
        for (index, title) in titles.enumerated() {
            let button = UIButton(type: .custom)
            button.tag = index
            button.setTitle(title, for: .normal)
            button.titleLabel?.font = textFont
            button.setTitleColor(normalColor, for: .normal)
            button.setTitleColor(selectedColor, for: .selected)
            button.addTarget(self, action: #selector(clickItem(_:)), for: .touchUpInside)
            
            self.addSubview(button)
            
            items.append(button)
        }
        
        bottomLine = UIView()
        bottomLine?.backgroundColor = lineColor ?? selectedColor
        addSubview(bottomLine!)
        
        guard let firstBtn = items.first else {
            return
        }
        firstBtn.isSelected = true
        firstBtn.titleLabel?.font = selectedFont
        currentItem = firstBtn
    }
    
    private var selectedFont: UIFont {
        return textSelectedFont ?? textFont
    }
    

}
