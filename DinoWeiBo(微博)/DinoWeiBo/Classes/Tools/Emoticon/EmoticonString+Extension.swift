//
//  String+Extension.swift
//  表情键盘
//
//  Created by liu yao on 2017/3/3.
//  Copyright © 2017年 深圳多诺信息科技有限公司. All rights reserved.
//

import Foundation

extension String {
    
    /// 返回单纯字符串 中的 16 进制对应的 emoji字符串
    var emoji: String {
        // 文本扫描器 - 扫描指定格式的字符串  16
        let scanner = Scanner(string: self)
        // unicode 的值
        var value: UInt32 = 0
        scanner.scanHexInt32(&value)
        let chr = Character(UnicodeScalar(value)!)
        return "\(chr)"
    }
}
