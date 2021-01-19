//
//  AuthSchool.swift
//  WashingMachine
//
//  Created by Harious on 2018/1/24.
//  Copyright © 2018年 Eteclabeteclab. All rights reserved.
//

import Foundation


class AuthSchool {
    /// 保存到沙河的key
    private static let userDefaultsKey = "AuthSchool.userDefaultsKey"
    /// 已经认证的学校id
    
    private static var tmpId: String = ""
    private static var tmpName: String = ""
    
    static var id: String {
        if tmpId == "" {
            let school = readFromHomeDirectory()
            self.tmpId = school.id
            self.tmpName = school.name
        }
        return tmpId
    }
    static var name: String {
        if tmpId == "" {
            let school = readFromHomeDirectory()
            self.tmpId = school.id
            self.tmpName = school.name
        }
        return tmpName
    }
    
    /// 是否已经获取
    static var isExist: Bool {
        return !id.isEmpty
    }
    
    /// 修改并保存到沙河
    static func modifyAndSave(_ id: String, _ name: String) {
        self.tmpId = id
        self.tmpName = name
        
        saveToFromHomeDirectory(id, name)
    }
    
    /// 清空保存到类属性及沙河的信息
    static func clear() {
        self.tmpId = ""
        self.tmpName = ""
        
        saveToFromHomeDirectory("", "")
    }
    
    /// 从沙河中读取
    private static func readFromHomeDirectory() -> (id: String, name: String) {
        var schoolId = ""
        var schoolName = ""
        guard let dict = UserDefaults.standard.value(forKey: userDefaultsKey) as? [String: String] else {
            return (schoolId, schoolName)
        }
        if let dictId = dict["id"] {
            schoolId = dictId
        }
        if let dictName = dict["name"]  {
            schoolName = dictName
        }
        return (schoolId, schoolName)
        
    }
    
    /// 保存到沙河
    private static func saveToFromHomeDirectory(_ id: String, _ name: String) {
        UserDefaults.standard.set(["id": id, "name": name], forKey: userDefaultsKey)
        UserDefaults.standard.synchronize()
    }
}
