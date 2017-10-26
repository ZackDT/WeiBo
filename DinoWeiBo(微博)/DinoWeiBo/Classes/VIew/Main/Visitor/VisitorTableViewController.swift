//
//  VisitorTableViewController.swift
//  DinoWeiBo
//
//  Created by liu yao on 2017/2/5.
//  Copyright © 2017年 深圳多诺信息科技有限公司. All rights reserved.
//

import UIKit

class VisitorTableViewController: UITableViewController {

    
    /// 用户登录标记
    private var userLogon = UserAccountViewModel.sharedUserAccount.userLogon
    
    var visitorView: VisitorView?
    
    override func loadView() {
        userLogon ? super.loadView() : setupVisitorView()
    }

    
    /// 设置访客视图
    private func setupVisitorView() {
        visitorView = VisitorView()
        visitorView?.delegate = self
        view = visitorView
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: .plain, target: self, action: #selector(VisitorTableViewController.visitorViewDidRegister))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: .plain, target: self, action: #selector(VisitorTableViewController.visitorViewDidLogin))
    }

}


// MARK: - 访客视图监听方法
extension VisitorTableViewController: VisitorViewDelegate {
    func visitorViewDidRegister() {
        print("注册")
    }
    func visitorViewDidLogin() {
        let nav = UINavigationController(rootViewController: OAuthViewController())
        present(nav, animated: true, completion: nil)
    }
}
