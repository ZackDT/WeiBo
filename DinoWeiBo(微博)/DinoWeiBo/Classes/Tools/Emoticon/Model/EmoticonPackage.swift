//
//  EmoticonPackage.swift
//  表情键盘
//
//  Created by liu yao on 2017/3/3.
//  Copyright © 2017年 深圳多诺信息科技有限公司. All rights reserved.
//

import UIKit


/// 表情包模型
class EmoticonPackage: NSObject {
    
    /// 表情包所在路径
    var id: String?
    
    /// 表情包的名称，显示在tabBar中
    var group_name_cn: String?
    
    /// 表情数组 - 能够保证，在使用的时候，数组以及存在，可以直接追加数据
    lazy var emoticons = [Emoticon]()
    
    init(dict: [String: Any]) {
        super.init()
        id = dict["id"] as! String?
        group_name_cn = dict["group_name_cn"] as! String?
        
        // 获得字典的数组
        if let array = dict["emoticons"] as? [[String: Any]] {
            var index = 0
            for var d in array {
                
                // 1 > 判断是否有 png
                if let png = d["png"] as? String,let dir = id {
                    d["png"] = dir + "/" + png
                }
                
                emoticons.append(Emoticon(dict: d))
                index += 1
                
                //每个20个添加一个删除按钮
                if index == 20 {
                    emoticons.append(Emoticon(isRemoved: true))
                    index = 0
                }
            }
        }
        
        // 添加空白按钮
        appendEmptyEmoticon()
    }
    
    /// 在表情数组末尾，添加空白表情
    private func appendEmptyEmoticon() {
        
        let count = emoticons.count % 21
        //判断是否需要添加空白表情   取模为0 而且 表情数量不为0
        if emoticons.count > 0 && count == 0{
            return
        }
        for _ in count..<20 {
            emoticons.append(Emoticon(isEmpty: true))
        }
        emoticons.append(Emoticon(isRemoved: true))
    }
    
    override var description: String {
        let keys = ["id","group_name_cn","emoticons"]
        return dictionaryWithValues(forKeys: keys).description
    }
    
}
