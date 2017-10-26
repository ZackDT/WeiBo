//
//  String+Regex.swift
//  DinoWeiBo
//
//  Created by liu yao on 2017/4/5.
//  Copyright © 2017年 深圳多诺信息科技有限公司. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    /// 从当前字符串中，过滤链接和文字 
    //  元组：允许一个函数返回多个数值
    func href() -> (link: String, text: String)? {
        // 1. 创建正则表达式
        let pattern = "<a href=\"(.*?)\".*?>(.*?)</a>"
        // throws 针对 pattern是否正确的异常处理
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        
        // firstMatchInString 在指定的字符串中，查找第一个和 pattern 符合字符串
        
        guard let result = regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.characters.count)) else {
            
            QL4("没有匹配项目")
            return nil
        }
        // 获取第0个范围
        _ = result.rangeAt(0)// 所有字符串
        // 根据返回获取字符串
        let str = self as NSString
        
        let r1 = result.rangeAt(1)
        let link = str.substring(with: r1)
        
        let r2 = result.rangeAt(2)
        let text = str.substring(with: r2)
        return (link,text)
    }
    
    /// 验证是否是Email
    func isValidAsEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    /// 验证是否是电话号码
    func isValidAsPhone() -> Bool {
        let phoneRegEx = "^[0-9-+]{9,15}$"
        let phoneTest = NSPredicate(format:"SELF MATCHES %@", phoneRegEx)
        return phoneTest.evaluate(with: self)
    }
    
    /// 验证是否是Number字符串
    func isNumberString() -> Bool {
        let charSet = NSMutableCharacterSet(charactersIn: "-")
        charSet.formUnion(with: CharacterSet.decimalDigits)
        return  rangeOfCharacter(from: charSet.inverted) == nil
    }
    
    /// 找number字符串
    ///
    /// - Returns: <#return value description#>
    func findFirstNumberInString() -> String? {
        if let range = rangeOfCharacter(from: CharacterSet.decimalDigits), let numRange = rangeOfCharacter(from: CharacterSet.decimalDigits.inverted, options: .literal,
                                                                                                           range: range.lowerBound..<self.endIndex) {
            return substring(with: range.lowerBound..<numRange.lowerBound)
        }
        return nil
    }
}
