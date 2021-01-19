//
//  ZHPictureValidationManager.swift
//  IMageDemo
//
//  Created by 郑章海 on 2020/6/19.
//  Copyright © 2020 zzh. All rights reserved.
//

import UIKit

class ZHPictureValidationManager {
    
    public var validationView: ZHPictureValidationView
    
    private var currentStr: String = ""
    
    private let chars: [Character] = ["0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    
    var randomChars: [Character] {
        var array = [Character]()
        for _ in 0 ... 3 {
            array.append(chars[Int(arc4random()) % chars.count])
        }
        return array
    }
    
    init() {
        validationView = ZHPictureValidationView(frame: CGRect.zero)
        validationView.touchSelfAction = { [weak self] in
            self?.refreshCode()
        }
        refreshCode()
    }
    
    /// 刷新验证码
    public func refreshCode() {
        let chars = randomChars
        currentStr = String(chars)
        validationView.drawCharacters(chars)
    }
    
    /// 验证输入的码是否与图形上的一致
    public func validate(_ str: String) -> Bool {
        return str.lowercased() == currentStr.lowercased()
    }
}
