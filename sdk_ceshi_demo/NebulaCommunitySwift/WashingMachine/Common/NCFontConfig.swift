//
//  NCFontConfig.swift
//  WashingMachine
//
//  Created by Harious on 2018/1/25.
//  Copyright © 2018年 Eteclabeteclab. All rights reserved.
//

import Foundation
import UIKit

let PingFangSC_Regular = "PingFangSC-Regular"
let PingFangSC_Medium = "PingFangSC-Medium"
let PingFangSC_Semibold = "PingFangSC-Semibold"
let _709_CAI978 = "709-CAI978"

///  PingFangSC_Regular 字体
public func font_PingFangSC_Regular(_ size: CGFloat) -> UIFont {
    return UIFont(name: PingFangSC_Regular, size: size) ?? UIFont.systemFont(ofSize: size)
}

public func font_PingFangSC_Medium(_ size: CGFloat) -> UIFont {
    return UIFont(name: PingFangSC_Medium, size: size) ?? UIFont.systemFont(ofSize: size)
}

public func font_PingFangSC_Semibold(_ size: CGFloat) -> UIFont {
    return UIFont(name: PingFangSC_Semibold, size: size) ?? UIFont.boldSystemFont(ofSize: size)
}

public func font_709_CAI978(_ size: CGFloat) -> UIFont {
    return UIFont(name: _709_CAI978, size: size) ?? UIFont.boldSystemFont(ofSize: size)
}

