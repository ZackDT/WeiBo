//
//  StatusDAL.swift
//  DinoWeiBo
//
//  Created by liu yao on 2017/4/1.
//  Copyright © 2017年 深圳多诺信息科技有限公司. All rights reserved.
//

import Foundation

private let maxCacheDateTime: TimeInterval = 7 * 24 * 60 * 60

/// 数据访问层 - 目标： 专门处理本地 SQLite 和 网络数据
class StatusDAL {
    /*
     1、一般不会吧音频、图片、视频放入数据库中，占用磁盘空间很大
     2、一定要定期清理数据库缓存：SQLite的数据库随着数据的增大，会不断变大
     3、清理工作不要交给用户
     */
    
    /// 清理 ‘早于过期日期’ 的缓存数据
    class func clearDataCache() {
        let date = Date(timeIntervalSinceNow: maxCacheDateTime)
        
        // 日期格式转换
        let df = DateFormatter()
        // 指定区域，模拟器不需要，但是真机一定需要
        df.locale = Locale(identifier: "en")
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateStr = df.string(from: date)
        
        let sql = "DELETE FROM T_Status WHERE createTime < ?"
        SQLiteManager.share.queue.inDatabase { (db) in
            if db!.executeUpdate(sql, withArgumentsIn: [dateStr]) {
                QL2("删除\(String(describing: db!.changes()))条缓存数据")
            }
        }
        
    }
    
    class func loadStatus(since_id: Int,max_id: Int,finished: @escaping (_ array: [[String: Any]]?)->()) {
        
        // 1、检查本地是否存在缓存数据
        let array = checkChacheData(since_id: since_id, max_id: max_id)
        // 2、如果有，返回缓存数据
        if array != nil && (array!.count > 0) {
            QL2("查询到缓存数据")
            finished(array!)
            return
        }
        // 3、如果没有，加载网络数据
        AFNetworkTools.sharedTools.loadStatus(since_id: since_id, max_id: max_id) { (result, error) in
            if error != nil {
                print("请求微博数据出错")
                finished(nil)
                return
            }
            
            //3.1.判断result 数据结构是否正确
            let dict = result as? [String : Any]
            guard let array =  dict?["statuses"] as? [[String: Any]] else {
                QL4("数据格式错误")
                finished(nil)
                return
            }
            
            // 4、将网络返回的数据，保存在本地数据库，以便后续使用
            StatusDAL.saveCacheData(array: array)
            //5、返回网络数据
            finished(array)
        }
    }
    
    /// 1、检查本地是否存在缓存数据
    private class func checkChacheData(since_id: Int,max_id: Int) -> [[String: Any]]? {
        QL2("检查本地数据\(since_id),\(max_id)")
        guard let userId = UserAccountViewModel.sharedUserAccount.account?.uid else {
            QL4("用户没有登录")
            return nil
        }
        // 1、准备sql
        var sql = "SELECT statusId, status, userId FROM T_Status "
        sql += "WHERE userId = \(userId)  "
        if since_id > 0 {
            // 下拉刷新
            sql += "    AND statusId > \(since_id) "
        }else if max_id > 0 {
            // 上拉刷新
            sql += "    AND statusId < \(max_id) "
        }
        sql += "ORDER BY statusId DESC LIMIT 20;"
        debugPrint("查询数据SQL ->"+sql)
        
        // 2、执行 SQL -》 返回结果结合
        let array = SQLiteManager.share.execRecordSet(sql: sql)

        
        // 3、遍历数组 -> dict["status"] JSON 反序列化 
        var arrayM = [[String: Any]]()
        for dict in array {
            let jsonData = dict["status"] as! Data
            let result = try! JSONSerialization.jsonObject(with: jsonData, options: [])
            arrayM.append(result as! [String: Any])
        }

        return arrayM
    }
    
    
    /// 将网络返回的数据保存在本地数据库
    // 参数：网络返回的字典数据  如果插入数据应该使用事务（安全快速）
    private class func saveCacheData(array: [[String: Any]]) {

        guard let userId = UserAccountViewModel.sharedUserAccount.account?.uid else {
            QL4("用户没有登录")
            return
        }
        
        let sql = "INSERT OR REPLACE INTO T_Status (statusId, status, userId) VALUES (?, ?, ?);"
        
        SQLiteManager.share.queue.inTransaction { (db, roolback) in
            // 遍历数组
            
            do {
                for dict in array {
                    let statusId = dict["id"] as! Int
                    // 序列化字典 -> 二进制数据
                    let json = try! JSONSerialization.data(withJSONObject: dict, options: [])
                    try db?.executeUpdate(sql, values: [statusId, json, userId])
                    
                }
            } catch {
                QL4("插入数据失败")
//                roolback?.memory = true //这里一直失败
            }
            QL2("数据插入完成")
            
        }
        
        
    }
    
}
