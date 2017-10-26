//
//  StatusCellBottomView.swift
//  DinoWeiBo
//
//  Created by liu yao on 2017/2/20.
//  Copyright © 2017年 深圳多诺信息科技有限公司. All rights reserved.
//

import UIKit


/// 微博cell底部视图
class StatusCellBottomView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 懒加载控件
    /// 转发按钮
    private lazy var retweetedButton = UIButton(title: " 转发", fontSize: 12, color: UIColor.darkGray, imageName: "timeline_icon_retweet", backColor:nil)
    /// 评论按钮
    private lazy var commentButton = UIButton(title: " 评论", fontSize: 12, color: UIColor.darkGray, imageName: "timeline_icon_comment", backColor:nil)
    
    /// 点赞按钮
    private lazy var likeButton = UIButton(title: " 赞", fontSize: 12, color: UIColor.darkGray, imageName: "timeline_icon_unlike", backColor:nil)
    
    // MARK: - 设置界面
    private func setupUI() {
        // 0.设置背景颜色
        backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        
        // 1.添加控件
        addSubview(retweetedButton)
        addSubview(commentButton)
        addSubview(likeButton)
        
        //2.布局
        retweetedButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top)
            make.left.equalTo(self.snp.left)
            make.bottom.equalTo(self.snp.bottom)
        }
        commentButton.snp.makeConstraints { (make) in
            make.top.equalTo(retweetedButton.snp.top)
            make.left.equalTo(retweetedButton.snp.right)
            make.height.equalTo(retweetedButton.snp.height)
            make.width.equalTo(retweetedButton.snp.width)
        }
        likeButton.snp.makeConstraints { (make) in
            make.top.equalTo(commentButton.snp.top)
            make.left.equalTo(commentButton.snp.right)
            make.right.equalTo(self.snp.right)
            make.height.equalTo(commentButton.snp.height)
            make.width.equalTo(commentButton.snp.width)
        }
        
        //3.分割视图
        let sep1 = sepView()
        let sep2 = sepView()
        addSubview(sep1)
        addSubview(sep2)
        let w = 0.5
        let scale = 0.4
        sep1.snp.makeConstraints { (make) in
            make.left.equalTo(retweetedButton.snp.right)
            make.centerY.equalTo(retweetedButton)
            make.width.equalTo(w)
            make.height.equalTo(retweetedButton.snp.height).multipliedBy(scale)
        }
        sep2.snp.makeConstraints { (make) in
            make.left.equalTo(commentButton.snp.right)
            make.centerY.equalTo(retweetedButton)
            make.width.equalTo(w)
            make.height.equalTo(retweetedButton.snp.height).multipliedBy(scale)
        }
    }
    
    // 这里不建议用计算属性
    private func sepView() -> UIView {
        let v = UIView()
        v.backgroundColor = UIColor.darkGray
        
        
        return v
    }
    
}
