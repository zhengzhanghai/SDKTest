//
//  AppDelegateExtension.swift
//  WashingMachine
//
//  Created by ZZH on 2020/12/6.
//  Copyright © 2020 Eteclabeteclab. All rights reserved.
//

import Foundation
import Kingfisher

var discoverADSLoadCount = 0

extension AppDelegate {
    func changeDiscoverIfNeed() {
        
        guard discoverADSLoadCount < 7 else {
            return
        }
        
        if let discoverModel = ADSManager.discoverModel {
            changeDiscoverPageWhenNotOnDiscoverPage(model: discoverModel)
        } else {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.1) {
                self.changeDiscoverIfNeed()
            }
        }
    }
    
    func changeDiscoverPageWhenNotOnDiscoverPage(model: SSPADSModel) {
        guard let imageStr = model.submit_image else { return }
        guard let imageUrl = URL(string: imageStr) else { return }
        ImageDownloader.default.downloadImage(with: imageUrl, retrieveImageTask: nil, progressBlock: nil) { (image, error, url, data) in
            if let image = image {
                self.changeDiscoverViewControllerOfTabbarToADSViewControllerIfNeed(image: image, model: model)
            }
        }
    }
    
    func changeDiscoverViewControllerOfTabbarToADSViewControllerIfNeed(image: UIImage, model: SSPADSModel) {
        guard let tabbarVC = self.tabController else { return }
        // 如果当前处于发现页，不能去改变tabbar上的发现页
        guard tabbarVC.selectedIndex != 1 else { return }
        guard let urlStr = model.lp else { return }
        guard let url = URL(string: urlStr) else { return }
        
        (nc_appdelegate?.tabController as? MainTabbarViewController)?.changeToADSPageFromDiscover(adsURL: url, itemTitle: "爱淘2020", itemImage: image)
    }
}


