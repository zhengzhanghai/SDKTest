//
//  ADSModel.swift
//  WashingMachine
//
//  Created by 郑章海 on 2020/10/12.
//  Copyright © 2020 Eteclabeteclab. All rights reserved.
//

import UIKit

class SSPADSModel: HZCodable {
    class EM: HZCodable {
        var e1: [String]?
        var e5: [String]?
    }
    
    var id: Int
    ///广告形式：1.开屏；2.横幅；3.插屏；4.焦点图；5.信息流；6.文字链；7.图标
    var type: Int
    /// 广告点击触发方式
    ///1. 无动作，此时广告仅用于曝光，应答中没有点击监控链接，点击不会进行任何操作；
    ///2. 点击跳转，客户端在用户点击后跳转到 lp 字段地址，并上报点击监控信息；
    ///3. 下载应用，此时 lp 字段可能为一个应用的下载链接，客户端在用户点击后需要开始下载该应用，上报点击监控 cm ，并判断是否有事件监控 em 需要上报；
    ///4. APP 唤起，客户端在用户点击后尝试使用 deeplink 字段唤起 app，如果唤起失败，请跳转 lp 字段地址，上报点击监控 cm，并判断是否有事件监控 em 需要上报；
    ///5. 跳转到微信小程序，客户端在用户点击后使用wxoid/wxp 跳转到微信小程序页面，跳转小程序失败则跳转 lp 字段地址，并上报点击监控
    var action: Int
    /// 标题
    var title: String?
    /// 描述
    var desc: String?
    ///广告类型：1.品牌，2. 效果
    var cat: Int
    ///点击监控地址，在点击后必须在客户端逐个上报完毕
    var cm: [String]
    ///深度链接
    var deeplink:String?
    ///事件监控信息
    var em: EM
    ///图片地址
    var image: String
    var fullimage: String?
    ///用户点击后广告的跳转地址,可能为空
    var lp: String?
    ///曝光监控地址，在曝光后必须在客户端逐个上报完毕
    var pm: [String]
    ///是否添加APP信息
    var add_logo: Int?
    /// 发现tabbar展示的图片
    var submit_image: String?
    
}
