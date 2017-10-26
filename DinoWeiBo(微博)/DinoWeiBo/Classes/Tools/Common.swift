//
//  Common.swift
//  DinoWeiBo
//
//  Created by liu yao on 2017/2/7.
//  Copyright © 2017年 深圳多诺信息科技有限公司. All rights reserved.
//

// 目的： 提供全局共享属性或者方法
import UIKit

// MARK: - 全局通知
/// 切换跟视图控制器通知
let DinoSwitchRootViewControllerNotification = "DinoSwitchRootViewControllerNotification"

/// 选中图片通知
let DinoSelectedPhopoNotification = "DinoSelectphopoNotification"
/// 选中图片的 KEY - IndexPath
let DinoSelectedPhotoIndexpathKey = "DinoSelectedPhotoIndexpathKey"
/// 选中图片的 KEY - URL 数组
let DinoSelectedPhotoURLKey = "DinoSelectedPhotoURLKey"


/// 常用常数
let kStatusBarH : CGFloat = 20
let kNavBarH :CGFloat = 44
let kScreenW = UIScreen.main.bounds.width
let kScreenH = UIScreen.main.bounds.height
let kTabBarH :CGFloat = 44
let kMenuViewH : CGFloat = 200


/// 全局的外观设置颜色 -> 延展出“配色”的管理类
let WBAppearanceTinColor = UIColor.orange   // 系统主色
let myBlackColr = UIColor(hex: 0x424243)    //常用的黑色
let mygrayColor = UIColor(hex: 0xb2b2b2)    //常用的灰色

let keyWindow = UIApplication.shared.keyWindow

