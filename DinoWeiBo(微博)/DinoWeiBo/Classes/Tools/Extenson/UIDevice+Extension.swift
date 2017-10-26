//
//  UIDevice+Extension.swift
//  DinoWeiBo
//
//  Created by liu yao on 2017/3/28.
//  Copyright © 2017年 深圳多诺信息科技有限公司. All rights reserved.
//

import Foundation

import UIKit

extension UIDevice {
    /// 当前设备的系统版本
    class var currentSystemVersion : String {
        get {
            return UIDevice.current.systemVersion
        }
    }
    
    /// 当前系统的名称
    class var currentSystemName : String {
        get {
            return UIDevice.current.systemName
        }
    }
    
    func maxScreenLength() -> CGFloat {
        let bounds = UIScreen.main.bounds
        return max(bounds.width, bounds.height)
    }
    
    func iPhone4() -> Bool {
        return maxScreenLength() == 480
    }
    
    func iPhone5() -> Bool {
        return maxScreenLength() == 568
    }
    
    func iPhone6or7() -> Bool {
        return maxScreenLength() == 667
    }
    
    func iPhone6or7Plus() -> Bool {
        return maxScreenLength() == 736
    }
    
    
    /// 建议的根据设备获取字体
    ///
    /// - Parameters:
    ///   - size: 字体设计大小
    ///   - q6: 默认系数 0.94
    ///   - q5: 默认系数 0，86
    ///   - q4: 默认系数 0.80
    /// - Returns: 字体大小
    func fontSizeForDevice(_ size: CGFloat, q6: CGFloat = 0.94, q5: CGFloat = 0.86, q4: CGFloat = 0.80) -> CGFloat {
        if iPhone4() {
            return max(10, size * q4)
        } else if iPhone5() {
            return max(10, size * q5)
        } else if iPhone6or7() {
            return max(10, size * q6)
        }
        return size
    }
    
}

/// 建议根据设备获取垂直的间距大小
///
/// - Parameters:
///   - value: 设计大小
///   - q6: 0.9
///   - q5: 0.77
///   - q4: 0.65
/// - Returns: 间距大小
public func suggestedVerticalConstraint(_ value: CGFloat, q6: CGFloat = 0.9, q5: CGFloat = 0.77, q4: CGFloat = 0.65) -> CGFloat {
    if UIDevice.current.iPhone4() {
        return ceil(value * q4)
    } else if UIDevice.current.iPhone5() {
        return ceil(value * q5)
    } else if UIDevice.current.iPhone6or7() {
        return ceil(value * q6)
    } else {
        return value
    }
}

/// 建议根据设备获取平行的间距大小
///
/// - Parameters:
///   - value: 设计大小
///   - q6: 0.9
///   - q5: 0.77
///   - q4: 0.65
public func suggestedHorizontalConstraint(_ value: CGFloat, q6: CGFloat = 0.9, q5: CGFloat = 0.77, q4: CGFloat = 0.77) -> CGFloat {
    if UIDevice.current.iPhone4() {
        return ceil(value * q4)
    } else if UIDevice.current.iPhone5() {
        return ceil(value * q5)
    } else if UIDevice.current.iPhone6or7() {
        return ceil(value * q6)
    } else {
        return value
    }
}
