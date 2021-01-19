//
//  ADSContentView.swift
//  WashingMachine
//
//  Created by zzh on 2017/8/10.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

import UIKit

class ADSContentView: UIView {
    
    var adsIcon: UIImageView!
    var effView: UIVisualEffectView!
    var clickImageClourse: (()->())?
    
    convenience init(_ frame: CGRect, _ image: UIImage) {
        self.init(frame: frame)
        makeUI(image)
    }
    
    func showAnimation() {
        adsIcon.snp.remakeConstraints { (make) in
            make.width.equalTo(BOUNDS_WIDTH*0.75)
            make.height.equalTo(BOUNDS_WIDTH*0.75*9/16)
            make.centerX.equalToSuperview()
            make.top.equalTo(self.snp.bottom).offset(30)
        }
        effView.alpha = 0
        layoutIfNeeded()
        
        UIView.animate(withDuration: 0.7) {
            self.adsIcon.snp.remakeConstraints({ (make) in
                make.width.equalTo(BOUNDS_WIDTH*0.75)
                make.height.equalTo(BOUNDS_WIDTH*0.75*9/16)
                make.centerX.centerY.equalToSuperview()
            })
            self.effView.alpha = 1
            self.layoutIfNeeded()
        }
    }
    
    func removeFromSuperViewAnimation() {
        adsIcon.snp.remakeConstraints { (make) in
            make.width.equalTo(BOUNDS_WIDTH*0.75)
            make.height.equalTo(BOUNDS_WIDTH*0.75*9/16)
            make.centerX.centerY.equalToSuperview()
        }
        effView.alpha = 1
        layoutIfNeeded()
        
        UIView.animate(withDuration: 0.3, animations: {
            self.adsIcon.snp.remakeConstraints({ (make) in
                make.width.equalTo(BOUNDS_WIDTH*0.75)
                make.height.equalTo(BOUNDS_WIDTH*0.75*9/16)
                make.centerX.equalToSuperview()
                make.top.equalTo(self.snp.bottom).offset(30)
            })
            self.effView.alpha = 0
            self.layoutIfNeeded()
        }) { (_) in
            self.removeFromSuperview()
        }
    }
    
    @objc fileprivate func clickImage() {
        clickImageClourse?()
    }
    
    @objc fileprivate func clickClose() {
        removeFromSuperViewAnimation()
    }
    
    @objc fileprivate func emptyTapAction() {
        removeFromSuperViewAnimation()
    }
    
    func makeUI(_ image: UIImage) {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(emptyTapAction)))
        
        backgroundColor = UIColor.clear
        self.isUserInteractionEnabled = true
        effView = effectView(bounds, .dark)
        effView.alpha = 0
        addSubview(effView)
        
        adsIcon = UIImageView()
        adsIcon.image = image
        adsIcon.layer.cornerRadius = 10
        adsIcon.clipsToBounds = true
        adsIcon.isUserInteractionEnabled = true
        adsIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickImage)))
        addSubview(adsIcon)
        adsIcon.snp.makeConstraints { (make) in
            make.width.equalTo(BOUNDS_WIDTH*0.75)
            make.height.equalTo(BOUNDS_WIDTH*0.75*9/16)
            make.centerX.equalToSuperview()
            make.top.equalTo(self.snp.bottom).offset(30)
        }
        
        let closeBtn = UIButton(type: .custom)
        closeBtn.setImage(UIImage(named: "close_normal_white"), for: .normal)
        closeBtn.addTarget(self, action: #selector(clickClose), for: .touchUpInside)
        addSubview(closeBtn)
        closeBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.adsIcon.snp.bottom).offset(30)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        layoutIfNeeded()
    }

}
