//
//  HZUITextFieldExtension.swift
//  WashingMachine
//
//  Created by Harious on 2018/2/6.
//  Copyright © 2018年 Eteclabeteclab. All rights reserved.
//

import Foundation
import UIKit

public func createTextField(_ placeholder: String = "",
                            font: UIFont = UIFont.systemFont(ofSize: 15),
                            textColor: UIColor = UIColor.black) -> UITextField
{
    let textField = UITextField()
    textField.placeholder = placeholder
    textField.textColor = textColor
    textField.font = font
    return textField
}
