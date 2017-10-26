//
//  UIView+Extension.swift
//  DinoWeiBo
//
//  Created by liu yao on 2017/3/26.
//  Copyright © 2017年 深圳多诺信息科技有限公司. All rights reserved.
//

import UIKit


// MARK: - 学习 YYCategirues 的仿写 一
extension UIView {
    
    /// 创建一个快照图像的完整视图层次结构
    ///
    /// - Returns: 图片
    func snapshot() -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let snap = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return snap!
    }

    /// 移除所有视图
    func removeAllSubviews() {
//        while self.subviews.count > 0 {
//            subviews.last?.removeFromSuperview()
//        }
        for subView in self.subviews {
            subView.removeFromSuperview()
        }
    }
    
    /// 当前View所在的VC
    var currentViewController: UIViewController? {
        get {
            var superView: UIView? = self
            while superView != nil {
                let nextResponder = superView?.next
                if let vc = nextResponder as? UIViewController {
                    return vc
                }
                superView = superView?.superview
            }
            return nil
        }
    }
    
    func corner(radius: CGFloat) {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = radius
    }
    
    /// 设置阴影
    ///
    /// - Parameters:
    ///   - shadowColor: 阴影颜色
    ///   - offset: 偏移距离
    ///   - radius: 圆角角度
    func layerShadow(color: UIColor, offset: CGSize, radius: CGFloat) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        self.layer.opacity = 1
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
    
   
    
}




