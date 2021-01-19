//
//  WMTabbarView.swift
//  WashingMachine
//
//  Created by zzh on 17/3/6.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

import UIKit

class WMTabbarView: UIView {
    
    var currentIndexClourse:((Int)->())?
    var clickCenterClourse:(()->())?
    
    fileprivate var selectedImages: [UIImage]!
    fileprivate var normalImages: [UIImage]!
    fileprivate var titles: [String]?
    fileprivate var buttonArray = [WMTabbarButton]()
    fileprivate var centerImage: UIImage?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func addTabbarItem(selectedImages:[UIImage], normalImages:[UIImage], titles:[String]?) {
        self.selectedImages = selectedImages
        self.normalImages = normalImages
        self.titles = titles
        self.configUI()
    }
    
    func addCenterImage(_ centerImage: UIImage) {
        self.centerImage = centerImage
        self.createCenterImageView(centerImage)
        self.adjustTabbarItemFrame()
    }
    
    fileprivate func createCenterImageView(_ image: UIImage) {
        let button = WMTabbarButton()
        self.addSubview(button)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        button.setImage(image, for: UIControl.State.normal)
        button.adjustsImageWhenHighlighted = false
        button.frame = CGRect(x: 0, y: 0.5, width: self.hz_width/CGFloat(self.buttonArray.count+1), height: 48.5)
        button.center.x = self.hz_width/2.0
        button.backgroundColor = UIColor.white
        button.addTarget(self, action: #selector(clickCenter), for: UIControl.Event.touchUpInside)
    }
    
    @objc func clickCenter() {
        if clickCenterClourse != nil {
            clickCenterClourse!()
        }
    }
    
    func configUI() {
        let iOSVersion = UIDevice.current.systemVersion
        if !iOSVersion.contains("10.") { // 如果不是iOS10
            let lineView = UIView()
            self.addSubview(lineView)
            lineView.backgroundColor = UIColor.lightGray
            lineView.frame = CGRect(x: 0, y: 0, width: BOUNDS_WIDTH, height: 0.5)
        }
        
        let btnWidth = self.hz_width/CGFloat(self.normalImages.count)
        for i in 0 ..< self.normalImages.count {
            let button = WMTabbarButton()
            self.addSubview(button)
            button.tag = i
//            button.titleLabel?.font = UIFont.systemFont(ofSize: 11)
            button.configData(normalImage: self.normalImages[i], selectedImage: self.selectedImages[i], title: nil)
            button.adjustsImageWhenHighlighted = false
            button.frame = CGRect(x: CGFloat(i)*btnWidth, y: 0.5, width: btnWidth, height: 48.5)
            button.backgroundColor = UIColor.white.withAlphaComponent(0.5)
            button.addTarget(self, action: #selector(clickButton(button:)), for: UIControl.Event.touchUpInside)
            self.buttonArray.append(button);
            if i == 0 {
                button.setSelectedStasus()
            }
        }
    }

    
    func adjustTabbarItemFrame() {
        let btnWidth = self.hz_width/CGFloat(self.buttonArray.count + 1)
        for i in 0 ..< self.buttonArray.count {
            let button = self.buttonArray[i]
            button.hz_width = btnWidth
            if i < self.buttonArray.count/2 {
                button.hz_x = btnWidth*CGFloat(i)
            } else {
                button.hz_x = btnWidth*CGFloat(i+1)
            }
        }
    }
    
    @objc fileprivate func clickButton(button: WMTabbarButton) {
        for i in 0 ..< self.buttonArray.count {
            let btn = self.buttonArray[i]
            btn.setNormalStatus()
        }
        button.setSelectedStasus()
        if currentIndexClourse != nil {
            currentIndexClourse!(button.tag)
        }
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        print("layoutSubviews")
    }
}
