//
//  HZLabelExtension.swift
//  WashingMachine
//
//  Created by zzh on 2017/9/18.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

import Foundation
import UIKit


// MARK: - 快捷创建UILabel
@discardableResult
public func createLabel(_ text: String = "",
                        textColor: UIColor = UIColor.black,
                        font: UIFont = UIFont.systemFont(ofSize: 17),
                        superView: UIView? = nil,
                        frame: CGRect = CGRect.zero) -> UILabel
{
    let label = UILabel()
    label.text = text
    label.textColor = textColor
    label.font = font
    label.frame = frame
    superView?.addSubview(label)
    return label
}

extension UILabel {
    
    var textWidth: CGFloat {
        if let attText = self.attributedText {
            return attText.boundingRect(with: CGSize(width: 10000, height: CGFloat(UInt.max)),
                                        options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                        context: nil).size.width+1
        }
        return 0
    }
}



