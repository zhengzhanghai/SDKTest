//
//  MyOrder.swift
//  Truck
//
//  Created by Moguilay on 16/9/20.
//  Copyright © 2016年 Eteclab. All rights reserved.
//

import Foundation

/**
 *  支付宝model
 */
struct MyOrder {
    let id : Int
    let title : String
    let content: String
    let url: String
    let createdAt : String
    let price : Double
    let paid : Bool
    let productID : Int
    
    init(id : Int,
         title : String,
         content: String,
         url: String,
         createdAt : String,
         price : Double,
         paid : Bool,
         productID : Int) {
        self.id = id
        self.title = title
        self.content = content
        self.url = url
        self.createdAt = createdAt
        self.price = price
        self.paid = paid
        self.productID = productID
    }
}