//
//  Dictionary+Extension.swift
//  DinoWeiBo
//
//  Created by liu yao on 2017/3/27.
//  Copyright © 2017年 深圳多诺信息科技有限公司. All rights reserved.
//

import Foundation
import UIKit

extension Dictionary {
    
    
    /// 合并 Dictionary
    ///
    /// - Parameter dict: 合并后的 Dictionary
    mutating func merge(_ dict: [Key: Value]) {
        for (k, v) in dict {
            self.updateValue(v, forKey: k)
        }
    }
    
}
