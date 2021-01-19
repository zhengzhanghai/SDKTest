//
//  NCPayManager.swift
//  WashingMachine
//
//  Created by zzh on 2017/7/17.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

import UIKit
import SwiftyJSON

///  支付渠道，枚举的值是统一下单支付渠道的参数值
enum NCPayChannel: String {
    case wechat = "wx" //微信
    case alipay = "alipay" //支付宝
    case wechatPublic = "wx_pub" //微信公众号支付
    case nebula    // 星云支付
}

typealias NCPayCallBackClourse = ((NCPayResult)->())

class NCPayManager: NSObject {
    
    internal static let shareClient = NCPayManager()
    
    
    /// 发起支付
    ///
    /// - Parameters:
    ///   - payMessage: 支付相关信息
    ///   - businessOrderId: 订单id
    ///   - checkBeforeOrder: 在统一下单下，是否对业务订单进行检测
    ///   - payCallBack: 回调
    class func sendPay(_ payMessage: NCPayMessage,
                       businessOrderId: String,
                       checkBeforeOrder: Bool = true,
                       _ payCallBack: NCPayCallBackClourse?)
    {
        
        if payMessage.channel == .nebula {
            ZZPrint("使用余额支付")
            self.nebulaPay(payMessage: payMessage, payCallBack)
        } else if checkBeforeOrder {
            ZZPrint(" ✅  统一下单前检验了订单，看是否可以去支付下单  ")
            NCPayManager.shareClient.payCheck(payMessage, businessOrderId, payCallBack)
        } else {
            ZZPrint(" ❌  统一下单前没有检验订单  ")
            NCPayManager.shareClient.unifyOrder(payMessage, payCallBack)
        }
    }
    
    class func nebulaPay(payMessage: NCPayMessage, _ payCallBack: NCPayCallBackClourse?) {
        let parameters = ["userId": getUserId(), "orderId": payMessage.orderId ?? ""] as [String: Any]
        NetworkEngine.get(api_get_star_coins_pay, parameters: parameters) { (result) in
            let payResult = NCPayResult()
            payResult.type = result.isSuccess ? .success : .defeated
            payResult.desp = result.message
            payCallBack?(payResult)
        }
    }
    
    /// 充值
    class func nebulaRecharge(packageId: Int, userId: String, payWay: PayWay, rechargeCallBack: NCPayCallBackClourse?) {
        let parameters = ["packageId": packageId, "userId": userId] as [String: Any]
        NetworkEngine.get(api_get_star_coins_recharge_order, parameters: parameters, completionClourse: { (result) in
            
            if result.isSuccess {
                guard let dataDict = (result.dataObj as? [String: Any])?["data"] as? [String: Any] else {
                    let payResult = NCPayResult()
                    payResult.type = .beforePayError
                    payResult.desp = "下单失败"
                    rechargeCallBack?(payResult)
                    return
                }

                let payMessage = NCPayMessage(appId: dataDict["appId"] as? String ?? "",
                                              orderSn: dataDict["rechargeNo"] as? String ?? "",
                                              amount: (dataDict["price"] as? Int)?.stringValue ?? "0",
                                              channel: payWay == .alipay ? .alipay : .wechat,
                                              subject: "星云社区",
                                              body: "星云社区余额充值")
                NCPayManager.shareClient.unifyOrder(payMessage, rechargeCallBack)
                
            } else {
                let payResult = NCPayResult()
                payResult.type = .beforePayError
                payResult.desp = result.message
                rechargeCallBack?(payResult)
            }
        })
    }
    
    class func nebulaRecharge(payMessage: NCPayMessage, rechargeCallBack: NCPayCallBackClourse?) {
        NCPayManager.shareClient.unifyOrder(payMessage, rechargeCallBack)
    }
    
    /// 创建掉起支付前的错误结果
    ///
    /// - Parameter message: 错误信息
    func createBeforePayErrorResult(_ message: String) -> NCPayResult {
        let result = NCPayResult()
        result.type = .beforePayError
        result.desp = message
        return result
    }
    
    /// 检测用户是否已经支付
    ///
    /// - Parameters:
    ///   - payMessage: 支付信息
    ///   - businessOrderId: 业务订单号
    ///   - payCallBack: 支付回调
    func payCheck(_ payMessage: NCPayMessage,_ businessOrderId: String, _ payCallBack: NCPayCallBackClourse?) {
        let url = API_GET_PAY_CHECK + String(format: "?userId=%@&orderId=%@", getUserId(), businessOrderId)
        NetworkEngine.get(url, parameters: nil) { (result) in
            if result.isSuccess {
                self.unifyOrder(payMessage, payCallBack)
            } else {
                payCallBack?(self.createBeforePayErrorResult(result.message))
            }
        }
    }
    
