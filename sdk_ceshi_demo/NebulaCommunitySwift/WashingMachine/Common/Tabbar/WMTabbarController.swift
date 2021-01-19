//
//  WMTabbarController.swift
//  WashingMachine
//
//  Created by zzh on 17/3/3.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

import UIKit

let tabbarSelectOrderNotifation = "tabbarSelectOrderNotifation"

class WMTabbarController: UITabBarController {
    
    static let shareClient = WMTabbarController()
    var tabbarView: WMTabbarView!
    var centerController: UIViewController?
    var currentRootVC: UIViewController!
    var controllers: [UIViewController] = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.backgroundColor = UIColor.white.withAlphaComponent(0.9)
    }
    
    func reBuildTabbar() {
        self.tabBar.removeAllSubView()
        self.tabBar.addSubview(self.tabbarView)
    }
    
    func config(_ titles: [String]?, normalImages:[UIImage], selectedImages:[UIImage]) {
        self.tabbarView = WMTabbarView(frame: self.tabBar.bounds)
        self.tabbarView.addTabbarItem(selectedImages: selectedImages, normalImages: normalImages, titles: titles)
        self.tabbarView.currentIndexClourse = { (index: Int) in
            self.selectedIndex = index
            self.currentRootVC = self.controllers[index]
            if index == 2 {
               NotificationCenter.default.post(name: NSNotification.Name( rawValue: tabbarSelectOrderNotifation), object: nil)
            }
        }
        self.tabbarView.clickCenterClourse = { [weak self] in
            self?.enterScanningController()
        }
    }
    
    func enterScanningController() {
        if !isLogin() {
            let vc = LoginViewController()
            vc.hidesBottomBarWhenPushed = true
            self.currentRootVC.navigationController?.pushViewController(vc, animated: true)
        } else {
            self.currentRootVC = self.centerController
            self.present((self.centerController)!, animated: true, completion: nil)
        }
    }
    
    func setCurentNormalVCBecomeRootVC() {
        self.currentRootVC = self.controllers[self.selectedIndex];
    }
    
    func addCenter(_ image: UIImage, controller: UIViewController) {
        self.tabbarView.addCenterImage(image)
        self.centerController = controller
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.tabBar.removeAllSubView()
        self.tabBar.addSubview(self.tabbarView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
