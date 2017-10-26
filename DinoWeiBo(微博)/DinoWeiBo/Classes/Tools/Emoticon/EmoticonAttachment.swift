//
//  EmoticonAttachment.swift
//  表情键盘
//
//  Created by liu yao on 2017/3/5.
//  Copyright © 2017年 深圳多诺信息科技有限公司. All rights reserved.
//

import UIKit


/// 表情附件
class EmoticonAttachment: NSTextAttachment {
    
    var emoticon: Emoticon
    
    init(emoticon: Emoticon) {
        self.emoticon = emoticon
        super.init(data: nil, ofType: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /// 将当前附件中的 emoticon 转换成属性文本
    ///
    /// - Returns: 属性文本
    func imageText(font: UIFont) -> NSAttributedString {
        image = UIImage(contentsOfFile: emoticon.imagePath!)
        // 线高 - 表示字体高度
        let lineHeight = font.lineHeight
        
        bounds = CGRect(x: 0, y: -4, width: lineHeight, height: lineHeight)
        
        // 获得图片文本
        let imageText = NSMutableAttributedString(attributedString: NSAttributedString(attachment: self))
        // 需要添加字体，不然点击的第二个图片会变小
        imageText.addAttribute(NSFontAttributeName, value: font, range: NSRange(location: 0, length: 1))
        return imageText
    }
    
    
}