    /// 统一下单
    ///
    /// - Parameter payMessage: 支付信息
    func unifyOrder(_ payMessage: NCPayMessage, _ payCallBack: NCPayCallBackClourse?) {
        var params = [String: AnyObject]()
        params["appId"] = payMessage.appId as AnyObject
        params["orderSn"] = payMessage.orderSn as AnyObject
        params["amount"] = payMessage.amount as AnyObject
        params["channel"] = payMessage.channel.rawValue as AnyObject
        params["subject"] = payMessage.subject as AnyObject
        params["body"] = payMessage.body as AnyObject
        if payMessage.customChannel != nil {
            params["customChannel"] = payMessage.customChannel as AnyObject
        }
        if payMessage.productCode != nil {
            params["productCode"] = payMessage.productCode as AnyObject
        }
        let url = PAY_UNIFY_ORDER
        NetworkEngine.postJSON(url, parameters: params) { (result) in
            if result.isSuccess {
                if let dict = result.dataObj as? [String: AnyObject] {
                    if let data = dict["data"] as? [String: AnyObject] {
                        if payMessage.channel == NCPayChannel.wechat { // 微信
                            self.sendWeChatPay(data, payCallBack)
                        } else if payMessage.channel == NCPayChannel.alipay { // 支付宝
                            if let payOrderStr = data["data"] as? String {
                                self.sendAlipay(payOrderStr, payCallBack)
                            }
                        }
                    }
                }
            } else {
                payCallBack?(self.createBeforePayErrorResult(result.message))
            }
        }
    }
    
    
    /// 调起微信发起支付
    ///
    /// - Parameter data: 微信支付需要的参数
    func sendWeChatPay(_ data: [String: AnyObject], _ payCallBack: NCPayCallBackClourse?) {
        let request = PayReq()
        request.partnerId = WXPartnerId;
        /** 预支付订单 */
        if let prePayId = data["prePayId"] as? String {
            request.prepayId = prePayId
        }
        /** 商家根据财付通文档填写的数据和签名 */
        request.package = "Sign=WXPay"
        /** 随机串，防重发 */
        if let nonceStr = data["nonceStr"] as? String {
            request.nonceStr = nonceStr
        }
        /** 时间戳，防重发 */
        if let timeStr = data["timeStamp"] as? String {
            let timeNum = NumberFormatter().number(from: timeStr)
            request.timeStamp = (timeNum?.uint32Value)!
        }
        if let sign = data["paySign"] as? String {
            request.sign = sign
        }
        WeChatManager.instance.payCallBack = payCallBack
        WeChatManager.sendPay(request)
    }
    
    /// 掉起支付宝发起支付
    ///
    /// - Parameter payOrderStr: 支付宝支付需要的参数
    func sendAlipay(_ payOrderStr: String, _ payCallBack: NCPayCallBackClourse?) {
        NCAlipayManger.sendAlipay(payOrderStr, payCallBack)
    }
    
    /// 支付结果常规处理
    ///
    /// - Parameters:
    ///   - payResult: 支付结果
    ///   - controller: 支付控制器
    ///   - success: 成功支付回调
    class func dealPayResult(_ payResult: NCPayResult, _ controller: UIViewController, success:(()->())?, defaulted:((String)->())?) {
        switch payResult.type {
            case .success:
                success?()
            case .beforePayError, .defeated, .otherError:
                defaulted?(payResult.desp)
            case .notInstalled:
                ZZPrint("未安装客户端")
            case .cancel:
                defaulted?(payResult.desp)
//                prompt(payResult.desp, controller)
                ZZPrint("  取消了支付  ")
            case .rePayRequest, .networkError:
                defaulted?(payResult.desp)
            case .inProgress, .unKnown:
                prompt("暂未获取到支付结果，请前往订单中查看订单", controller)
            case .beforeEvokePayApp:
                ZZPrint(payResult.desp)
        }
    }
    
    fileprivate class func prompt(_ message: String, _ controller: UIViewController) {
        let alertVC = UIAlertController(title: message, message: "", preferredStyle: .alert)
        let sureAction = UIAlertAction(title: "确定", style: .default, handler: nil)
        alertVC.addAction(sureAction)
        controller.present(alertVC, animated: true, completion: {
            
        })
    }
}
