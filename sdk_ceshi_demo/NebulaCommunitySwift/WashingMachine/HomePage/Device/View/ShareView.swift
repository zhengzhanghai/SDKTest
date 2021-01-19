//
//  ShareView.swift
//  WashingMachine
//
//  Created by zzh on 2017/6/21.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

import UIKit

fileprivate let shareSectionHeight: CGFloat = 80 // 分享区域高度
fileprivate let cancelSectionHeight: CGFloat = 50 // 取消区域高度
fileprivate let shareBtnMargin: CGFloat = 20 // 分享按钮之间间隔
fileprivate let shareBtnWidth: CGFloat = 45  // 分享按钮宽高
fileprivate let contentHeight: CGFloat = 130 //shareSectionHeight + cancelSectionHeight
fileprivate let shareIcons = ["share_wx_friend",
                              "share_wx_circle"]

internal enum ShareType: Int {
    case wxFriends
    case wxCircleOfFriends
}

class ShareView: UIView {
    
    var shareBtns: [UIButton] = [UIButton]()
    var contentView: UIView!
    var shareClourse:((ShareType)->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func clickShareBtn(btn: UIButton) {
        switch btn.tag {
        case 0:
            shareClourse?(.wxFriends)
        case 1:
            shareClourse?(.wxCircleOfFriends)
        default:
            print("")
        }
    }
    
    func animationHiddenAndRemoveFromSuperView() {
        hiddenAnimation {
            self.removeFromSuperview()
        }
    }
    
    @objc func clickCancel() {
        animationHiddenAndRemoveFromSuperView()
    }
    
    func showAnimation(_ completed: (()->())?) {
        windowUserEnabled(false)
        UIView.animate(withDuration: 0.2, animations: { 
            self.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            self.contentView.hz_y = BOUNDS_HEIGHT-contentHeight
        }) { (_) in
            
        }
        for (i, btn) in shareBtns.enumerated() {
            UIView.animate(withDuration: 0.1, delay: 0.2+Double(i)*0.05, options: .curveEaseInOut, animations: {
                btn.hz_y = (shareSectionHeight-shareBtnWidth)/2
            }, completion: { (_) in
                if i == self.shareBtns.count - 1 {
                    windowUserEnabled(true)
                }
                completed?()
            })
        }
    }
    
    func hiddenAnimation(_ completed: (()->())?) {
        windowUserEnabled(false)
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundColor = UIColor.black.withAlphaComponent(0.0)
            self.contentView.hz_y = BOUNDS_HEIGHT
        }) { (_) in
            for btn in self.shareBtns {
                btn.hz_y = shareSectionHeight
            }
            windowUserEnabled(true)
            completed?()
        }
    }
    
    private func makeUI() {
        self.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        
        contentView = UIView()
        contentView.backgroundColor = UIColor.white
        contentView.frame = CGRect(x: 0, y: BOUNDS_HEIGHT, width: BOUNDS_WIDTH, height: contentHeight)
        addSubview(contentView)
        
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: BOUNDS_WIDTH, height: shareSectionHeight))
        scrollView.clipsToBounds = true
        scrollView.contentSize = CGSize(width: CGFloat(shareIcons.count)*(shareBtnWidth+shareBtnMargin)+shareBtnMargin, height: shareSectionHeight)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        contentView.addSubview(scrollView)
        
        for i in 0 ..< shareIcons.count {
            let shareBtn = UIButton(type: .custom)
            shareBtn.frame = CGRect(x: shareBtnMargin+CGFloat(i)*(shareBtnWidth+shareBtnMargin),
                                    y: shareSectionHeight,
                                    width: shareBtnWidth,
                                    height: shareBtnWidth)
            shareBtn.tag = i
            shareBtn.setImage(UIImage(named: shareIcons[i]), for: .normal)
            shareBtn.addTarget(self, action: #selector(clickShareBtn(btn:)), for: .touchUpInside)
            scrollView.addSubview(shareBtn)
            shareBtns.append(shareBtn)
        }
        
        let sepLine = UIView()
        sepLine.backgroundColor = UIColor(rgb: 0xdddddd)
        sepLine.frame = CGRect(x: 0, y: shareSectionHeight, width: BOUNDS_WIDTH, height: 1)
        contentView.addSubview(sepLine)
        
        let cancelBtn = UIButton(type: .custom)
        cancelBtn.frame = CGRect(x: 0, y: contentView.hz_height-cancelSectionHeight, width: 100, height: cancelSectionHeight)
        cancelBtn.center.x = contentView.hz_width/2
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        cancelBtn.setTitleColor(UIColor(rgb: 0x333333), for: .normal)
        cancelBtn.addTarget(self, action: #selector(clickCancel), for: .touchUpInside)
        contentView.addSubview(cancelBtn)
    }
}
