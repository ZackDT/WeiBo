//
//  AppDelegate.swift
//  DinoWeiBo
//
//  Created by liu yao on 2017/2/5.
//  Copyright © 2017年 深圳多诺信息科技有限公司. All rights reserved.
//

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        UIViewController.swizzIt() // 显示文件层次
        QorumLogs.enabled = true  //打印输出控制
        
        setupAppearance()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        
        window?.rootViewController = defaultRootViewController
        window?.makeKeyAndVisible()
        
        NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.switchRootController(notification:)), name: NSNotification.Name(rawValue: DinoSwitchRootViewControllerNotification), object: nil)
    
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // 清理数据缓存
        StatusDAL.clearDataCache()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    /// 设置全局外观
    @objc private func setupAppearance() {
        
        UINavigationBar.appearance().tintColor = WBAppearanceTinColor
        UITabBar.appearance().tintColor = WBAppearanceTinColor
    }
    
    /// 切换控制器的方法
    @objc private func switchRootController(notification: Notification) {
        let vc = (notification.object != nil) ? WecomeViewController() : MainTabBarViewController()
        self.window?.rootViewController = vc
    }
}


// MARK: - 界面切换代码
extension AppDelegate {
    
    
    /// 默认启动的跟视图控制器
    var defaultRootViewController: UIViewController {
        //1.判断是否登录
        if UserAccountViewModel.sharedUserAccount.userLogon {
            return isNewVersion ? NewFeatureViewController() : WecomeViewController()
        }
        
        return MainTabBarViewController()
    }
    
    var isNewVersion: Bool {
        //1.当前的版本
        let currentVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        let version = Double(currentVersion)!
        //2.之前的版本
        let sandboxVersionKey = "sandboxVersionKey"
        let sandboxVersion = UserDefaults.standard.double(forKey: sandboxVersionKey)
        // 3.保存当前版本
        UserDefaults.standard.set(version, forKey: sandboxVersionKey)
        
        return version > sandboxVersion
    }
}

