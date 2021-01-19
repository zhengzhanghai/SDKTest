//
//  BalanceManager.swift
//  WashingMachine
//
//  Created by Harious on 2018/4/8.
//  Copyright © 2018年 Eteclabeteclab. All rights reserved.
//

import UIKit
import SwiftyJSON

class UserBalanceManager {
    
    static let share = UserBalanceManager()
    
    private let balanceUserDefaultKey = "UserBalanceManager.balanceUserDefaultKey"
    
    /// 单位元
    var balance: Float? {
        
        guard let amount = balance_ else {
            guard let amountDisk = readBalanceFromDisk() else {
                self.asynRefreshBalance()
                return nil
            }
            
            self.balance_ = amountDisk
            
            return amountDisk
        }
        
        return amount
    }
    
    /// 单位元
    var balanceStr: String {
        return balance?.string(decimalPlaces: 2) ?? "__"
    }
    
    var balance_: Float?
    
    /// 充值余额
    func reSet() {
        balance_ = nil
        clearBalanceToDisk()
    }
    
    func loadBalance(callBackClosure: ((Bool , Float)->())?) {
        NetworkEngine.get(api_get_wallet_balance, parameters: ["userId": getUserId()]) { (result) in
            if result.isSuccess {
                
                /// 从服务器获取的单位是分
                guard let amount = JSON(result.dataObj)["data"].float else {
                    callBackClosure?(false, 0)
                    return
                }
                guard amount >= 0 else {
                    callBackClosure?(false, 0)
                    return
                }
                
                callBackClosure?(true, amount/100)
                
            } else {
                callBackClosure?(false, 0)
            }
        }
    }
    
    /// 异步刷新余额（从服务器获取）单位元
    func asynRefreshBalance(_ asynCallBackClosure: ((Bool , Float)->())? = nil) {
        loadBalance { (isSuccess, amount) in
            if isSuccess {
                self.balance_ = amount
                self.saveBalanceToDisk(balance: amount)
                
                asynCallBackClosure?(true, amount)
            } else {
                asynCallBackClosure?(false, 0)
            }
        }
    }
    
    /// 将余额存到磁盘,单位元
    func saveBalanceToDisk(balance: Float) {
        UserDefaults.standard.set(balance, forKey: balanceUserDefaultKey)
        UserDefaults.standard.synchronize()
    }
    
    /// 将余额从磁盘清除
    func clearBalanceToDisk() {
        UserDefaults.standard.removeObject(forKey: balanceUserDefaultKey)
        UserDefaults.standard.synchronize()
    }
    
    /// 从磁盘读取余额，单位元
    func readBalanceFromDisk() -> Float? {
        return UserDefaults.standard.value(forKey: balanceUserDefaultKey) as? Float
    }
}
