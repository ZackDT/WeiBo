//
//  Bundle+Extension.swift
//  DinoWeiBo
//
//  Created by liu yao on 2017/3/28.
//  Copyright © 2017年 深圳多诺信息科技有限公司. All rights reserved.
//

import Foundation
import UIKit

extension Bundle {
    
    /// 获取App版本号
    class var appVersion : String {
        get {
            return String(describing: Bundle.main.infoDictionary!["CFBundleShortVersionString"]!)
        }
    }
    
    /// 获取Bundle名字
    class var name : String {
        get {
            var bundlePath = Bundle.main.bundlePath
            bundlePath = bundlePath.components(separatedBy: "/").last!
            bundlePath = bundlePath.components(separatedBy: ".").first!
            return bundlePath
        }
    }
    
    class var appName : String {
        get {
            return String(describing: Bundle.main.infoDictionary!["CFBundleDisplayName"]!)
        }
    }
    
}
