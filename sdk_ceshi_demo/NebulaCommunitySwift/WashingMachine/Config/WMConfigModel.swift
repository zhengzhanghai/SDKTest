//
//  WMConfigModel.swift
//  WashingMachine
//
//  Created by 郑章海 on 2020/10/14.
//  Copyright © 2020 Eteclabeteclab. All rights reserved.
//

import UIKit

class WMConfigModel: HZCodable {
    var id: Int
    var platformId: String
    var platformName: String
    /// 0 关闭  1 代开
    var flag: Bool
}
