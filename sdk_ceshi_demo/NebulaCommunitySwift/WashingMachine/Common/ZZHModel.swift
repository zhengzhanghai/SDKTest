//
//  ZZHModel.swift
//  Alaofire-Test
//
//  Created by zzh on 16/9/5.
//  Copyright © 2016年 zzh. All rights reserved.
//

import Foundation
import HandyJSON


class ZZHModel: NSObject {
    required override init() {}
    
    class func stringForClass() -> String {
        return NSStringFromClass(self.classForCoder())
    }
    
    func writeLocal() {
        ZZPrint("+++++++++++++++++++++++++++")
        UserDefaults.standard.set(self.toJSON(), forKey: NSStringFromClass(self.classForCoder))
        ZZPrint(UserDefaults.standard.synchronize())
        
    }

    class func deleteLocal() {
        ZZPrint("--------------------------")
        UserDefaults.standard.set([String: Any](), forKey: NSStringFromClass(self.classForCoder()))
        ZZPrint(UserDefaults.standard.synchronize())
    }
    
    class func printDictionaryProperty(_ dictionary: NSDictionary) {
        let keyArray = dictionary.allKeys
        for i in 0 ..< keyArray.count {
            let value = dictionary[(keyArray[i] as? String)!]
            if (value! as AnyObject).isKind(of: NSNumber.classForCoder()) {
                ZZPrint("var " + (keyArray[i] as! String) + ": NSNumber?")
            } else if (value! as AnyObject).isKind(of: NSArray.classForCoder()) {
                ZZPrint("var " + (keyArray[i] as! String) + ": NSArray?")
            } else{
                ZZPrint("var " + (keyArray[i] as! String) + ": String?")
            }
        }
    }
}

extension ZZHModel: HandyJSON {
    class func create(_ dictionary: [String : Any]?) -> Self {
        return self.deserialize(from: dictionary) ?? self.init()
    }
    
    class func readFromLocal() -> Self {
        let dict = UserDefaults.standard.value(forKey: NSStringFromClass(self.classForCoder()))
        if let json = dict as? [String: Any] {
            let model = self.create(json)
            return model
        }
        return self.init()
    }
}



