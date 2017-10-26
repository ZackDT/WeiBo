//
//  MainViewController.swift
//  DinoWeiBo
//
//  Created by liu yao on 2017/2/5.
//  Copyright © 2017年 深圳多诺信息科技有限公司. All rights reserved.
//

import UIKit

class MainTabBarViewController: UITabBarController {
    
    // MARK: - 监听方法
    /// 点击撰写按钮
    // 单纯使用private，运行循环将无法准确发送消息，导致崩溃。所以需要添加@objc。@objc能搞保证运行循环能够发送此消息，即使函数标记为private。
    @objc private func clickComposedButton() {
        // 判断是否登录
        var vc: UIViewController
        if UserAccountViewModel.sharedUserAccount.userLogon {
            vc = ComposeViewController()
        }else {
            vc = OAuthViewController()
        }
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true, completion: nil)
    }
    
    // MARK: - 视图生命周期函数
    override func viewDidLoad() {
        super.viewDidLoad()
        //添加的按钮 不能点击高亮？
        addChildViewControllers()
        //注意这里添加控制器，并不会创建tabBar中的按钮！
        setupComposeButton()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        //解决撰写按钮高亮点击的问题
        tabBar.bringSubview(toFront: composedButton)
    }
    
    // MARK: - 懒加载控件
    private lazy var composedButton: UIButton = UIButton(
        imageName: "tabbar_compose_icon_add",
        backImageName: "tabbar_compose_button")
    
    private func setupComposeButton() {
        tabBar.addSubview(composedButton)
        //调整按钮
        let count = childViewControllers.count
        // - 1 是为了解决手指触摸的容错问题。不减1 点击有时候出现空白控制对应的界面视图
        let w = tabBar.bounds.width / CGFloat(count) - 1
        //insetBy方法： 返回尺寸矩形，dx左右各缩2w举例 和dy分别是位置
        composedButton.frame = tabBar.bounds.insetBy(dx: 2 * w, dy: 0)
        //添加监听方法
        composedButton.addTarget(self, action: #selector(MainTabBarViewController.clickComposedButton), for: .touchUpInside)
    }

}

// MARK: - 设置界面
extension MainTabBarViewController {
    
    /// 添加所有的控制器
    func addChildViewControllers() {
        
        addChildViewController(vc: HomeTableViewController(), title: "首页", imageName: "tabbar_home")
        addChildViewController(vc: MessageTableViewController(), title: "消息", imageName: "tabbar_message_center")
        
        addChildViewController(UIViewController())
        
        addChildViewController(vc: DiscoverTableViewController(), title: "发现", imageName: "tabbar_discover")
        addChildViewController(vc: ProfileTableViewController(), title: "我", imageName: "tabbar_profile")
    }
    
    private func addChildViewController(vc: UIViewController, title: String, imageName: String) {
        vc.title = title
        vc.tabBarItem.image = UIImage(named: imageName)
        let nav = MainNavigationController(rootViewController: vc)
        addChildViewController(nav)
    }
}
