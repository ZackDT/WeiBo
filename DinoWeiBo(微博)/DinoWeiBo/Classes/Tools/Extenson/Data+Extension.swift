//
//  Data+Extension.swift
//  DinoWeiBo
//
//  Created by 刘耀 on 2017/4/8.
//  Copyright © 2017年 深圳多诺信息科技有限公司. All rights reserved.
//

import Foundation

extension Data {
    
    
    /// json字符串转换
    ///
    /// - Returns: json字符串
    public func toJSON() -> AnyObject? {
        return ((try? JSONSerialization.jsonObject(with: self, options: .allowFragments)) ?? nil) as AnyObject?
    }
    
}
