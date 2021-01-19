//
//  SettingViewController.swift
//  Tracker
//
//  Created by 张丹丹 on 16/9/7.
//  Copyright © 2016年 张丹丹. All rights reserved.
// 设置

import UIKit
import Kingfisher

class SettingViewController: BaseViewController {
    
    var blockClourse:(()->())?
    fileprivate var bigBackV:UIView?
    fileprivate var cachLabel:UILabel?
    fileprivate var notiSwitch: UISwitch!
    fileprivate let JPUSH_USERDEFAULT_KEY = "jpush_userdefault_key"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = UIColor.white
        
        self.navigationItem.title = "设置"
        self.makeUI()
      
        NotificationCenter.default.addObserver(self, selector: #selector(appEnterForegriund), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc fileprivate func appEnterForegriund() {
        if isOpenUserNotifation() {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.registerJPUSH()
            let isOpen = UserDefaults.standard.value(forKey: JPUSH_USERDEFAULT_KEY) as? NSNumber ?? 1
            notiSwitch.isOn = isOpen.boolValue
            UserDefaults.standard.set(isOpen, forKey: JPUSH_USERDEFAULT_KEY)
        } else {
            notiSwitch.isOn = false
            UserDefaults.standard.set(0, forKey: JPUSH_USERDEFAULT_KEY)
        }
    }
    

