//
//  UIBarButtonItem+Extension.swift
//  DinoWeiBo
//
//  Created by liu yao on 2017/2/18.
//  Copyright © 2017年 深圳多诺信息科技有限公司. All rights reserved.
//

import UIKit

extension UIBarButtonItem{
    
    /// 便利构造函数
    ///
    /// - Parameters:
    ///   - imageName: 图片名称
    ///   - highlightedImage: 高亮图片名称
    ///   - size: 尺寸
    convenience init(imageName : String, highlightedImage : String? = nil , size : CGSize? = CGSize.zero){
        let btn = UIButton()
        btn.setImage(UIImage(named : imageName), for: .normal)
        if let highlightedImage = highlightedImage {
            btn.setImage(UIImage(named : highlightedImage), for: .highlighted)
        }
        if size == CGSize.zero{
            btn.sizeToFit()
            
        }else
        {
            btn.frame = CGRect (origin: CGPoint.zero, size: size!)
        }
        self.init(customView: btn)
    }
    
    /// 便利构造函数
    ///
    /// - Parameters:
    ///   - imageName: 图片名称
    ///   - target: 点击对象
    ///   - action: 点击事件
    convenience init(imageName: String,target: Any?, action: Selector?) {
        let btn = UIButton(imageName: imageName, backImageName: nil)
        if let action = action {
            btn.addTarget(target, action: action, for: .touchUpInside)
        }
        self.init(customView: btn)
    }
}
