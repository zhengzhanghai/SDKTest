//
//  WMButton.swift
//  WashingMachine
//
//  Created by ZZH on 2020/12/15.
//  Copyright © 2020 Eteclabeteclab. All rights reserved.
//

import UIKit

class WMButton: UIButton {

    var disabledBackgroundColor: UIColor?
    
    override var isEnabled: Bool {
        didSet {
            backgroundColor = isEnabled ? backgroundColor : (disabledBackgroundColor ?? backgroundColor)
        }
    }
}
