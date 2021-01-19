//
//  WMConfig.swift
//  WashingMachine
//
//  Created by 郑章海 on 2020/10/14.
//  Copyright © 2020 Eteclabeteclab. All rights reserved.
//

import UIKit

class WMConfig {
    static let shared = WMConfig()
    private let SSPKey = "SSP_switch_userdefault_key"
    
    /// 是否获取过
    var isLoaded = false
    /// SSP广告开关是否开启
    var isOpenSSPADS = false
    
    init() {
        isOpenSSPADS = UserDefaults.standard.bool(forKey: SSPKey)
    }
    
    /// 获取广告配置
    func loadConfig(finish: (() -> ())?) {
        guard !isLoaded else {
            finish?()
            return
        }
        
        let url = "https://nebulaedu.com/api/v1/advertising/queryflag"
        let param = ["userId": getUserId(),
                     "schoolId": getUserSchoolId(),
                     "token": getToken()]
        
        NetworkEngine.get(url, parameters: param) { (result) in
            defer { finish?() }
            guard result.isSuccess else { return }
            guard let data = result.sourceDict?["data"] as? [String: AnyObject] else {return}
            guard let platforms = data["platform"] as? [[String: AnyObject]] else {return}
            
            for dict in platforms {
                if let id = dict["id"] as? Int, let flag = dict["flag"] as? Bool, id == 1 {
                    self.isOpenSSPADS = flag
                    UserDefaults.standard.set(self.isOpenSSPADS, forKey: self.SSPKey)
                    UserDefaults.standard.synchronize()
                    self.isLoaded = true
                    break
                }
            }
        }
    }
    
    
}
