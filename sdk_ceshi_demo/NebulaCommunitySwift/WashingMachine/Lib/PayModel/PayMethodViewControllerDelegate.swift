//
//  PayAbout.swift
//  Truck
//
//  Created by Moguilay on 16/9/20.
//  Copyright © 2016年 Eteclab. All rights reserved.
//

import Foundation
enum PaymentType {
    case alipay,wechat
}

protocol PayMethodViewControllerDelegate: class {
    func paymentSuccess(paymentType:PaymentType)
    func paymentFail(paymentType:PaymentType)
}
