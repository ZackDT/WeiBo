//
//  MainNavigationController.swift
//  DinoWeiBo
//
//  Created by liu yao on 2017/4/2.
//  Copyright © 2017年 深圳多诺信息科技有限公司. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @objc func backBtnClick(sender: UIButton) {
        popViewController(animated: true)
    }

    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
            var backImage = UIImage(named: "navigationbar_back_highlighted")
            backImage = backImage?.withRenderingMode(.alwaysTemplate)
            let backBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            backBtn.tintColor = UIColor.orange
            backBtn.setImage(backImage, for: UIControlState())
            backBtn.addTarget(self, action: #selector(MainNavigationController.backBtnClick(sender:)), for: .touchUpInside)

            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
            
        }
        super.pushViewController(viewController, animated: animated)
    }
 

}
