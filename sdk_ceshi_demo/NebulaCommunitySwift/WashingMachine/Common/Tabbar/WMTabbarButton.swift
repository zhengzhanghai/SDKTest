//
//  WMTabbarButton.swift
//  WashingMachine
//
//  Created by zzh on 17/3/6.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

import UIKit

class WMTabbarButton: UIButton {

    fileprivate var normalImage: UIImage!
    fileprivate var selectedImage: UIImage!
    fileprivate var title: String!
    
    func configData(normalImage: UIImage, selectedImage: UIImage, title: String?) {
        self.normalImage = normalImage
        self.selectedImage = selectedImage
//        self.title = title
        
//        self.setTitle(title, for: UIControlState.normal)
//        self.setTitleColor(UIColor.orange, for: UIControlState.normal)
        self.setImage(normalImage, for: UIControl.State.normal)
//        self.adjustImageAndWordFrame()
    }
    
    func setSelectedStasus() {
//        self.setTitleColor(UIColor.green, for: UIControlState.normal)
        self.setImage(self.selectedImage, for: UIControl.State.normal)
    }
    
    func setNormalStatus() {
//        self.setTitleColor(UIColor.orange, for: UIControlState.normal)
        self.setImage(self.normalImage, for: UIControl.State.normal)
    }
    
    func adjustImageAndWordFrame() {
        /** 没有文字，返回普通按钮 */
        if self.titleLabel?.text == nil {
            return
        }
        
        // 获得按钮的大小
        let btnWidth = self.bounds.size.width;
        let btnHeight = self.bounds.size.height;
        // 获得按钮中UILabel文本的大小
        let labelWidth = self.titleLabel?.bounds.size.width ?? CGFloat(0);
        let labelHeight = self.titleLabel?.bounds.size.height ?? CGFloat(0);
        // 获得按钮中image图标的大小
        let imageWidth = self.imageView?.bounds.size.width ?? CGFloat(0);
        let imageHeight = self.imageView?.bounds.size.height ?? CGFloat(0);
        
        /** 设置button上的图片或文字 */
        // 计算文本的的宽度
        let content = self.titleLabel?.text ?? ""
        let text:NSString = content as NSString
        let frame = text.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT),
                                                   height: CGFloat(MAXFLOAT)),
                                      options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                      attributes: [NSAttributedString.Key.font: self.titleLabel?.font ?? UIFont.systemFont(ofSize: 15)],
                                      context: nil)
        let imageX = (btnWidth - imageWidth) * CGFloat(0.5);
        self.imageView?.frame = CGRect(x: imageX, y: btnHeight * 0.5 - imageHeight * 0.7, width: imageWidth, height: imageHeight)
        self.titleLabel?.frame = CGRect(x: (self.center.x - frame.size.width) * 0.5, y: btnHeight * 0.5 + labelHeight * 0.7, width: labelWidth, height: labelHeight)
        var labelCenter = self.titleLabel?.center ?? CGPoint(x: 0, y: 0)
        labelCenter.x = (self.imageView?.center.x)!;
        self.titleLabel?.center = labelCenter;
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        self.adjustImageAndWordFrame()
        self.imageView?.center.x = self.hz_width/2.0
    }
}
