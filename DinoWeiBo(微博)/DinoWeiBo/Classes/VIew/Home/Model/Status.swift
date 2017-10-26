//
//  Status.swift
//  DinoWeiBo
//
//  Created by liu yao on 2017/2/19.
//  Copyright © 2017年 深圳多诺信息科技有限公司. All rights reserved.
//

import UIKit


/// 微博数据模型
class Status: NSObject {
    
    /// 微博ID
    var id: Int = 0
    
    /// 微博信息内容
    var text: String?
    
    /// 微博创建时间
    var created_at: String?
    
    ///  	微博来源
    var source: String? {
        didSet {
            source = source?.href()?.text
        }
    }
    
    /// 用户模型
    var user: User?
    
    /// 被转发的微博
    var retweeted_status: Status?
    
    /// 缩略图配图数组
    var pic_urls: [[String: String]]?
    
    init(dict: [String: Any]) {
        super.init()
        //使用kvc时接收到value时一个字典，会直接给属性转换成字典
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "user" {
            if let dict = value as? [String: Any] {
                user = User(dict: dict)
            }
            return
        }
        if key == "retweeted_status" {
            if let dict = value as? [String: Any] {
                retweeted_status = Status(dict: dict)
            }
            return
        }
        super.setValue(value, forKey: key)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    override var description: String {
        let keys = ["id","text","created_at","source","user","pic_urls","retweeted_status"]
        return dictionaryWithValues(forKeys: keys).description
    }
}
