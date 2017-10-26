//
//  VisitorView.swift
//  DinoWeiBo
//
//  Created by liu yao on 2017/2/5.
//  Copyright © 2017年 深圳多诺信息科技有限公司. All rights reserved.
//

import UIKit
import SnapKit

/*
 使用带来传递消息是为了在控制器和视图之间解耦，让视图在多个控制器复用。例如UITableView。
 但是如果视图仅是为了封装代码，而从控制器中剥离出来，并且确认该视图不会被其他控制器复用，可以直接用addTarget方法
 */

//传递事件：代理、通知、block、kvo、addTag。不用代理也可以用self的属性直接添加添加监听方法
/// 访客视图协议
protocol VisitorViewDelegate:NSObjectProtocol {
    
    /// 注册
    func visitorViewDidRegister()
    
    /// 登录
    func visitorViewDidLogin()
}

/// 访客视图 - 处理未登录的界面显示
class VisitorView: UIView {
    
    /// 弱引用
    weak var delegate: VisitorViewDelegate?
    
    // MARK: - 监听方法
    @objc private func clickLogin() {
        
        delegate?.visitorViewDidLogin()
    }
    @objc private func clickRegister() {
        loginButton.shake()
        delegate?.visitorViewDidRegister()
    }
    
    // MARK: - 设置视图信息
    /// 设置视图信息
    ///
    /// - Parameters:
    ///   - imageName: 图片， 首页设置为nil
    ///   - title: 消息文字
    func setupInfo(imageName: String?, title: String) {
        messageLabel.text = title
        //为nil的话是首页
        guard let imgName = imageName else {
            startAnim()
            return
        }
        iconView.image = UIImage(named: imgName)
        homeView.isHidden = true
        //将遮罩视图移动到底层
        sendSubview(toBack: maskIconView)
    }
    
    private func startAnim() {
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.toValue = 2 * M_PI
        anim.repeatCount = MAXFLOAT
        anim.duration = 20
        anim.isRemovedOnCompletion = false
        iconView.layer.add(anim, forKey: nil)
    }
    
    /// 指定构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    // 使用sb或xib开发加载的函数
    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
        setupUI()
    }
    
    /// 图标
    private lazy var iconView: UIImageView = UIImageView(imageName: "visitordiscover_feed_image_smallicon")
    /// 遮罩图像
    private lazy var maskIconView: UIImageView = UIImageView(imageName: "visitordiscover_feed_mask_smallicon")
    private lazy var homeView: UIImageView = UIImageView(imageName: "visitordiscover_feed_image_house")
    /// 消息文字
    private lazy var messageLabel: UILabel = UILabel(title: "关注一些人，会这看看有什么惊喜！")

    //注册按钮
    private lazy var registerButton: UIButton = UIButton(title: "注册", color: UIColor.orange, backimageName: "common_button_white_disable")
    //登录按钮
    private lazy var loginButton: UIButton = UIButton(title: "登录", color: UIColor.orange, backimageName: "common_button_white_disable")
    
    /// 设置界面
    private func setupUI() {
        //这里使用苹果的自动布局来写
        //建议子视图最好有一个统一的参照物
        addSubview(iconView)
        addSubview(maskIconView)
        addSubview(homeView)
        addSubview(messageLabel)
        addSubview(registerButton)
        addSubview(loginButton)
        //背景灰度图
        backgroundColor = UIColor(white: 237.0 / 255.0, alpha: 1.0)
        
        //1> 图标
        iconView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.snp.centerX)
            make.centerY.equalTo(self.snp.centerY).offset(-60)
        }
        //2> 小房子
        homeView.snp.makeConstraints { (make) in
            make.center.equalTo(iconView.snp.center)
        }
        //3> 消息文字
        messageLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(iconView.snp.centerX)
            make.top.equalTo(iconView.snp.bottom).offset(16)
            make.width.equalTo(224)
            make.height.equalTo(36)
        }
        //4> 注册按钮
        registerButton.snp.makeConstraints { (make) in
            make.left.equalTo(messageLabel.snp.left)
            make.size.equalTo(CGSize(width: 100, height: 36))
            make.top.equalTo(messageLabel.snp.bottom).offset(16)
        }
        //5> 登录按钮
        loginButton.snp.makeConstraints { (make) in
            make.right.equalTo(messageLabel.snp.right)
            make.top.width.height.equalTo(registerButton)
        }
        //6> 遮罩图形
        maskIconView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self)
            make.bottom.equalTo(registerButton.snp.bottom)
        }
        
        //添加监听方法
        registerButton.addTarget(self, action: #selector(VisitorView.clickRegister), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(VisitorView.clickLogin), for: .touchUpInside)
    }
}

extension VisitorView {
    
   
}









