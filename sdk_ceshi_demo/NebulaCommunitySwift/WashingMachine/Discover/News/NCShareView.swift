//
//  NCShareView.swift
//  WashingMachine
//
//  Created by zzh on 2017/7/24.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

import UIKit

fileprivate let screenMaxCount = 4  // 最大数量
fileprivate let shareIconWidth: CGFloat = 60 // 分享图标高度
fileprivate let shareItemHeight: CGFloat = 75  // 分享图标及文字的总高度
fileprivate let shareItemWidth: CGFloat = 80 // 当分享的种类小于4时，用此宽度
fileprivate let contentHeight: CGFloat = 192 //
fileprivate let shareIcons = ["share_wx_friend",
                              "share_wx_circle"]
fileprivate let shareTitles = ["微信好友",
                               "微信朋友圈"]

public enum NCShareViewType: Int {
    case wxFriends
    case wxCircleOfFriend
}

class NCShareView: UIView {

    var shareBtns: [UIButton] = [UIButton]()
    var contentView: UIView!
    var shareClourse:((NCShareViewType)->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cancelTap)))
        makeUI()
    }
    
    @objc private func cancelTap() {
        animationHiddenAndRemoveFromSuperView()
    }
    
    @objc fileprivate func clickCancelBtn() {
        animationHiddenAndRemoveFromSuperView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func clickShareBtn(btn: UIButton) {
        switch btn.tag {
        case 0:
            shareClourse?(.wxFriends)
        case 1:
            shareClourse?(.wxCircleOfFriend)
        default:
            print("")
        }
    }
    
    func animationHiddenAndRemoveFromSuperView() {
        hiddenAnimation {
            self.removeFromSuperview()
        }
    }
    
    func showAnimation(_ completed: (()->())?) {
        contentView.hz_y = BOUNDS_HEIGHT
        UIView.animate(withDuration: 0.2, animations: {
            self.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            self.contentView.hz_y = BOUNDS_HEIGHT-contentHeight-10
        }) { (_) in
            completed?()
        }
    }
    
    func hiddenAnimation(_ completed: (()->())?) {
        contentView.hz_y = BOUNDS_HEIGHT-contentHeight-10
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundColor = UIColor.black.withAlphaComponent(0.0)
            self.contentView.hz_y = BOUNDS_HEIGHT
        }) { (_) in
            completed?()
        }
    }
    
    @objc func contentTapAction() {
        
    }
    
    private func makeUI() {
        self.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        
        contentView = UIView()
        contentView.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        contentView.frame = CGRect(x: 10, y: BOUNDS_HEIGHT, width: BOUNDS_WIDTH-20, height: contentHeight)
        contentView.layer.cornerRadius = 7
        contentView.clipsToBounds = true
        contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(contentTapAction)))
        addSubview(contentView)
        contentView.addSubview(effectView(contentView.bounds, .extraLight))
        
        let shareLabel = UILabel()
        shareLabel.textColor = UIColorRGB(55, 67, 89, 1)
        shareLabel.textColor = UIColor.black
        shareLabel.font = UIFont(name: "PingFangSC-Regular", size: 13)
        shareLabel.text = "分享到"
        contentView.addSubview(shareLabel)
        shareLabel.snp.makeConstraints { (make) in
            make.top.equalTo(13)
            make.centerX.equalToSuperview()
        }
        
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 46, width: contentView.hz_width, height: shareItemHeight))
        scrollView.clipsToBounds = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        contentView.addSubview(scrollView)
        scrollView.backgroundColor = UIColor.clear
        
        var itemWidth = scrollView.hz_width/CGFloat(screenMaxCount)
        var margin: CGFloat = 0
        if shareIcons.count < screenMaxCount {
            itemWidth = shareItemWidth
            margin = (scrollView.hz_width-itemWidth*CGFloat(shareIcons.count))/CGFloat(shareIcons.count+1)
        }
        scrollView.contentSize = CGSize(width: CGFloat(shareIcons.count)*itemWidth, height: shareItemHeight)
        for i in 0 ..< shareIcons.count {
            let itemBtn = UIButton(type: .custom)
            itemBtn.frame = CGRect(x: margin+CGFloat(i)*(itemWidth+margin),
                                    y: 0,
                                    width: itemWidth,
                                    height: scrollView.hz_height)
            itemBtn.tag = i
            itemBtn.addTarget(self, action: #selector(clickShareBtn(btn:)), for: .touchUpInside)
            scrollView.addSubview(itemBtn)
            shareBtns.append(itemBtn)
            
            let shareIcon = UIImageView(image: UIImage(named: shareIcons[i]))
            itemBtn.addSubview(shareIcon)
            shareIcon.snp.makeConstraints({ (make) in
                make.centerX.top.equalToSuperview()
                make.width.height.equalTo(shareIconWidth)
            })

            let shareTypeLabel = UILabel()
            shareTypeLabel.textColor = UIColorRGB(55, 67, 89, 1)
            shareTypeLabel.font = UIFont(name: "PingFangSC-Regular", size: 11)
            shareTypeLabel.text = shareTitles[i]
            itemBtn.addSubview(shareTypeLabel)
            shareTypeLabel.snp.makeConstraints({ (make) in
                make.centerX.bottom.equalToSuperview()
                make.width.lessThanOrEqualTo(itemBtn)
            })
        }
        
        let sepline = UIView()
        sepline.backgroundColor = UIColor.lightGray
        sepline.frame = CGRect(x: 0, y: 142, width: contentView.hz_width, height: 0.5)
        contentView.addSubview(sepline)
        
        let cancelBtn = UIButton(type: .custom)
        cancelBtn.frame = CGRect(x: 0, y: 147, width: contentView.hz_width, height: 40)
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.setTitleColor(THEMECOLOR, for: .normal)
        cancelBtn.addTarget(self, action: #selector(clickCancelBtn), for: .touchUpInside)
        contentView.addSubview(cancelBtn)
    }
}
