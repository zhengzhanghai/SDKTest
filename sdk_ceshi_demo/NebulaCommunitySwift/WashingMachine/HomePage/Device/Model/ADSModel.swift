//
//  ADSModel.swift
//  WashingMachine
//
//  Created by zzh on 2017/8/10.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

import UIKit

struct ADSModel: HZCodable {
    var id: Int
    var name: String
    var status: Int //状态 -1删除 0未生效  1生效
    var redirectType: Int //跳转类型（0不跳转  1应用内部网页  2应用内部界面  3外部网页）
    var location: Int  //展示位置 1首页
    var redirectAddress: String  //跳转地址
    var image: String  //广告图片
    var time: Int  //广告时长
    var desp: String? //描述
}


