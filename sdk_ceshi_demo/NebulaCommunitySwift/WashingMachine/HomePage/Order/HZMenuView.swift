//
//  HZMenuView.swift
//  WashingMachine
//
//  Created by zzh on 2017/5/9.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

import UIKit

class HZMenuView: UIScrollView {
    
    var leftMargin: CGFloat = 20
    var middleMargin: CGFloat = 30
    var textFont: UIFont = UIFont.systemFont(ofSize: 16)
    var textNorColor: UIColor = UIColor.black
    var textSelectedColor: UIColor = UIColor.orange
    var bottomLineColor: UIColor = UIColor.orange
    var bottomLineWidth: CGFloat = 30
    var bottomLineHeight: CGFloat = 2
    var clickItemClourse: ((NSInteger) -> ())?
    fileprivate var _currentIndex: NSInteger = 0
    
    fileprivate var normalRed: CGFloat = 0
    fileprivate var normalGreen: CGFloat = 0
    fileprivate var normalBlue: CGFloat = 0
    fileprivate var normalAlpha: CGFloat = 0
    fileprivate var seleceedRed: CGFloat = 0
    fileprivate var seleceedGreen: CGFloat = 0
    fileprivate var seleceedBlue: CGFloat = 0
    fileprivate var seleceedAlpha: CGFloat = 0

    fileprivate var titleBtns: [UIButton] = [UIButton]()
    fileprivate var titleWidthArr: [NSNumber] = [NSNumber]()
    fileprivate var titleOriginXArr: [NSNumber] = [NSNumber]()
    
