//
//  FMDBShareApi.swift
//  DinoWeiBo
//
//  Created by liu yao on 2017/3/25.
//  Copyright © 2017年 深圳多诺信息科技有限公司. All rights reserved.
//

import UIKit
import FMDB


/// 数据库名称 - 数据库名称 可以随意取 readme.txt
private let dbName = "status.db"

class SQLiteManager {
    
    /// 单例
    static let share = SQLiteManager()
    
    /// 全局数据库操作队列
    let queue: FMDatabaseQueue
    
    private init() {
        // 1、打开数据库队列
        var path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
        path = (path as NSString).appendingPathComponent(dbName)
        QL2("数据库路径%" + path)
        // 数据库不存在就创建 创建队列
        queue = FMDatabaseQueue(path: path)
        createTable()
    }
    
    private func createTable() {
        // 1、从 bundel 中加载
        let path = Bundle.main.path(forResource: "db.sql", ofType: nil)!
        // 2、读取 SQL 字符串
        let sql = try! String(contentsOfFile: path)
        
        queue.inDatabase { (db) in
            // 创建数据表的时候，最好执行 executeStatements,可以执行多个sql
            if db!.executeStatements(sql) {
                QL2("创建表格成功")
            }
        }
    }
    
    /// 查询数组
    ///
    /// - Parameter sql: sql
    /// - Returns: 数组
    func execRecordSet(sql: String) -> [[String: Any]]{
        var array = [[String: Any]]()
        
        SQLiteManager.share.queue.inDatabase { (db) in
            let rs = db!.executeQuery(sql, withArgumentsIn: [])!
            while rs.next() {
                // 1、列数
                let colCoumnt = rs.columnCount()
                var dict = [String: Any]()
                for col in 0..<colCoumnt {
                    let name = rs.columnName(for: col)
                    let obj = rs.object(forColumnIndex: col)
                    dict[name!] = obj
                }
                array.append(dict)
            }
            
        }
        return array
    }
    
    

}
