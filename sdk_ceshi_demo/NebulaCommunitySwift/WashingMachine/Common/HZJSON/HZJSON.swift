//
//  HZJSON.swift
//  HZJSON
//
//  Created by Harious on 2018/4/3.
//  Copyright © 2018年 zzh. All rights reserved.
//

import Foundation

protocol HZCodable: Codable {
    //MARK: --------------- 反序列化 ------------------
    static func create(withData data: Data?) -> Self?
    static func create(withDict any: [String: Any]) -> Self?
    
    //MARK: --------------- 序列化 ------------------
    func toDictionary() -> [String: Any]?
    func toString() -> String?
    func toData() -> Data?
}


extension HZCodable {
    
    static func create(withData data: Data?) -> Self? {
        guard let data = data else {return nil}
        return try? JSONDecoder().decode(self, from: data)
    }
    
    static func create(withDict any: [String: Any]) -> Self? {
        return create(withData: try? JSONSerialization.data(withJSONObject: any, options: .prettyPrinted))
    }
    
    func toDictionary() -> [String: Any]? {
        guard let data = toData() else {return nil}
        return (try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)) as? [String: Any]
    }
    
    func toString() -> String? {
        guard let data = toData() else {return nil}
        return String(data: data, encoding: .utf8)
    }
    
    func toData() -> Data? {
        return try? JSONEncoder().encode(self)
    }
    
    
}


extension Array where Element == HZCodable {
    func toString() {
        
    }
}
