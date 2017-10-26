//
//  UITextView+Emoticon.swift
//  表情键盘
//
//  Created by liu yao on 2017/3/5.
//  Copyright © 2017年 深圳多诺信息科技有限公司. All rights reserved.
//

/**
 代码复合   -   对重构完成的代码进行检查
 1、修改注释
 2、确认是否需要进一步重构
 3、在一次检查返回值和参数
 */


import UIKit


// MARK: - 扩展的表情-UITextView
extension UITextView {
    
    /// 插入表情符号
    ///
    /// - Parameter em: 表情模型
    func inesetEmoticon(em: Emoticon) {
        // 1、空白表情
        if em.isEmpty { return }
        // 2、删除按钮
        if em.isRemoved {
            deleteBackward()
            return
        }
        // 3、 emoji
        if let emoji = em.emoji {
            replace(selectedTextRange!, withText: emoji)
            return
        }
        // 4、图片表情
        insertImageEmoticon(em: em)
        delegate?.textViewDidChange?(self)
        
    }
    // 计算型属性
    var emoticonText: String {
        let attrText = attributedText
        
        var StrM = String()
        attrText?.enumerateAttributes(in: NSRange(location: 0, length: (attrText?.length)!), options: [], using: { (dict, range, _) in
            // 如果字典中包含 NSAttachment 说明是图片
            // 否者是字符串，可以通过range 过的
            if let attachment = dict["NSAttachment"] as? EmoticonAttachment {
                let em = attachment.emoticon
                // 怎么找到图片代表的字符串 继承 添加属性
                StrM += em.chs!
                
            }else {
                let str = attrText?.attributedSubstring(from: range).string
                // (attrText?.string as! NSString).substring(with: range)
                StrM += str!
            }
        })
        return StrM
    }
    
    /// 插入表情符号
    ///
    /// - Parameter em: 表情模型
    private func insertImageEmoticon(em: Emoticon) {
        // 1、记录 textView attributedString -> 转换成可变文本
        let strM = NSMutableAttributedString(attributedString: attributedText)
        // 2、图片的属性文本
        let imageText = EmoticonAttachment(emoticon: em).imageText(font: font!)
        // 3、插入图片文本
        strM.replaceCharacters(in: selectedRange, with: imageText)
        
        // 4、需要进行处理，不然光标输入后就在末尾
        let range = selectedRange
        attributedText = strM
        selectedRange = NSRange(location: range.location + 1, length: 0)
    }
}
