//
//  UILabel+Extension.swift
//  DinoWeiBo
//
//  Created by liu yao on 2017/2/7.
//  Copyright © 2017年 深圳多诺信息科技有限公司. All rights reserved.
//

import UIKit

extension UILabel {
    
    
    /// label多行居中
    ///
    /// - Parameters:
    ///   - title: title
    ///   - fontSize: fontSize , 默认是14号子
    ///   - color: color，默认是深灰色
    ///   - screenInset: 先对与屏幕左右的缩进，默认是0，居中显示，如果设置，则左对齐
    convenience init(title: String,
                     fontSize: CGFloat? = 14,
                     color: UIColor? = UIColor.darkGray,
                     screenInset: CGFloat? = 0
        ) {
        self.init()
        text = title
        //界面设计上，避免使用纯黑色.默认值
        textColor = color
        font = UIFont.systemFont(ofSize: fontSize!)
        numberOfLines = 0
        if screenInset == 0 {
            textAlignment = .center
        } else {
            preferredMaxLayoutWidth = UIScreen.main.bounds.width - 2 * screenInset!
            textAlignment = .left
        }
        sizeToFit()

    }
    
    
    /// label初始化
    ///
    /// - Parameters:
    ///   - title: 标题
    ///   - size: 尺寸，默认为nil的时候sizeToFite
    ///   - fontSize: 字体尺寸，默认是14
    ///   - color: 颜色，默认是黑色
    ///   - alignment: 默认left
    convenience init(sizetitle: String,
                     size: CGRect? = nil,
                     fontSize: CGFloat? = 14,
                     color: UIColor? = myBlackColr,
                     alignment:NSTextAlignment? = .left) {
        self.init()
        self.text = sizetitle
        font = UIFont.systemFont(ofSize: 17)
        textColor = color
        textAlignment = alignment!
        if size != nil {
            frame = size!
        }else {
            sizeToFit()
        }
    }
    
    convenience init(lableText:String) {
        self.init()
        self.text = lableText
    }
    
}
