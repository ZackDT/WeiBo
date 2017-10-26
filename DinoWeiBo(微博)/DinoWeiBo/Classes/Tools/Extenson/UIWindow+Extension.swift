//
//  UIWindow.swift
//  DinoWeiBo
//
//  Created by liu yao on 2017/3/27.
//  Copyright © 2017年 深圳多诺信息科技有限公司. All rights reserved.
//

import Foundation
import UIKit

extension UIWindow {
    
    public class func currentViewController() -> UIViewController {
        return self.findBestViewController(UIApplication.shared.keyWindow?.rootViewController)
    }
    
    private class func findBestViewController(_ vc: UIViewController?) -> UIViewController {
        if ((vc?.presentedViewController) != nil) {
            return self.findBestViewController(vc?.presentedViewController)
        } else if (vc?.isKind(of: UISplitViewController.classForCoder()) == true) {
            let masterVC = vc as! UISplitViewController
            if masterVC.viewControllers.count > 0 {
                return self.findBestViewController(masterVC.viewControllers.last)
            } else {
                return vc!
            }
        }else if (vc?.isKind(of: UINavigationController.classForCoder()) == true) {
            let nav = vc as! UINavigationController
            if nav.viewControllers.count > 0 {
                return self.findBestViewController(nav.topViewController)
            }else {
                return vc!
            }
        } else if (vc?.isKind(of: UITabBarController.classForCoder()) == true) {
            let tabBar = vc as! UITabBarController
            if (tabBar.viewControllers?.count)! > 0 {
                return self.findBestViewController(tabBar.selectedViewController)
            }else {
                return vc!
            }
        } else {
            return vc!
        }
    }
}

