//
//  UIView+Frame.swift
//  DinoWeiBo
//
//  Created by liu yao on 2017/4/7.
//  Copyright © 2017年 深圳多诺信息科技有限公司. All rights reserved.
//

import UIKit

// MARK: - 学习 YYCategirues 的仿写 二位置
extension UIView {
    /// View的X坐标
    var x: CGFloat {
        set(newValue) {
            var tempRect = self.frame
            tempRect.origin.x = newValue
            self.frame = tempRect
        }
        
        get {
            return self.frame.origin.x
        }
    }
    /// View的Y坐标
    var y: CGFloat {
        set(newValue) {
            var tempRect = self.frame
            tempRect.origin.y = newValue
            self.frame = tempRect
        }
        
        get {
            return self.frame.origin.y
        }
    }
    /// View的宽
    var width: CGFloat {
        set(newValue) {
            var tempRect = self.frame
            tempRect.size.width = newValue
            self.frame = tempRect
        }
        
        get {
            return self.frame.size.width
        }
    }
    /// View的高
    var height: CGFloat {
        set(newValue) {
            var tempRect = self.frame
            tempRect.size.height = newValue
            self.frame = tempRect
        }
        
        get {
            return self.frame.size.height
        }
    }
    /// 左
    var left : CGFloat {
        get {
            return x
        }
    }
    
    /// 右
    var right : CGFloat {
        get {
            guard self.superview != nil else {
                return x + width
            }
            return (superview?.width)! - (x + width)
        }
    }
    
    /// 上
    var top : CGFloat {
        get {
            return y
        }
    }
    
    /// 下
    var bottom : CGFloat {
        get {
            guard self.superview != nil else {
                return y + height
            }
            return (superview?.height)! - (y + height)
        }
    }
    /// 中心X
    var centerX: CGFloat {
        set(value) {
            center = CGPoint(x: value, y: center.y)
        }
        get {
            return self.center.x
        }
    }
    
    /// 中心Y
    var centerY: CGFloat {
        set(value) {
            center = CGPoint(x: center.x, y: value)
        }
        
        get {
            return self.center.y
        }
    }
    
    var maxX: CGFloat {
        get {
            return self.frame.maxX
        }
    }
    
    var maxY: CGFloat {
        get {
            return self.frame.maxY
        }
    }
    
    var midX: CGFloat {
        get {
            return self.frame.midX
        }
    }
    
    var midY: CGFloat {
        get {
            return self.frame.midY
        }
    }
    /// 宽的一半
    var middleWidth : CGFloat {
        get {
            return width / 2
        }
    }
    
    /// 高的一半
    var middleHeight : CGFloat {
        get {
            return height / 2
        }
    }
    
    /// View的尺寸
    var size : CGSize {
        get {
            return frame.size
        }
        
        set(value) {
            var tmpFrame = frame
            tmpFrame.size = value
            frame = tmpFrame
        }
    }
    
    /// View的坐标点
    var origin : CGPoint {
        get {
            return frame.origin
        }
        
        set(value) {
            var tmpFrame = frame
            tmpFrame.origin = value
            frame = tmpFrame
        }
    }
}