    fileprivate var bottomLineView: UIView!
    fileprivate var sepLineView: UIView!
    fileprivate let baseTag: Int = 3542
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.bounces = false
    }
    
    var currentIndex: NSInteger {
        get {
            return _currentIndex
        }
        set {
            if (_currentIndex != newValue) {
                _currentIndex = newValue
                changeSelectedBtn(index: _currentIndex)
                adjustScrollOffset()
            }
        }
    }
    
    func lineFlowScroll(rate: CGFloat) {
        if rate <= 0 || rate > CGFloat(titleBtns.count-1) {
            return
        }
        let index = NSInteger(rate)
        let percent = rate - CGFloat(index)
        for i in 0 ..< titleBtns.count {
            if i != index || i != index+1 {
                titleBtns[i].setTitleColor(textNorColor, for: UIControl.State.normal)
            }
        }
        let distance = btnWidth(index: index)/2 + btnWidth(index: index+1)/2 + middleMargin
        bottomLineView.center.x = distance*percent + btnOriginX(index: index) + btnWidth(index: index)/2
        if titleBtns.count > index {
            changeBtnColor(btn: titleBtns[index], rate: percent)
        }
        if titleBtns.count > index+1 {
            changeBtnColor(btn: titleBtns[index+1], rate: 1-percent)
        }
    }
    
    func addTitles(titles: [String]?) {
        if titles == nil || titles?.count == 0 {
            return
        }
        var btnArr = [UIButton]()
        var widthArr = [NSNumber]()
        var originXArr = [NSNumber]()
        var btnX = leftMargin
        for i in 0 ..< titles!.count {
            let button = UIButton(type: UIButton.ButtonType.custom)
            button.setTitle(titles?[i], for: UIControl.State.normal)
            button.setTitleColor(textNorColor, for: UIControl.State.normal)
            button.titleLabel?.font = textFont
            button.tag = baseTag + i
            button.frame = CGRect(x: btnX,
                                  y: 0,
                                  width: computingTextSize(text: titles?[i], font: textFont).width,
                                  height: self.hz_height-self.bottomLineHeight)
            button.addTarget(self, action: #selector(clickTitle(btn:)), for: UIControl.Event.touchUpInside);
            addSubview(button)
            
            btnArr.append(button)
            originXArr.append(NSNumber(value: Double(btnX)))
            if i == titles!.count-1 {
                btnX += (middleMargin + leftMargin)
            } else {
                btnX += (middleMargin + button.hz_width)
            }
            widthArr.append(NSNumber(value: Double(button.hz_width)))
        }
        
        contentSize = CGSize(width: btnX, height: 0)
        titleBtns = btnArr
        titleWidthArr = widthArr
        titleOriginXArr = originXArr
        
        configColorRGB()
        configButtonLine()
    }
    
    @objc fileprivate func clickTitle(btn: UIButton) {
        let index = btn.tag - baseTag
        if index == _currentIndex {
            return
        }
        changeSelectedBtn(index: index)
        adjustScrollOffset()
        if clickItemClourse != nil {
            clickItemClourse!(_currentIndex)
        }
    }
    
    fileprivate func adjustScrollOffset() {
        if contentSize.width < frame.size.width {
            return
        }
        let disparity = btnOriginX(index: _currentIndex) + btnWidth(index: _currentIndex)/2 - self.hz_width/2
        var pointX: CGFloat = 0
        if disparity < 0 {
            
        } else if disparity > contentSize.width - frame.size.width {
            pointX = contentSize.width - frame.size.width
        } else {
            pointX = disparity
        }
        
        UIView.animate(withDuration: 0.3) { 
            self.contentOffset = CGPoint(x: pointX, y: 0)
        }
    }
    
    fileprivate func changeSelectedBtn(index: NSInteger) {
        for i in 0 ..< titleBtns.count {
            let btn = titleBtns[i]
            btn.setTitleColor(textNorColor, for: UIControl.State.normal)
        }
        let selectedBtn = titleBtns[index]
        selectedBtn.setTitleColor(textSelectedColor, for: UIControl.State.normal)
        bottomLineView.center.x = selectedBtn.center.x
        _currentIndex = index
    }
    
    fileprivate func configButtonLine() {
        bottomLineView = UIView()
        bottomLineView.frame = CGRect(x: 0,
                                      y: self.hz_height-self.bottomLineHeight-10,
                                      width: self.bottomLineWidth,
                                      height: self.bottomLineHeight)
        bottomLineView.backgroundColor = bottomLineColor
        let firstBtn = titleBtns.first
        bottomLineView.center.x = firstBtn?.center.x ?? 0
        firstBtn?.setTitleColor(textSelectedColor, for: UIControl.State.normal)
        self.addSubview(bottomLineView)
        
        sepLineView = UIView()
        sepLineView.frame = CGRect(x: 0, y: self.hz_height-5, width: contentSize.width, height: 5)
        sepLineView.backgroundColor = BACKGROUNDCOLOR
        self.addSubview(sepLineView)
    }
    
    fileprivate func configColorRGB() {
        textNorColor.getRed(&normalRed, green: &normalGreen, blue: &normalBlue, alpha: &normalAlpha)
        textSelectedColor.getRed(&seleceedRed, green: &seleceedGreen, blue: &seleceedBlue, alpha: &seleceedAlpha)
    }
    
    fileprivate func changeBtnColor(btn: UIButton, rate: CGFloat) {
        
        btn.setTitleColor(UIColor(red: seleceedRed*(1-rate)+normalRed*rate,
                                  green: seleceedGreen*(1-rate)+normalGreen*rate,
                                  blue: seleceedBlue*(1-rate)+normalBlue*rate,
                                  alpha: seleceedAlpha*(1-rate)+normalAlpha*rate),
                          for: UIControl.State.normal)
    }
    
    fileprivate func btnWidth(index: NSInteger) -> CGFloat {
        if titleWidthArr.count > index {
            return CGFloat(titleWidthArr[index].doubleValue)
        }
        return 0
    }
    
    fileprivate func btnOriginX(index: NSInteger) -> CGFloat {
        if titleOriginXArr.count > index {
            return CGFloat(titleOriginXArr[index].doubleValue)
        }
        return 0
    }
    
    fileprivate func computingTextSize(text: String?,font: UIFont, width: CGFloat = 1000, height: CGFloat = 1000) -> CGSize {
        if text == nil {
            return CGSize.zero
        }
        let constraint = CGSize(width: width, height: height)
        let attributes = [NSAttributedString.Key.font: font]
        let attribuedText = NSAttributedString(string: text!, attributes: attributes)
        let rect = attribuedText.boundingRect(with: constraint, options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
        return rect.size
    }
    
}



