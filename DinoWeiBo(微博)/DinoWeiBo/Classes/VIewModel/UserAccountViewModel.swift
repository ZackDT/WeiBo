//
//  UserAccountViewModel.swift
//  DinoWeiBo
//
//  Created by liu yao on 2017/2/14.
//  Copyright © 2017年 深圳多诺信息科技有限公司. All rights reserved.
//

import Foundation

/*
 模型视图继承自NSObject，->可以使用KVC设置属性，简化对象构造
 如果没有父类，所有内容，都需要从头创建，量级更轻。
 封装业务逻辑
 封装网络请求
 
 */

/// 用户账号模型视图  - 没有父类
class UserAccountViewModel {
    
    
    /// 单利
    static let sharedUserAccount = UserAccountViewModel()
    
    /// 用户模型
    var account: UserAccount?
    
    /// 返回有效的tkoen，如果过期为nil
    var accessToken: String? {
        
        if !isExpired {
            //如果没有过期返回accessToken
            return account?.access_token
        }
        return nil
    }
    
    
    /// 用户登录标记
    var userLogon: Bool {
        //如果token有值 而且没有过期，说明登录有效
        if account?.access_token != nil && !isExpired {
            return true
        }
        return false
    }
    
    /// 用户头像
    var avatarUrl: URL {
        return URL(string: (account?.avatar_large ?? "")!)!
    }
    
    /// 保存路径 计算属性 -
     var accountPath: String {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
        return (path as NSString).appendingPathComponent("account.plist")
    }
    
    /// 判断是否过期 计算属性-
    private var isExpired: Bool {
        //判断用户过期日期与系统当前日期进行比较
//        account?.expiresDate = Date(timeIntervalSinceNow: -3600) //测试逻辑
        if account?.expiresDate?.compare(Date()) == .orderedDescending {
            return false
        }
        // 如果过期 返回true
        return true
    }
    
    /// 构造函数 - 私有化
    private init() {
        //从沙盒解档数据
        account = NSKeyedUnarchiver.unarchiveObject(withFile: accountPath) as? UserAccount
        QL2(account?.description ?? "")
        //判断是否过期
        if isExpired {
            QL4("已经过期")
            account = nil;
        }
        
    }
    
}

extension UserAccountViewModel {
    
    /// 加载token
    ///
    /// - Parameters:
    ///   - code: 授权码
    ///   - finished: 完成的回调（是否成功）
    func loadAccessToken(code: String, finished:@escaping (_ isSuccessed: Bool) -> ()) {
        AFNetworkTools.sharedTools.loadAccessToken(code: code) { (result, error) in
            if error != nil {
                QL4("记载用户出错了")
    
                //失败的回调
                finished(false)
                return
            }
            QL2(result ?? "没有结果")
            // 注意Any类型在使用的时候必须要转换,不能直接计算
            self.account = UserAccount(dict: result as! [String : Any])
            
            self.loadUserInfo(account: self.account!, finished: finished)
        }
    }
    
    /// 加载用户信息
    ///
    /// - Parameters:
    ///   - account: 用户模型
    ///   - finished: 完成的回调
    private func loadUserInfo(account: UserAccount, finished:@escaping (_ isSuccessed: Bool) -> ())  {
        AFNetworkTools.sharedTools.loadUserInfo(uid: account.uid!) { (result, error) in
            if error != nil {
                QL4("记载用户出错了")
                //失败的回调
                finished(false)
                return
            }
            //提示：如果使用if let / guard let 使用？
            //判断是否有内容，在判断是否是字典
            guard let dict = (result as? [String: Any]) else {
                QL4("格式错误")
                //失败的回调
                finished(false)
                return
            }
            //保存用户信息
            account.screen_name = dict["screen_name"] as? String
            account.avatar_large = dict["avatar_large"] as? String
            //保存对象
            NSKeyedArchiver.archiveRootObject(account, toFile: self.accountPath)
            
            //成功的回调
            finished(true)
        }
    }

}
