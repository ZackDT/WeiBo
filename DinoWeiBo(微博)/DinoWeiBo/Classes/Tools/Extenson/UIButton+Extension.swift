//
//  UIButton+Extension.swift
//  DinoWeiBo
//
//  Created by liu yao on 2017/2/5.
//  Copyright © 2017年 深圳多诺信息科技有限公司. All rights reserved.
//

import UIKit

extension UIButton {
    
    ///返回按钮(大小和图片有关)
    ///
    /// - Parameters:
    ///   - imageName: 图片 有高亮状态
    ///   - backImageName: 背景图片 有高亮状态
    convenience init(imageName: String, backImageName: String?) {
        self.init()
        setImage(UIImage(named:imageName), for: .normal)
        setImage(UIImage(named:imageName + "_highlighted"), for: .highlighted)
        if let backImageName = backImageName {
            setBackgroundImage(UIImage(named:backImageName), for: .normal)
            setBackgroundImage(UIImage(named:backImageName + "_highlighted"), for: .highlighted)
        }
        sizeToFit()
    }
    
    /// 返回按钮
    ///
    /// - Parameters:
    ///   - title:          标题
    ///   - color:          颜色
    ///   - backimageName:  背景图片名词
    convenience init(title: String, color: UIColor, backimageName: String) {
        self.init()
        setTitle(title, for: .normal)
        setTitleColor(color, for: .normal)
        setBackgroundImage(UIImage(named:backimageName), for: .normal)
        sizeToFit()
    }
    
    
    /// 返回按钮
    ///
    /// - Parameters:
    ///   - title: 标题
    ///   - fontSize: 字体大小
    ///   - color: 颜色
    ///   - imageName: 图像名称
    convenience init(title: String, fontSize: CGFloat, color: UIColor, imageName: String?, backColor: UIColor? = nil) {
        self.init()
        setTitle(title, for: .normal)
        setTitleColor(color, for: .normal)
        if let imageName = imageName {
            setImage(UIImage(named:imageName), for: .normal)
        }
        backgroundColor = backColor
        titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        sizeToFit()
    }
    
    convenience init(title : String , bgColor : UIColor , font : CGFloat) {
        self.init()
        setTitle(title, for: .normal)
        backgroundColor = bgColor
        titleLabel?.font = UIFont.systemFont(ofSize: font)
        sizeToFit()
    }
    
    
    /// 初始化btn
    ///
    /// - Parameters:
    ///   - imgNamed: normol状态图片名称
    ///   - clickImgNamed: 高亮图片名称
    ///   - size: 尺寸，默认是sizeToFit
    convenience init(imgNamed: String,clickImgNamed: String? = nil, size: CGSize? = nil) {
        self.init()
        self.setImage(UIImage(named: imgNamed), for: .normal)
        if let size = size {
            self.size = size
        }else {
            self.sizeToFit()
        }
        if let clickImgNamed = clickImgNamed {
            setImage(UIImage(named:clickImgNamed), for: .highlighted)
        }
        
    }
    
}

