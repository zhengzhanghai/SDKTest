//
//  GuidePageContentView.swift
//  WashingMachine
//
//  Created by zzh on 2017/6/30.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

import UIKit

let guidePageViewControllerUserDefaultkey   = "guidePageViewControllerUserDefaultkey"
let guidePageViewControllerUserDefaultValue = "enteredGuidePageViewController"

fileprivate let imageStrs = ["guide_page_one", "guide_page_two", "guide_page_three"]

class GuidePageContentView: UIView {
    
    var scrollView: UIScrollView!
    var startUseClourse:(()->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
        UserDefaults.standard.set(guidePageViewControllerUserDefaultValue+HZApp.appVersion, forKey: guidePageViewControllerUserDefaultkey)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func makeUI() {
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: BOUNDS_WIDTH, height: BOUNDS_HEIGHT))
        scrollView.backgroundColor = UIColor.white
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.isScrollEnabled = true
        scrollView.delegate = self
        scrollView.bounces = false
        scrollView.contentSize = CGSize(width: CGFloat(imageStrs.count)*BOUNDS_WIDTH, height: BOUNDS_HEIGHT)
        scrollView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(scrollViewTapAction)))
        addSubview(scrollView)
        
        for (i, imageStr) in imageStrs.enumerated() {
            let imageView = UIImageView(frame: CGRect(x: CGFloat(i)*BOUNDS_WIDTH, y: 0, width: BOUNDS_WIDTH, height: BOUNDS_HEIGHT))
            imageView.image = UIImage(named: imageStr)
            imageView.isUserInteractionEnabled = true
            scrollView.addSubview(imageView)
        }
        
        let startUseBtn = UIButton(frame: CGRect(x: BOUNDS_WIDTH*CGFloat(imageStrs.count-1)+BOUNDS_WIDTH*0.15,
                                                 y: BOUNDS_HEIGHT*0.8,
                                                 width: BOUNDS_WIDTH*0.7,
                                                 height: BOUNDS_WIDTH*0.7*0.2))
        startUseBtn.backgroundColor = THEMECOLOR
        startUseBtn.setTitle("开始使用", for: .normal)
        startUseBtn.layer.cornerRadius = 6
        startUseBtn.setTitleColor(UIColor.white, for: .normal)
        startUseBtn.addTarget(self, action: #selector(clickStartUse), for: .touchUpInside)
        scrollView.addSubview(startUseBtn)
    }
    
    @objc func clickStartUse() {
        UIView.animate(withDuration: 0.8, animations: {
            self.transform = CGAffineTransform(scaleX: 2, y: 2)
            self.alpha = 0
        }) { (_) in
            self.removeFromSuperview()
            self.startUseClourse?()
        }
    }
    
    @objc func scrollViewTapAction() {
        if scrollView.contentOffset.x >= scrollView.contentSize.width-BOUNDS_WIDTH {
            return
        }
        UIView.animate(withDuration: 0.2) {
            self.self.scrollView.contentOffset = CGPoint(x: self.scrollView.contentOffset.x+BOUNDS_WIDTH, y: 0)
        }
    }
}

extension GuidePageContentView: UIScrollViewDelegate {
    
}
