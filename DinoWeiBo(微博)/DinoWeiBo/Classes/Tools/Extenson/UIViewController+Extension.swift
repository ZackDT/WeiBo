//
//  UIViewController+Extension.swift
//  DinoWeiBo
//
//  Created by liu yao on 2017/3/25.
//  Copyright © 2017年 深圳多诺信息科技有限公司. All rights reserved.
//

import UIKit

extension UIViewController {
    
    
    /// 便利初始化
    ///
    /// - Parameter title: 标题
    convenience init(title: String) {
        self.init()
        self.title = title
    }
    
    /**
     显示alert
     
     - Parameter title:   标题
     - Parameter message: 消息
     - Parameter actions: 动作数组
     */
    func displayAlert(_ title: String?, message: String?, actions: [UIAlertAction]?, preferredStyle: UIAlertControllerStyle = .alert) {
        let alertCtl = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        if let actions = actions {
            for action in actions {
                alertCtl.addAction(action)
            }
        }else {
            // 默认的按钮
            alertCtl.addAction(UIAlertAction(title: "确定", style: .cancel, handler: nil))
        }
        present(alertCtl, animated: true, completion: nil)
    }
    
    /**
     显示alert
     
     - Parameter message: 消息
     - Parameter actions: 动作数组
     */
    func displayAlert(message: String, actions: [UIAlertAction]) {
        displayAlert(nil, message: message, actions: actions)
    }
    
    
    func displayAlert(_ title: String? = nil, message: String, closure: (() -> Void)? = nil) {
        let action = UIAlertAction(title: "确定", style: .cancel) { (action) in
            closure?()
        }
        displayAlert(title, message: message, actions: closure == nil ? nil : [action])
        
    }
    
    
    /// 显示Alert
    ///
    /// - Parameters:
    ///   - title: 标题
    ///   - message: 信息
    public func showError(_ title: String, message: String? = nil) {
        if !Thread.current.isMainThread {
            DispatchQueue.main.async { [weak self] in
                self?.showError(title, message: message)
            }
            return
        }
        
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        controller.view.tintColor = UIWindow.appearance().tintColor
        controller.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .cancel, handler: nil))
        present(controller, animated: true, completion: nil)
    }
    
}
