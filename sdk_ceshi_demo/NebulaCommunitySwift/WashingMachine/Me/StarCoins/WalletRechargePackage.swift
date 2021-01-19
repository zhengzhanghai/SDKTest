//
//  WalletRechargePackage.swift
//  WashingMachine
//
//  Created by Harious on 2018/4/9.
//  Copyright © 2018年 Eteclabeteclab. All rights reserved.
//

import Foundation

struct WalletRechargePackage: HZCodable {
    
    let id: Int
    let nebulaCoin: Int
    let price: Float // 单位分
    let sort: Int
    let status: Int
    let createTime: Int
}


