//
//  Emoticon.swift
//  表情键盘
//
//  Created by liu yao on 2017/3/3.
//  Copyright © 2017年 深圳多诺信息科技有限公司. All rights reserved.
//

import UIKit


///表情模型
class Emoticon: NSObject {
    
    /// 发送给服务器的表情字符串
    var chs: String?
    
    /// 在本地显示的图片名称 + 表情路径
    var png: String?
    
    /// 图片完成路径
    var imagePath: String? {
        if png == nil {
            return ""
        }
        return Bundle.main.bundlePath + "/Emoticons.bundle/" + png!
    }
    
    /// emoji 的字符串编码
    var code: String? {
        didSet {
            emoji = code?.emoji
        }
    }
    
    /// emoji的字符串
    var emoji: String?
    
    /// 是否删除按钮标标记
    var isRemoved = false
    
    /// 是否空白按钮标记 
    var isEmpty = false
    
    /// 表情使用次数
    var times = 0
    
    init(isRemoved: Bool) {
        self.isRemoved = isRemoved
        super.init()
    }
    
    init(isEmpty: Bool) {
        self.isEmpty = isEmpty
        super.init()
    }
    
    init(dict: [String: Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) { }
    
    override var description: String {
        let keys = ["chs","png","code","isRemoved","times"]
        return dictionaryWithValues(forKeys: keys).description
    }
}
