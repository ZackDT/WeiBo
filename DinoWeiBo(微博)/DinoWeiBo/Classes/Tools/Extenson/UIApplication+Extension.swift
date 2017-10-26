//
//  UIApplication+Extension.swift
//  DinoWeiBo
//
//  Created by 刘耀 on 2017/4/8.
//  Copyright © 2017年 深圳多诺信息科技有限公司. All rights reserved.
//

import Foundation

extension UIApplication {
    
    
    /// 获取栈顶的控制器
    ///
    /// - Parameter base: 控制器
    /// - Returns: 控制器
    public class func topViewController(_ base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        
        if let tab = base as? UITabBarController {
            let moreNavigationController = tab.moreNavigationController
            
            if let top = moreNavigationController.topViewController, top.view.window != nil {
                return topViewController(top)
            } else if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        
        return base
    }
    
    
    /// 更改根控制器
    ///
    /// - Parameters:
    ///   - rootViewController: 根控制器
    ///   - animated: 动画默认是有
    ///   - from: 来源控制器，默认为nil
    ///   - completion: 完成的回调
    static public func changeRootViewController(_ rootViewController: UIViewController, animated: Bool = true, from: UIViewController? = nil, completion: ((Bool) -> Void)? = nil) {
        let window = UIApplication.shared.keyWindow ?? UIApplication.shared.delegate?.window ?? nil
        if let window = window, animated {
            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
                let oldState: Bool = UIView.areAnimationsEnabled
                UIView.setAnimationsEnabled(false)
                window.rootViewController = rootViewController
                window.makeKeyAndVisible()
                UIView.setAnimationsEnabled(oldState)
            }, completion: completion)
        } else {
            window?.rootViewController = rootViewController
        }
    }
    
    static public func changeRootViewControllerAfterDismiss(_ from: UIViewController? = nil, to: UIViewController, completion: ((Bool) -> Void)? = nil) {
        if let presenting = from?.presentingViewController {
            presenting.view.alpha = 0
            from?.dismiss(animated: false, completion: {
                changeRootViewController(to, completion: completion)
            })
        } else {
            changeRootViewController(to, completion: completion)
        }
    }
    
    
    /// 拨打电话
    ///
    /// - Parameter phoneNumber: 电话号码字符串
    /// - Returns: 是否成功
    public static func makePhoneCall(_ phoneNumber: String) -> Bool {
        guard let phoneNumberUrl = URL(string: phoneNumber), UIApplication.shared.canOpenURL(phoneNumberUrl) else {
            return false
        }
        return UIApplication.shared.openURL(phoneNumberUrl)
    }
    
    /// bundle ID
    public static var bundleIdentifier: String {
        return Bundle.main.bundleIdentifier!
    }
    
    
    /// 标识(发布或未发布)的内部版本号
    public static var buildVersion: String {
        return Bundle.main.infoDictionary!["CFBundleVersion"] as! String
    }
    
    
    /// 当前版本
    public static var appVersion: String {
        return Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    }
    
    
    public static var bundleName: String {
        return Bundle.main.infoDictionary!["CFBundleName"] as! String
    }
}
