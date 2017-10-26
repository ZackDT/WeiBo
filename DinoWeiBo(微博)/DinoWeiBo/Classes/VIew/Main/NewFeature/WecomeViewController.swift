//
//  WecomeViewController.swift
//  DinoWeiBo
//
//  Created by liu yao on 2017/2/17.
//  Copyright © 2017年 深圳多诺信息科技有限公司. All rights reserved.
//

import UIKit
import Kingfisher


/// 欢迎界面
class WecomeViewController: UIViewController {
    
    override func loadView() {
        // 直接使用背景图像作为跟视图
        view = backImageView
        setupUI()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        iconView.kf.setImage(with: UserAccountViewModel.sharedUserAccount.avatarUrl)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //multipliedBy -> 只读属性，不允许修改
        // 使用自动布局开发，所有约束设置位置的控件，不要在设置frame。 在layoutSubview中设置frame
        iconView.snp.updateConstraints { (make) in
            make.bottom.equalTo(view.snp.bottom).offset(-view.bounds.height + 200)
        }
        
        //动画
        welcomeLabel.alpha = 0
        UIView.animate(withDuration: 1.2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 10, options: [], animations: {
            //自动布局的动画
            self.view.layoutIfNeeded()
        }) { (_) in
            UIView.animate(withDuration: 0.8, animations: { 
                self.welcomeLabel.alpha = 1
            }, completion: { (_) in
                //不推荐的写法。因为跟视图最好是有Appdelegate来控制
//                UIApplication.shared.keyWindow?.rootViewController = MainViewController()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: DinoSwitchRootViewControllerNotification), object: nil)
            })
        }
    }

    // MARK: - 设置界面
    private func setupUI() {
        view.addSubview(iconView)
        iconView.faceAwareFill()
        view.addSubview(welcomeLabel)
        iconView.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.bottom.equalTo(view.snp.bottom).offset(-200)
            make.size.equalTo(CGSize(width: 90, height: 90))
        }
        welcomeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(iconView.snp.bottom).offset(16)
            make.centerX.equalTo(iconView)
        }
        
    }
    
    // MARK: - 懒加载
    private lazy var backImageView: UIImageView = UIImageView(imageName: "ad_background")
    
    /// 头像
    private lazy var iconView: UIImageView = {
        let iv = UIImageView(imageName: "avatar_default_big")
        iv.layer.cornerRadius = 45
        iv.layer.masksToBounds = true
        return iv
    }()
    
    private lazy var welcomeLabel: UILabel = UILabel(title: "欢迎归来", fontSize: 18)

}

// MARK: -
extension WecomeViewController {
    
    
}
