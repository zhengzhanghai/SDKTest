//
//  UIQuickly.swift
//  WashingMachine
//
//  Created by ZZH on 2020/12/15.
//  Copyright © 2020 Eteclabeteclab. All rights reserved.
//

import UIKit

extension UILabel {
    class func create(font: UIFont = UIFont.systemFont(ofSize: 15),
                      textColor: UIColor = .black,
                      text: String = "",
                      textAlignment: NSTextAlignment = .left) -> UILabel
    {
        let label = UILabel()
        label.font = font
        label.textColor = textColor
        label.text = text
        label.textAlignment = textAlignment
        return label
    }
}

extension UITextField {
    class func create(font: UIFont = UIFont.systemFont(ofSize: 15),
                textColor: UIColor = UIColor.black,
                placeholder: String = "",
                
                placeholderTextColor: UIColor = UIColor.gray,
                placeholderFont: UIFont? = nil,
                delegate: UITextFieldDelegate? = nil,
                clearMode: ViewMode = .whileEditing,
                isSecureTextEntry: Bool = false) -> Self
    {
        let textField = UITextField()
        textField.font = font
        textField.textColor = textColor
        textField.placeholder = placeholder
        let placeholderStr = NSMutableAttributedString(string: placeholder, attributes: [NSAttributedString.Key.font : placeholderFont ?? font,NSAttributedString.Key.foregroundColor : placeholderTextColor])
        textField.attributedPlaceholder = placeholderStr
        textField.delegate = delegate
        textField.clearButtonMode = clearMode
        textField.isSecureTextEntry = isSecureTextEntry
        return textField as! Self
    }
}

extension UIView {
    func addBottomLine(color: UIColor,
                       lineWidth: CGFloat,
                       edge: UIEdgeInsets = UIEdgeInsets.zero)
    {
        let line = UIView()
        line.backgroundColor = color
        addSubview(line)
        
        line.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.left.equalTo(edge.left)
            make.right.equalTo(-edge.right)
            make.height.equalTo(lineWidth)
        }
    }
}
