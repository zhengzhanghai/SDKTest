//
//  HomeTopView.swift
//  WashingMachine
//
//  Created by 郑章海 on 2020/12/17.
//  Copyright © 2020 Eteclabeteclab. All rights reserved.
//

import UIKit

fileprivate let menuTitles = ["扫码使用", "附近设备"]
fileprivate let menuIcons = ["menu_scan", "menu_search_device"]


class HomeTopView: WMGradientView {
    
    /// 点击菜单回调闭包
//    var clickMenuClourse: ((ItemType)->())?
    /// 点击扫描回调
    var scanClosure: (() -> ())?
    /// 点击附近回调
    var nearbyDeviceClosure:(() -> ())?
    /// 点击地址回调闭包
    var clickAddressClourse: (()->())?
    /// 点击消息回调闭包
    var clickNoticeClourse: (()->())?
    var locationLabel: UILabel!
   
    
    fileprivate(set) lazy var topView: UIView = { [unowned self] in
        let view = UIView()
        
        let locationBGBtn = UIButton(type: .custom)
        locationBGBtn.addTarget(self, action: #selector(clickLocationBtn(_:)), for: .touchUpInside)
        view.addSubview(locationBGBtn)
        locationBGBtn.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalToSuperview()
            make.height.equalTo(20)
        }
        
        let locationIcon = UIImageView()
        locationIcon.image = UIImage(named: "location_black")
        locationBGBtn.addSubview(locationIcon)
        locationIcon.snp.makeConstraints { (make) in
            make.left.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        locationLabel = UILabel()
        locationLabel.textColor = UIColor(rgb: 0x333333)
        locationLabel.font = font_PingFangSC_Medium(14)
        locationLabel.text = ""
        locationBGBtn.addSubview(locationLabel)
        locationLabel.snp.makeConstraints { (make) in
            make.left.equalTo(locationIcon.snp.right)
            make.right.centerY.equalToSuperview()
        }
        
        let noticeBtn = UIButton(type: .custom)
        noticeBtn.setImage(UIImage(named: "notice_black"), for: .normal)
        noticeBtn.addTarget(self, action: #selector(clickNoticeBtn(_:)), for: .touchUpInside)
        view.addSubview(noticeBtn)
        noticeBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        return view
    }()
    
    fileprivate lazy var menuBGView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.addShadow(offset: CGSize(width: 0, height: 4), opacity: 1, color: UIColor(rgb: 0x000000).withAlphaComponent(0.1), radius: 10)
        return view
    }()
    
    fileprivate lazy var scanBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.titleLabel?.font = font_PingFangSC_Medium(14)
        btn.setTitle("扫码使用", for: .normal)
        btn.setTitleColor(UIColor(rgb: 0x333333), for: .normal)
        btn.setImage(UIImage(named: "menu_scan"), for: .normal)
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        return btn
    }()
    
    fileprivate lazy var nearbyBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.titleLabel?.font = font_PingFangSC_Medium(14)
        btn.setTitleColor(UIColor(rgb: 0x333333), for: .normal)
        btn.setTitle("附近设备", for: .normal)
        btn.setImage(UIImage(named: "menu_search_device"), for: .normal)
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        return btn
    }()
    
    /// 中间的菜单视图
    lazy var pageMenuView: HZFixationMenuView = {
        let deviceView = HZFixationMenuView(["当前", "订单"], false)
        deviceView.layoutType = .left
        deviceView.textFont = font_PingFangSC_Semibold(14)
        deviceView.textSelectedFont = font_PingFangSC_Semibold(18)
        deviceView.normalColor = UIColor(rgb: 0x999999)
        deviceView.selectedColor = UIColor(rgb: 0x333333)
        deviceView.lineColor = UIColor(rgb: 0x3399ff)
        deviceView.backgroundColor = .clear
        deviceView.startMakeItem()
        return deviceView
    }()
    
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.clipsToBounds = true
        self.backgroundColor = .white
            
        
        addGradientLayer(colors: [UIColor(rgb: 0xebf5ff), UIColor(rgb: 0xfafafa)], direction: .vertical)
        addEvent()
    
        addSubview(topView)
        addSubview(menuBGView)
        menuBGView.addSubview(scanBtn)
        menuBGView.addSubview(nearbyBtn)
        addSubview(pageMenuView)
        
        topView.snp.makeConstraints { (make) in
            make.top.equalTo(STATUSBAR_ABSOLUTE_HEIGHT)
            make.left.right.equalToSuperview()
            make.height.equalTo(48)
        }
        menuBGView.snp.makeConstraints { (make) in
            make.top.equalTo(topView.snp.bottom).offset(16)
            make.left.equalTo(24)
            make.right.equalTo(-24)
            make.height.equalTo(88)
        }
        scanBtn.snp.makeConstraints { (make) in
            make.top.left.height.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
        }
        nearbyBtn.snp.makeConstraints { (make) in
            make.top.right.height.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
        }
        pageMenuView.snp.makeConstraints { (make) in
            make.top.equalTo(menuBGView.snp.bottom).offset(30)
            make.left.equalTo(0)
            make.width.equalTo(180)
            make.height.equalTo(48)
            make.bottom.equalTo(-16)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: 事件
fileprivate extension HomeTopView {
    
    func addEvent() {
        scanBtn.addTarget(self, action: #selector(clickScanBtn), for: .touchUpInside)
        nearbyBtn.addTarget(self, action: #selector(clickNearbyBtn), for: .touchUpInside)
    }
    
    @objc func clickScanBtn() {
        scanClosure?()
    }
    
    @objc func clickNearbyBtn() {
        nearbyDeviceClosure?()
    }
    
    
    @objc func clickNoticeBtn(_ btn: UIButton) {
        clickNoticeClourse?()
    }
    
    
    @objc func clickLocationBtn(_ btn: UIButton) {
        clickAddressClourse?()
    }
    
}
