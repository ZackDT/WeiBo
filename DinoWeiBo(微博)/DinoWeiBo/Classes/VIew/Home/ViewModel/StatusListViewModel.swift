//
//  StatusListViewModel.swift
//  DinoWeiBo
//
//  Created by liu yao on 2017/2/19.
//  Copyright © 2017年 深圳多诺信息科技有限公司. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

/// 微博数据列表模型 - 封装网络方法
class StatusListViewModel {
    
    /// 微博数据数组 - 上拉、下拉加载
    lazy var statusList = [StatusViewModel]()
    
    /// 下拉刷新计数
    var pullDownCount: Int?
    
    /// 加载微博数据库
    ///
    /// - Parameters:
    ///   - isPullup: 是否上拉刷新
    ///   - finished: 完成回调
    func loadStatus(isPullup:Bool, finished: @escaping (_ isSuccessed: Bool)->()) {
        
        // 下拉刷新
        let since_id = isPullup ? 0 : (statusList.first?.status.id ?? 0)
        
        //上拉刷新
        let max_id = isPullup ? (statusList.last?.status.id ?? 0) : 0
    
        StatusDAL.loadStatus(since_id: since_id, max_id: max_id) { (array) in
            // 为nil
            guard let array = array else {
                finished(false)
                return
            }
            //2.遍历数组
            var dataList = [StatusViewModel]()
            for dict in array {
                dataList.append(StatusViewModel(status: Status(dict: dict)))
            }
            QL2("刷新到\(dataList.count)条数据")
            
            // 记录下拉刷新的数据
            self.pullDownCount = (since_id > 0) ? dataList.count : 0
            
            //3.拼接数据 数据拼接 直接先加
            //判断是否是上拉刷新
            if max_id > 0 {
                self.statusList += dataList
            } else {
               self.statusList = dataList + self.statusList
            }
            
            self.cacheStringImage(dataList: dataList, finished: finished)
        }
    }
    
    
    private func cacheStringImage(dataList: [StatusViewModel],finished: @escaping (_ isSuccessed: Bool)->()) {
        //创建调度组
        let group = DispatchGroup()
        for vm in dataList {
            // 判断图片数量是否是单张
            if vm.thumbnailUrls?.count != 1 {
                continue
            }
            let url = vm.thumbnailUrls![0]
            // 入组 - 监听后续的block
            group.enter()
            let downloader = KingfisherManager.shared
            downloader.retrieveImage(with: url, options: nil, progressBlock: nil, completionHandler: { (image, _, _, _) in
                group.leave()
            })
        }
        group.notify(queue: DispatchQueue.main) {
            finished(true)
            QL2("缓存完成")
        }
    }
    
}
