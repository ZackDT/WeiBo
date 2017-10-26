//
//  UILabel+ContentSize.swift
//  DinoWeiBo
//
//  Created by liu yao on 2017/4/7.
//  Copyright © 2017年 深圳多诺信息科技有限公司. All rights reserved.
//

import UIKit

extension UILabel {
    
    
    /// 计算尺寸
    ///
    /// - Parameter width: 宽度
    /// - Returns: 尺寸
    func contentSize(width: CGFloat) -> CGSize {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = self.lineBreakMode
        paragraphStyle.alignment = self.textAlignment
        
        let contentFrame = (self.text! as NSString).boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: [.usesLineFragmentOrigin,.usesFontLeading], attributes: [NSFontAttributeName: self.font], context: nil)
        return contentFrame.size
    }
    
    
    /// UIlabel尺寸
    ///
    /// - Returns: 尺寸
    func contentSize() -> CGSize {
        return contentSize(width: self.width)
    }
    
}
