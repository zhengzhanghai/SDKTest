//
//  NetworkEngine.swift
//  WashingMachine
//
//  Created by zzh on 16/11/1.
//  Copyright © 2016年 Eteclabeteclab. All rights reserved.
//

import UIKit
import Alamofire


/// 当请求成功，服务器无任何返回，以此作为服务器返回数据
fileprivate let abnormalDict: [String : Any] = ["message": "请稍后再试~",
                                                "code": -9999,
                                                "data": []]

typealias CompletionClourse = ((NetworkResult)->())
typealias VMJudgeClourse = ((Bool, String, Error?)->())

class NetworkEngine {
    /// 通用的请求头数据
    class fileprivate func requestHeaderDict(_ headers: [String: String]? = nil) -> [String: String] {
        var headerDict: [String: String] = [String: String]()
        // 前面四个是所有接口都需要的header
        headerDict["token"] = UserInfoModel.newToken()
        headerDict["userId"] = UserInfoModel.newUserId()
        headerDict["uuid"] = HZMobilePhone.UUIDStr
        headerDict["udid"] = HZMobilePhone.UUIDStr
        // 某些接口特定的header
        if let dict = headers {
            for (key, value) in dict {
                headerDict[key] = value
            }
        }
        return headerDict;
    }
    
    /// 主要是为了适应开始没有在使用时没有写URL前部分,并进行转码
    class func dealUlr(_ url: String) -> String {
        var api = url
        if !(api.contains("http://") || api.contains("https://")) {
            api = SERVICE_BASE_ADDRESS + api
        }
        return api.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? api
    }
    
    /// 处理请求后的数据并回调
    class func dealRequestResult(_ response: DefaultDataResponse, _ completionClourse: CompletionClourse?) {
        ZZPrint("✅✅✅✅✅  网络请求结束")
        ZZPrint(response.response?.url)
        let result = NetworkResult()
        if let error = response.error {
            ZZPrint("❌❌❌❌❌  网络请求报错")
            ZZPrint(error)
            result.error = error
        } else {
            if let data = response.data {
                do {
                    let dict = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                    result.sourceDict = ((dict as? [String : AnyObject]) ?? abnormalDict) as [String : AnyObject]
                    ZZPrint(dict)
                } catch {
                    result.sourceDict = abnormalDict as [String : AnyObject]
                }
            } else {
                result.sourceDict = abnormalDict as [String : AnyObject]
            }
        }
        completionClourse?(result)
    }
    
    /// get请求
    class func get(_ url: String,
                   parameters: [String: Any]?,
                   headers: [String: String]? = nil,
                   completionClourse: CompletionClourse?)
    {
        var allHeader = requestHeaderDict()
        if let headers = headers {
            for (key, val) in headers {
                allHeader[key] = val
            }
        }
        Alamofire.SessionManager.default.session.configuration.timeoutIntervalForRequest = 10
        Alamofire.request(dealUlr(url), parameters: parameters, headers: allHeader).response(completionHandler: { (response) in
            self.dealRequestResult(response, completionClourse)
        })
    }
    
    /// post 常规请求
    class func post(_ url: String,
                    parameters: [String: Any]?,
                    completionClourse: CompletionClourse?)
    {
        Alamofire.SessionManager.default.session.configuration.timeoutIntervalForRequest = 10
        Alamofire.request(dealUlr(url), method: .post, parameters: parameters, headers: requestHeaderDict()).response { (response) in
            self.dealRequestResult(response, completionClourse)
        }
    }
    
    /// post JSON 请求
    class func postJSON(_ url: String,
                        parameters: [String: Any]?,
                        headers: [String: String]? = nil,
                        completionClourse: CompletionClourse?)
    {
        Alamofire.SessionManager.default.session.configuration.timeoutIntervalForRequest = 10
        Alamofire.request(dealUlr(url), method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: requestHeaderDict(headers)).response { (response) in
            self.dealRequestResult(response, completionClourse)
        }
    }
    
    /// delete 请求
    class func delete(_ url: String,
                      parameters: [String: Any]?,
                      headers: [String: String]? = nil,
                      completionClourse: CompletionClourse?)
    {
        Alamofire.SessionManager.default.session.configuration.timeoutIntervalForRequest = 10
        Alamofire.request(dealUlr(url), method: .delete, parameters: parameters, headers: requestHeaderDict()).response { (response) in
            self.dealRequestResult(response, completionClourse)
        }
    }
    
    /// post 上传文件
    class func upload(_ url: String,
                      _ parameters: [String: Any]?,
                      _ datas:[UploadFileModel],
                      _ time: TimeInterval,
                      _ completionClourse: CompletionClourse?)
    {
        Alamofire.SessionManager.default.session.configuration.timeoutIntervalForRequest = time
        Alamofire.upload(multipartFormData: { (formData) in
            for fileModel in datas {
                formData.append(fileModel.fileData ?? Data(),
                                withName: "file",
                                fileName: fileModel.fileName ?? "file",
                                mimeType: "application/octet-stream")
            }
            if let dict = parameters {
                for (key, value) in dict {
                    var valueStr = ""
                    if let valueString = value as? String {
                        valueStr = valueString
                    } else if let valueNum = value as? NSNumber {
                        valueStr = "\(valueNum)"
                    }
                    formData.append(valueStr.data(using: String.Encoding.utf8) ?? Data(), withName: key)
                }
            }
        }, to: dealUlr(url), headers: requestHeaderDict()) { (result) in
            switch result {
            case .success(request: let uploadRequest, streamingFromDisk: _, streamFileURL: _):
                uploadRequest.response(completionHandler: { (response) in
                    self.dealRequestResult(response, completionClourse)
                })
            case .failure(let error):
                let response = DefaultDataResponse(request: nil, response: nil, data: nil, error: error)
                self.dealRequestResult(response, completionClourse)
            }
        }
    }
}
