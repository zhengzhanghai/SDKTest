//
//  NetworkResult.swift
//  WashingMachine
//
//  Created by zzh on 16/11/1.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

import UIKit

class NetworkResult: NSObject {
    
    var sourceDict: [String: AnyObject]? = nil
    var error: Error?
    
    class func resultWithDict(_ dict: [String: AnyObject]) -> NetworkResult {
        let result = NetworkResult()
        result.sourceDict = dict
        return result
    }
    
    /// 获取网络请求状态码
    var code : Int {
        return ((self.dataObj as? [String: AnyObject])?["code"] as? NSNumber)?.intValue ?? 0
    }
    
    /// 获取网络请求提示信息
    var message : String {
        return self.error?.message ?? ((self.sourceDict?["message"] as? String) ?? "")
    }
    
    /// 服务器返回状态 1000
    var isSuccess : Bool {
        return (self.code == 1000)
    }
    
    /// 服务器返回状态 204
    var isError204 : Bool {
        return (self.code == 204)
    }
    
    /// 服务器返回状态 1000 或 者204
    var isSuccessOr204 : Bool {
        return (self.code == 1000 || self.code == 204)
    }
    
    /// 获取所需要的数据
    var dataObj : AnyObject {
        return sourceDict as AnyObject
    }
}