    fileprivate func isOpenUserNotifation() -> Bool {
        let userNotifationType = UIApplication.shared.currentUserNotificationSettings?.types
        if userNotifationType?.rawValue != 0 {
            print("\n设置里通知--打开\n")
            return true
        } else {
            print("\n设置里通知--关闭\n")
            return false
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func makeUI() {
        
        let label1 = UILabel()
        label1.text = "消息推送"
        label1.textColor = THEMEGRAYCOLOR
        label1.font = UIFont.systemFont(ofSize: 16)
        label1.frame =  CGRect(x: 12.0,
                               y: 20.0,
                               width: label1.text?.textWidth(label1.font, maxWidth: BOUNDS_WIDTH-100) ?? 0,
                               height: 20.0)
        self.view.addSubview(label1)
        
        let swich = UISwitch()
        swich.onTintColor = THEMECOLOR
        swich.addTarget(self, action: #selector(noticePush( _:)), for: .touchUpInside)
        swich.frame = CGRect(x: BOUNDS_WIDTH-51-12, y: 10.0, width: 51, height: 31.0)
        self.view.addSubview(swich)
        notiSwitch = swich
        
        if isOpenUserNotifation() {
            let isOpen = UserDefaults.standard.value(forKey: JPUSH_USERDEFAULT_KEY) as? NSNumber ?? 1
            swich.isOn = isOpen.boolValue
        }
        
        
        
        
        let line1 = UIView()
        line1.backgroundColor = UIColor(rgb: 0xdddddd)
        line1.frame = CGRect(x: 12.0, y: swich.frame.maxY+15.0, width: BOUNDS_WIDTH-24, height: 1.0)
        self.view.addSubview(line1)
        
       let btn1 = UIButton()
        btn1.backgroundColor = UIColor.clear
        btn1.addTarget(self, action: #selector(clickAboutUs), for: .touchUpInside)
        btn1.frame = CGRect(x: 12.0, y: line1.frame.maxY, width: BOUNDS_WIDTH-24, height: 56)
        self.view.addSubview(btn1)
        
        let label2 = UILabel()
        label2.text = "关于我们"
        label2.textColor = THEMEGRAYCOLOR
        label2.font = UIFont.systemFont(ofSize: 16)
        label2.frame =  CGRect(x: 0.0,
                               y: 20.0,
                               width: label2.text?.textWidth(label1.font, maxWidth: BOUNDS_WIDTH-100) ?? 0,
                               height: 20.0)
        btn1.addSubview(label2)
        
        let img = UIImageView()
        img.image = UIImage(named:"enter")
        img.frame = CGRect(x: btn1.frame.maxX-24-12, y: 16, width: 24, height: 24)
        btn1.addSubview(img)
        
        let line2 = UIView()
        line2.backgroundColor = UIColor(rgb: 0xdddddd)
        line2.frame = CGRect(x: 12.0, y: btn1.frame.maxY, width: BOUNDS_WIDTH-24, height: 1.0)
        self.view.addSubview(line2)
        
        
        let btn2 = UIButton()
        btn2.backgroundColor = UIColor.clear
        btn2.addTarget(self, action: #selector(clearCach), for: .touchUpInside)
        btn2.frame = CGRect(x: 12.0, y: line2.frame.maxY, width: BOUNDS_WIDTH-24, height: 56)
        self.view.addSubview(btn2)
        
        let label3 = UILabel()
        label3.text = "清除缓存"
        label3.textColor = THEMEGRAYCOLOR
        label3.font = UIFont.systemFont(ofSize: 16)
        label3.frame =  CGRect(x: 0.0,
                               y: 20.0,
                               width: label3.text?.textWidth(label1.font, maxWidth: BOUNDS_WIDTH-100) ?? 0,
                               height: 20.0)
        btn2.addSubview(label3)
        
        
        cachLabel = UILabel()
        cachLabel?.textColor = UIColor(rgb:0x666666)
        cachLabel?.font = UIFont.systemFont(ofSize: 16)
        KingfisherManager.shared.cache.calculateDiskCacheSize { (totalSize) in
            self.cachLabel?.text  = "\(totalSize/(1024*1024))M"
        }
        cachLabel!.frame = CGRect(x: btn2.frame.maxX-160-12, y: 20.0, width: 160, height: 20.0)
        cachLabel?.textAlignment = .right
        btn2.addSubview(cachLabel!)
        
        
        let line3 = UIView()
        line3.backgroundColor = UIColor(rgb: 0xdddddd)
        line3.frame = CGRect(x: 12.0, y: btn2.frame.maxY, width: BOUNDS_WIDTH-24, height: 1.0)
        self.view.addSubview(line3)
        
        if !isLogin() {
            return
        }
        let logoutbBtn = UIButton()
        logoutbBtn.backgroundColor = THEMECOLOR
        logoutbBtn.layer.cornerRadius = 4
        logoutbBtn.setTitle("退出", for: UIControl.State())
        logoutbBtn.addTarget(self, action: #selector(clickToLogout), for: .touchUpInside)
        logoutbBtn.setTitleColor(UIColor.white, for: UIControl.State())
        logoutbBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        logoutbBtn.frame = CGRect(x: 12, y: BOUNDS_HEIGHT-36-48-64, width: BOUNDS_WIDTH-24, height: 48)
        self.view.addSubview(logoutbBtn)
   
    }
    
    //消息推送
    @objc fileprivate func noticePush(_ swich:UISwitch) {
        if swich.isOn {
            if isOpenUserNotifation() {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.registerJPUSH()
                UserDefaults.standard.set(1, forKey: JPUSH_USERDEFAULT_KEY)
            } else {
                swich.isOn = false
                let alertController = UIAlertController(title: "提示", message: "请先在设置里打开通知", preferredStyle: UIAlertController.Style.alert)
                let sureAction = UIAlertAction(title: "确定", style: UIAlertAction.Style.destructive) { (_) in
                }
                alertController.addAction(sureAction)
                present(alertController, animated: true, completion: nil)
                swich.isOn = false
            }
        } else {
            UIApplication.shared.unregisterForRemoteNotifications()
            UserDefaults.standard.set(0, forKey: JPUSH_USERDEFAULT_KEY)
        }
    }
    //关于我们
    @objc fileprivate func clickAboutUs() {
        let aboutUsVC = AboutUSViewController()
        aboutUsVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(aboutUsVC, animated: true)
    }
    
    //清除缓存
    @objc fileprivate func clearCach() {
        let alertController = UIAlertController(title: "提示", message: "确定要清除缓存吗", preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: nil)
        let sureAction = UIAlertAction(title: "确定", style: UIAlertAction.Style.destructive) { (_) in
            //清除缓存
            let cache = KingfisherManager.shared.cache
            cache.clearMemoryCache()
            // 清理硬盘缓存，这是一个异步的操作
            cache.clearDiskCache()
            // 清理过期或大小超过磁盘限制缓存。这是一个异步的操作
            cache.cleanExpiredDiskCache()
            cache.calculateDiskCacheSize(completion: { (totalSize) in
                self.cachLabel?.text  = "\(totalSize/(1024*1024))M"
            })
        }
        alertController.addAction(cancelAction)
        alertController.addAction(sureAction)
        present(alertController, animated: true, completion: nil)
     
    }
    //点击 退出
    @objc fileprivate func  clickToLogout() {

        if isLogin() {
            bigBackV = UIView()
            bigBackV?.backgroundColor = UIColor.init(white: 0.3, alpha: 0.5)
            bigBackV?.isUserInteractionEnabled = true
            bigBackV?.frame = CGRect(x: 0, y: 0, width: BOUNDS_WIDTH, height: BOUNDS_HEIGHT)
            
            let window = UIApplication.shared.keyWindow
            window?.addSubview(bigBackV!)
            
            let popV = UIView()
            popV.layer.masksToBounds = true
            popV.layer.cornerRadius = 4
            popV.backgroundColor = UIColor.white
            bigBackV?.addSubview(popV)
            popV.snp.makeConstraints({ (make) in
                make.centerX.centerY.equalToSuperview()
                make.width.equalTo(BOUNDS_WIDTH*0.75)
            })
            
            let titleLabel = UILabel()
            titleLabel.text = "确定退出吗"
            titleLabel.textColor = UIColor(rgb: 0x3D3D3D)
            titleLabel.font = UIFont.systemFont(ofSize: 16)
            popV.addSubview(titleLabel)
            titleLabel.snp.makeConstraints({ (make) in
                make.centerX.equalToSuperview()
                make.top.equalTo(24)
            })
            
            let line = UIView()
            line.backgroundColor = UIColor(rgb:0xECECEC)
            popV.addSubview(line)
            line.snp.makeConstraints({ (make) in
                make.left.right.equalToSuperview()
                make.top.equalTo(titleLabel.snp.bottom).offset(24)
                make.height.equalTo(1)
            })
            
            let line1 = UIView()
            line1.backgroundColor = UIColor(rgb:0x666666)
            popV.addSubview(line1)
            line1.snp.makeConstraints({ (make) in
                make.centerX.equalToSuperview()
                make.top.equalTo(line.snp.bottom).offset(10)
                make.bottom.equalTo(-10)
                make.width.equalTo(1)
                make.height.equalTo(25)
            })
            
            let closeBtn = UIButton()
            closeBtn.setTitle("取消", for:UIControl.State())
            closeBtn.setTitleColor(UIColor(rgb:0x459DF5), for: UIControl.State())
            closeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            closeBtn.addTarget(self, action: #selector(closeQuitView), for: .touchUpInside)
            popV.addSubview(closeBtn)
            closeBtn.snp.makeConstraints({ (make) in
                make.left.bottom.equalToSuperview()
                make.top.equalTo(line.snp.bottom)
                make.right.equalTo(line1.snp.left)
            })
            
            
            let btn = UIButton()
            btn.setTitleColor(UIColor(rgb:0x459DF5), for: UIControl.State())
            btn.setTitle( "确定", for: UIControl.State())
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            btn.addTarget(self, action: #selector(sureToQuit), for: .touchUpInside)
            popV.addSubview(btn)
            btn.snp.makeConstraints({ (make) in
                make.right.bottom.equalToSuperview()
                make.top.equalTo(line.snp.bottom)
                make.left.equalTo(line1.snp.right)
            })
            
        }else{
            showError("请先登录", superView: self.view)
        }
    }
    
    @objc fileprivate func closeQuitView() {
        bigBackV?.removeFromSuperview()
    }
    
    @objc fileprivate func  sureToQuit() {
        bigBackV?.removeFromSuperview()
        self.showWaitingView(nc_appdelegate?.window ?? self.view, "退出中")
        LoginViewModel.loginOut(getToken()) { (isSuccess, message) in
            self.hiddenWaitingView()
            if isSuccess {
                
                /// 清空全局及沙河的学校认证信息
                AuthSchool.clear()
                
                /// 清除服务器中与用户id绑定的极光设备关联信息
                LoginViewModel.updateJPushRegister(getUserId(), jpushId: "0", nil)
                
                self.blockClourse?()
                UserInfoModel.deleteLocal()
                UserBaseInfoModel.deleteLocal()
                UserBalanceManager.share.reSet()
                postNotication(LOGIN_OUT_NOTIFICATION, nil, nil)
                self.navigationController?.popViewController(animated: true)
            } else {
                showError(message, superView: self.view)
            }
        }
    }
}
