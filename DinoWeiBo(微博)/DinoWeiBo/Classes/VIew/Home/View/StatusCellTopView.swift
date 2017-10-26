//
//  StatusCellTopView.swift
//  DinoWeiBo
//
//  Created by liu yao on 2017/2/20.
//  Copyright © 2017年 深圳多诺信息科技有限公司. All rights reserved.
//

import UIKit
import Kingfisher



/// 微博cell顶部视图
class StatusCellTopView: UIView {
    
    var viewModel: StatusViewModel? {
        didSet {
            //设置工作
            // 姓名
            nameLabel.text = viewModel?.status.user?.screen_name
            // 头像
            iconView.kf.setImage(with: viewModel?.userprofileUrl)
            // 会员图标
            memberIconView.image = viewModel?.memberImage
            // 认证图标
            vimIconView.image = viewModel?.userVipImage
            // 日期
            timeLabel.text = viewModel?.createAt
            // 来源
            sourcelabel.text = viewModel?.status.source
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 设置界面
    private func setupUI() {
        backgroundColor = UIColor.white
        // 添加分割视图
        let v = UIView()
        v.backgroundColor = UIColor.lightGray
        addSubview(v)
        
        addSubview(iconView)
        addSubview(nameLabel)
        addSubview(memberIconView)
        addSubview(vimIconView)
        addSubview(timeLabel)
        addSubview(sourcelabel)
        
        v.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.height.equalTo(StatusCellMargin)
        }
        iconView.snp.makeConstraints { (make) in
            make.top.equalTo(v.snp.bottom).offset(StatusCellMargin)
            make.left.equalTo(self.snp.left).offset(StatusCellMargin)
            make.size.equalTo(CGSize(width: StatusCellIconWidth, height: StatusCellIconWidth))
        }
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(iconView.snp.top)
            make.left.equalTo(iconView.snp.right).offset(StatusCellMargin)
        }
        memberIconView.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.top)
            make.left.equalTo(nameLabel.snp.right).offset(StatusCellMargin)
        }
        vimIconView.snp.makeConstraints { (make) in
            make.centerX.equalTo(iconView.snp.right)
            make.centerY.equalTo(iconView.snp.bottom)
        }
        timeLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(iconView.snp.bottom)
            make.left.equalTo(iconView.snp.right).offset(StatusCellMargin)
        }
        sourcelabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(iconView.snp.bottom)
            make.left.equalTo(timeLabel.snp.right).offset(StatusCellMargin)
        }
    }
    
    // MARK: - 懒加载控件
    
    /// 头像
    private lazy var iconView: UIImageView = UIImageView(imageName: "avatar_default")
    
    /// 姓名
    private lazy var nameLabel: UILabel = UILabel(title: "王老五", fontSize: 14)
    
    /// 等级标签
    private lazy var memberIconView: UIImageView = UIImageView(imageName: "common_icon_membership_level1")
    
    /// vip标签
    private lazy var vimIconView: UIImageView = UIImageView(imageName: "avatar_vip")
    
    /// 时间标签
    private lazy var timeLabel: UILabel = UILabel(title: "现在", fontSize: 11, color: UIColor.orange)
    
    /// 来源标签
    private lazy var sourcelabel: UILabel = UILabel(title: "来源", fontSize: 11)
    
}
