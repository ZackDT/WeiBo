//
//  UserAccount.swift
//  DinoWeiBo
//
//  Created by liu yao on 2017/2/12.
//  Copyright © 2017年 深圳多诺信息科技有限公司. All rights reserved.
//

import UIKit


/// 用户账户模型
class UserAccount: NSObject, NSCoding {
    
    /// 授权的access token
    var access_token: String?
    
    /// token生命周期 单位是秒
    var expires_in: TimeInterval  = 0 {
        didSet {
            //计算过期日期
            expiresDate = NSDate(timeIntervalSinceNow: expires_in) as Date
        }
    }
    
    /// 用户UID
    var uid: String?
    
    /// 过期日期
    var expiresDate: Date?
    
    //  	用户昵称
    var screen_name: String?
    
    // 用户头像地址（大图），180×180像素
    var avatar_large: String?
    
    init(dict: [String: Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) { }

    override var description: String {
        let keys = ["access_token","expires_in","uid","expiresDate","avatar_large","screen_name"]
        return dictionaryWithValues(forKeys: keys).description
    }
    
    
    // MARK: - 读取当前对象
    func getUserAccount() -> UserAccount? {
        var path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
        path = (path as NSString).appendingPathComponent("account.plist")
        return NSKeyedUnarchiver.unarchiveObject(withFile: path) as? UserAccount
    }
    
    //MARK: - 归档解档
    
    /// 归档 数据-> 二进制
    ///
    /// - Parameter aCoder: 编码器
    func encode(with aCoder: NSCoder) {
        aCoder.encode(access_token, forKey: "access_token")
        aCoder.encode(expiresDate, forKey: "expiresDate")
        aCoder.encode(uid, forKey: "uid")
        aCoder.encode(screen_name, forKey: "screen_name")
        aCoder.encode(avatar_large, forKey: "avatar_large")
    }
    
    /// 解档
    ///
    /// - Parameter aDecoder: 解码器
    required init?(coder aDecoder: NSCoder) {
        access_token = aDecoder.decodeObject(forKey: "access_token") as? String
        expiresDate = aDecoder.decodeObject(forKey: "expiresDate") as? NSDate as Date?
        uid = aDecoder.decodeObject(forKey: "uid") as? String
        screen_name = aDecoder.decodeObject(forKey: "screen_name") as? String
        avatar_large = aDecoder.decodeObject(forKey: "avatar_large") as? String
    }
    
}

//在extension 只能写遍历构造函数，不能写指定构造函数。不能构造存储性属性。否则会破坏本身结构
extension UserAccount {
    //
}
