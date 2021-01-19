//
//  MeTableHeaderView.swift
//  WashingMachine
//
//  Created by zzh on 2017/7/31.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

import UIKit
import Kingfisher

/// 背景图
fileprivate let backgroundIcon = "me_bg"
/// 未登录状态下默认头像
fileprivate let headPortraitIcon = "header_moren"
/// 未登录状态默认用户名上显示文字
fileprivate let userName = "请登录"

class MeTableHeaderView: UIImageView {
    /// 头像
    var headPortraitBtn: UIButton!
    /// 用户名
    var userNameLabel: UILabel!
    /// 点击头像回调闭包
    var clickHeadPortraitClourse: (()->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createUI()
    }
    
    /// 更新设置头像和用户名
    ///
    /// - Parameters:
    ///   - headePortraitUrl: 如果传nil，保持不变，不是nil则更新
    ///   - userName: 如果传nil，保持不变，不是nil则更新
    func config(_ headePortraitUrl: String?, _ userName: String?) {
        if headePortraitUrl != nil {
            headPortraitBtn.kf.setImage(with: URL.init(string: headePortraitUrl ?? ""),
                                        for: .normal,
                                        placeholder: UIImage(named: headPortraitIcon),
                                        options: [.transition(ImageTransition.fade(1))])
        }
        if userName != nil {
            userNameLabel.text = userName
        }
    }
    
    /// 退出登录时将头像用户名设置成未登录状态
    func logoutRefresh() {
        headPortraitBtn.setImage(UIImage(named: headPortraitIcon), for: .normal)
        userNameLabel.text = userName
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 点击头像
    @objc fileprivate func clickHeadPortrait() {
        clickHeadPortraitClourse?()
    }
    
    fileprivate func createUI() {
        self.isUserInteractionEnabled = true
        self.image = UIImage(named: backgroundIcon)
        
        headPortraitBtn = UIButton(type: .custom)
        headPortraitBtn.layer.cornerRadius = BOUNDS_WIDTH/9
        headPortraitBtn.setImage(UIImage(named: headPortraitIcon), for: .normal)
        headPortraitBtn.clipsToBounds = true
        headPortraitBtn.addTarget(self, action: #selector(clickHeadPortrait), for: .touchUpInside)
        addSubview(headPortraitBtn)
        headPortraitBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(BOUNDS_WIDTH*60/375)
            make.width.height.equalTo(BOUNDS_WIDTH*80/375)
        }
        
        //用户名
        userNameLabel = UILabel()
        userNameLabel.textColor = UIColor.white
        userNameLabel.text = userName
        userNameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        self.addSubview(userNameLabel)
        userNameLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.headPortraitBtn.snp.bottom).offset(13)
            make.width.lessThanOrEqualTo(BOUNDS_WIDTH-50)
        }
    }
}
