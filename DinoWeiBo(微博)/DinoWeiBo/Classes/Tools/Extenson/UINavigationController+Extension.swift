//
//  UINavigationController+Extension.swift
//  DouYuZB
//
//  Created by 刘耀 on 2017/4/16.
//  Copyright © 2017年 深圳多诺信息科技有限公司. All rights reserved.
//

import Foundation

extension UINavigationController {
    
    func fullScreenPopGes() {
        // 添加全屏的pop手势
        // 1.获取系统的pop手势
        guard let systemGes = interactivePopGestureRecognizer else {
            return
        }
        // 2.获取手势添加的view
        guard let gesView = systemGes.view else {
            return
        }
        // 3. 获取target/ action
        /*
         // 3.1 利用运行时机制查看所有属性的名称
         var count: UInt32 = 0
         let ivars = class_copyIvarList(UIGestureRecognizer.self, &count)
         for i in 0..<count {
         let ivar = ivars?[Int(i)]
         let name = ivar_getName(ivar)
         
         QL1(String(cString: name!))
         }
         */
        let targets = systemGes.value(forKey: "_targets") as? [NSObject]
        guard let targetObjc = targets?.first else { return }
        QL1(targetObjc)
        // 3.2 去除target
        guard let target = targetObjc.value(forKey: "target") else {return}
        // 3.3去除action
        //        guard let action = targetObjc.value(forKey: "action") else { return }
        
        let action = Selector(("handleNavigationTransition:"))
        // 4.创建自己的pan手势
        let panGes = UIPanGestureRecognizer()
        gesView.addGestureRecognizer(panGes)
        panGes.addTarget(target, action: action)
    }
    
}
