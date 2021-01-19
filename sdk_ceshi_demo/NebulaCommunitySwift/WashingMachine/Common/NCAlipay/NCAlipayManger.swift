//
//  NCAlipayManger.swift
//  WashingMachine
//
//  Created by zzh on 2017/7/18.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

import UIKit

class NCAlipayManger: NSObject {
    internal static let instance = NCAlipayManger()
    var payCallBack: NCPayCallBackClourse?
    
    class func authInfo() {
        let authInfo = APAuthV2Info()
        authInfo.appID = AlipayAppId
        authInfo.pid = "sdf"
        authInfo.authType = "RSA2"
        var authInfoStr = authInfo.description
        let singer = RSADataSigner(privateKey: "")
        let signedStr = singer?.sign(authInfoStr)
        authInfoStr = authInfoStr+"&sign=\(signedStr ?? "")"+"&sign_type=RSA2"
        AlipaySDK.defaultService().auth_V2(withInfo: authInfoStr, fromScheme: AppScheme) { (res) in
            
        }
    }
    
    /// 调起支付
    ///
    /// - Parameters:
    ///   - payOrderStr: 签名串
    ///   - payCallBack: 回调闭包
    class func sendAlipay(_ payOrderStr: String, _ payCallBack: NCPayCallBackClourse?) {
        NCAlipayManger.instance.payCallBack = payCallBack
        let payResult = NCPayResult()
        payResult.type = .beforeEvokePayApp
        payResult.desp = "调起支付前最后回调"
        payCallBack?(payResult)
        AlipaySDK.defaultService().payOrder(payOrderStr, fromScheme: AppScheme) { (resultDic) in
            // 网页支付会走block回调
            DispatchQueue.main.async {
                if let resultStatus = resultDic?["resultStatus"] as? String {
                    let payResult = createPayResult(resultStatus)
                    payCallBack?(payResult)
                    
                    ZZPrint("*********  支付宝网页支付结果  ***********")
                    ZZPrint("-----   " + payResult.desp + "   -----")
                    ZZPrint("***********************************")
                }
            }
        }
    }
    
    /// 客户端支付，回调到AppDelegate,AppDelegate会调用此方法
    ///
    /// - Parameter resultDic: 回调闭包
    class func dealOpenURLResult(_ resultDic: [AnyHashable : Any]?) {
        if let resultStatus = resultDic?["resultStatus"] as? String {
            let payResult = createPayResult(resultStatus)
            NCAlipayManger.instance.payCallBack?(payResult)
            
            ZZPrint("*********  支付宝客户端支付结果  ***********")
            ZZPrint("-----   " + payResult.desp + "   -----")
            ZZPrint("***********************************")
        }
    }
    
    /// 根据支付宝回调的状态，创建支付结果
    ///
    /// - Parameter resultStatus: 回调code
    /// - Returns: 支付结果
    class func createPayResult(_ resultStatus: String) -> NCPayResult {
        let payResult = NCPayResult()
        switch resultStatus {
        case "9000":
            payResult.type = .success
            payResult.desp = "支付成功"
        case "8000":
            payResult.type = .inProgress
            payResult.desp = "正在处理中"
        case "4000":
            payResult.type = .defeated
            payResult.desp = "支付失败"
        case "5000":
            payResult.type = .rePayRequest
            payResult.desp = "重复支付请求"
        case "6001":
            payResult.type = .cancel
            payResult.desp = "取消了支付"
        case "6002":
            payResult.type = .networkError
            payResult.desp = "网络请求出错"
        case "6004":
            payResult.type = .unKnown
            payResult.desp = "支付结果未知"
        default:
            payResult.type = .otherError
            payResult.desp = "其他支付错误"
        }
        return payResult
    }
}
