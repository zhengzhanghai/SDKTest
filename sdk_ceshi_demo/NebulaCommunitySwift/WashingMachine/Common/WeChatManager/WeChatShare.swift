//
//  WeChatShare.swift
//  WashingMachine
//
//  Created by zzh on 2017/7/14.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

import UIKit

class WeChatShare: NSObject {
    var title: String?
    var desp: String?
    var image: UIImage?
    var webpageUrl: String?
    var type: WeChatShareType = .circleFriend
    
    func typeIndex() -> Int32 {
        switch type {
            case .friend:
                return 0
            case .circleFriend:
                return 1
            case .favorite:
                return 2
        }
    }
}
