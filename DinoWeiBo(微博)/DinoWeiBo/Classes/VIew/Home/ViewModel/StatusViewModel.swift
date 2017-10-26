
//
//  StatusViewModel.swift
//  DinoWeiBo
//
//  Created by liu yao on 2017/2/20.
//  Copyright © 2017年 深圳多诺信息科技有限公司. All rights reserved.
//

import Foundation
import UIKit

/// 微博视图模型 - 处理单条微博的业务逻辑
class StatusViewModel: CustomStringConvertible {
    
    
    /// 微博模型
    var status: Status
    
    var cellId: String {
        return status.retweeted_status != nil ? StatusRetweetedId : StatusCellNormalId
    }
    
    /// 缓存的行高数值  方法一：直接外面计算赋值  方法二:利用懒加载计算行高
    lazy var rowHeight: CGFloat = {
        // 2.计算cell
        var cell: StatusCell
        if self.status.retweeted_status != nil {
            cell = StatusRetweetedCell(style: .default, reuseIdentifier: StatusRetweetedId)
        }else {
            cell = StatusNormalCell(style: .default, reuseIdentifier: StatusCellNormalId)
        }
        return cell.rowHeght(vm: self)
    }()
    
    /// 微博发布日期
    var createAt: String {
        return (status.created_at?.sinaDate()?.dateDescription)!
    }
    
    /// 用户头像
    var userprofileUrl: URL {
        return URL(string: (status.user?.profile_image_url)!)!
    }
    
    /// 用户会员图标
    var memberImage: UIImage? {
        if (status.user?.mbrank)! > 0 && (status.user?.mbrank)! < 7 {
            return UIImage(named: "common_icon_membership_level\(status.user!.mbrank)")
        }
        return nil
    }
    
    /// 缩略图URL数组 - 设置成存储型属性。不用计算型属性（每次都会计算）。
    // 如果是转发微博，一定没有图
    var thumbnailUrls: [URL]?
    
    var retweetedText: String? {
        // 1. 判断是否是转发微博
        guard let s = status.retweeted_status else {
            return nil
        }
        // 2. 转发微博
        return "@" + (s.user?.screen_name ?? "") + ":" + (s.text ?? "")
    }
    
    /// 用户认证图标
    /// 认证类型，-1：没有认证，0-认证用户，2.3.5-企业认证，220-达人
    var userVipImage: UIImage? {
        switch (status.user?.verified_type ?? -1) {
        case 0:
            return UIImage(named: "avatar_vip")
        case 2,3,5:
            return UIImage(named: "avatar_enterprise_vip")
        case 220:
            return UIImage(named: "avatar_grassroot")
        default:
            return nil
        }
    }
    
    init(status: Status) {
        self.status = status
        //根据模型，生成缩略图数组 .有转发微博，先从转发为微博那图片，没有的话看原创微博是否有图片
        guard let urls = status.retweeted_status?.pic_urls ?? status.pic_urls else {
            return
        }
        thumbnailUrls = [URL]()
        // 数组可选，不允许遍历
        for dict in urls {
            // 字典key出错，会返回nil
            let url = URL(string: dict["thumbnail_pic"]!)
            thumbnailUrls?.append(url!)
        }
        
        
    }
    
    // 遵守 CustomStringConvertible 协议 ,怎么做没有父类的描述信息： 实现这个协议。
    var description: String {
        return status.description + "配图数组\(thumbnailUrls ?? [] as Array))"
    }
    
}
