//
//  StringExtension.swift
//  WashingMachine
//
//  Created by zzh on 2017/9/6.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

import Foundation

extension String {
    /// 转换成Int，如果不满足Int数字格式，返回0
    var IntValue: Int {return (Int(self) ?? 0)}
    /// 转换成Float，如果不满足常规数字格式，返回0
    var FloatValue: Float {return (Float(self) ?? Float(0))}
    /// 转换成Double，如果不满足常规数字格式，返回0
    var DoubleValue: Double {return (Double(self) ?? Double(0))}
    
    /// MD5加密
    /// - Returns: 返回加密后的字符串
    //    func md5() -> String {
    //        let str = self.cString(using: String.Encoding.utf8)
    //        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
    //        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
    //        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
    //        CC_MD5(str!, strLen, result)
    //        let hash = NSMutableString()
    //        for i in 0 ..< digestLen {
    //            hash.appendFormat("%02x", result[i])
    //        }
    //        result.deallocate(capacity: digestLen)
    //        return String(format: hash as String)
    //    }
    
    /// MD5加密
    /// - Returns: 返回加密后的字符串
    func md5() -> String {
        let utf8 = cString(using: .utf8)
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        CC_MD5(utf8, CC_LONG(utf8!.count - 1), &digest)
        return digest.reduce("") { $0 + String(format:"%02X", $1) }
    }
    
    
    
    // MARK: - 字符串拓展，获取字符串宽高
    func sizeWithFont(_ font: UIFont, _ maxSize: CGSize) -> CGSize {
        let attrs = [NSAttributedString.Key.font : font];
        return (self as NSString).boundingRect(with: maxSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attrs, context: nil).size
    }
    
    /// 获取文本的宽度
    ///
    /// - Parameters:
    ///   - font: 字体
    ///   - maxWidth: 允许的最大宽度
    /// - Returns: 返回文本的宽度
    func textWidth(_ font: UIFont, maxWidth: CGFloat) -> CGFloat {
        let textMaxSize = CGSize(width: BOUNDS_WIDTH, height: CGFloat(UInt.max))
        var textRealWidth = self.sizeWithFont(font, textMaxSize).width
        if textRealWidth > maxWidth {
            textRealWidth = maxWidth
        }
        return textRealWidth
    }
    
    /// 是否只含有数字和字母(空串""返回false)
    ///
    /// - Returns: --
    func isNumberOrAlphabet() -> Bool {
        let regex = "^[A-Za-z0-9]+$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }
    
    /// 判断是否是网址(空串""返回false)
    ///
    /// - Returns: --
    func isWebUrl() -> Bool {
        let regex = "[a-zA-z]+://[^\\s]*"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }
    
    /// 获取含有几个字符（一个汉字占两个字符）(此方法不太成熟)
    ///
    /// - Returns: 返回长度
    func charactersLength() -> Int {
//        var length = 0
//        for char in self.characters {
//            // 判断是否中文，是中文+2 ，不是+1
//            var charLength = "\(char)".lengthOfBytes(using: String.Encoding.utf8)
//            if charLength == 3 {
//                charLength = 2
//            }
//            length += charLength
//        }
//        return length
        
        return self.count
    }
    
    /// 是否包含emoji表情
    var isContainsEmoji: Bool {
        for scalar in self.unicodeScalars {
            switch scalar.value {
            case
            0x00A0...0x00AF,
            0x2030...0x204F,
            0x2120...0x213F,
            0x2190...0x21AF,
            0x2310...0x3001,
            0x3003...0x329F,
            0x1F000...0x1F9CF:
                return true
            default:
                continue
            }
        }
        return false
    }
    
    /// 获取第几个字符，以字符串形式返回(如果越界返回"")
    func subStr(index: Int) -> String {
        if index >= self.count {
            return ""
        }
        return String(self[self.index(self.startIndex, offsetBy: index)])
    }
    
    
}
