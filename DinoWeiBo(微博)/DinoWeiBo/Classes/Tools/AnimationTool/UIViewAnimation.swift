//
//  UIViewAnimation.swift
//  DinoWeiBo
//
//  Created by 刘耀 on 2017/4/8.
//  Copyright © 2017年 深圳多诺信息科技有限公司. All rights reserved.
//

import Foundation


/// 动画协议
public protocol CustomViewAnimations {
    
    func shake(_ duration: CFTimeInterval)
    func spin(_ duration: CFTimeInterval, rotations: CGFloat, repeatCount: Float)
    
}


// MARK: - 让UIView遵守协议。这样子也不好，每个UIView都可以调
extension UIView: CustomViewAnimations {
    
    public func shake(_ duration: CFTimeInterval = 0.3) {
        let animation = CAKeyframeAnimation()
        animation.keyPath = "position.x"
        animation.values =  [0, 20, -20, 10, 0]
        animation.keyTimes = [0, NSNumber(value: 1 / 6.0), NSNumber(value: 3 / 6.0), NSNumber(value: 5 / 6.0), 1]
        animation.duration = duration
        animation.isAdditive = true
        
        layer.add(animation, forKey:"shake")
    }
    
    public func spin(_ duration: CFTimeInterval, rotations: CGFloat, repeatCount: Float) {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.toValue = M_PI * 2.0 * Double(rotations)
        animation.duration = duration
        animation.isCumulative = true
        animation.repeatCount = repeatCount
        
        layer.add(animation, forKey:"rotationAnimation")
    }
    
}
