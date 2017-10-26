//
//  EmoticonViewModel.swift
//  表情键盘
//
//  Created by liu yao on 2017/3/3.
//  Copyright © 2017年 深圳多诺信息科技有限公司. All rights reserved.
//

import UIKit


/// 表情包视图模型 - emoticon.plist
class EmoticonManager {
    
    
    /// 单例
    static let sharedManager = EmoticonManager()
    
    /// 表情模型数组
    lazy var packages = [EmoticonPackage]()
    
    /// 添加最近表情
    func addFavorite(em: Emoticon) {
        // 0. 表情次数
        em.times = em.times + 1
        // 1、把表情模型添加到 packages[0] 数组中
        if !packages[0].emoticons.contains(em) {
            packages[0].emoticons.append(em)
            
            //删除倒数第二个按钮
            packages[0].emoticons.remove(at: packages[0].emoticons.count - 2)
        }
        // 2.排序数组
//        packages[0].emoticons.sort { (em1, em2) -> Bool in
//            em1.times > em2.times
//        }
        // 缩写
        packages[0].emoticons.sort { $0.times > $1.times }
    }
    
    // MARK: - 生成属性字符串
    func emoticonText(string: String, font: UIFont) -> NSAttributedString {
        let strM = NSMutableAttributedString(string: string)
        
        // 1.正则表达式 [] 是正则表达式的关键字，需要转义
        let pattern = "\\[.*?\\]"
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        // 2. 匹配多选内容
        let results = regex.matches(in: string, options: [], range: NSRange(location: 0, length: string.characters.count))
        // 3.得到匹配的数量
        var count = results.count
        // 4.到这遍历查找到范围
        while count > 0 {
            count = count - 1
            let range = results[count].rangeAt(0)
            // 1> 从字符串中获取表情子串
            let emStr = (string as NSString).substring(with: range)
            // 2> 根据 emStr查找对应的表情模型
            if let em = emoticonWithString(string: emStr) {
                // 3> 根据em 建立一个图片属性文本
                let attrText = EmoticonAttachment(emoticon: em).imageText(font: font)
                // 4>替换属性字符串中的内容
                strM.replaceCharacters(in: range, with: attrText)
            }
        }
        
        
        return strM
    }
    
    private func emoticonWithString(string: String) -> Emoticon? {
        //遍历表情包数组
        for package in packages {
            
            
            // 过滤emoticons 数组，查找 em.chs == string 的表情模型
            /*
             1.如果表有返回值，闭包代码只有一句，可以省略return
             2.如果有参数，参数可以使用 $0 $1 ...替代
             3.$0 对应的就是数组中的元素
             */
//            let emoticon = package.emoticons.filter({ (em) -> Bool in
//                em.chs == string
//            }).last
//            if emoticon != nil {
//                return emoticon
//            }
            
            if let emoticon = package.emoticons.filter({ $0.chs == string }).last {
                return emoticon
            }
        }
        
        return nil
    }
    
    
    private init() {
        // 添加最近分组
        packages.append(EmoticonPackage(dict: ["group_name_cn": "最近"]))
        
        // 获取表情数组
        let path = Bundle.main.path(forResource: "emoticons.plist", ofType: nil, inDirectory: "Emoticons.bundle")!
        let dict = NSDictionary(contentsOfFile: path) as! [String: Any]
        let array = (dict["packages"] as! NSArray).value(forKey: "id")
        for id in array as! [String] {
            loadInfoPlist(id: id)
        }
    }
    
    /// 加载每一个id目录下的 content.plist
    private func loadInfoPlist(id: String) {
        let path = Bundle.main.path(forResource: "content.plist", ofType: nil, inDirectory: "Emoticons.bundle/\(id)")!
        let dict = NSDictionary(contentsOfFile: path) as! [String: Any]
        packages.append(EmoticonPackage(dict: dict))
        
    }
    
}
