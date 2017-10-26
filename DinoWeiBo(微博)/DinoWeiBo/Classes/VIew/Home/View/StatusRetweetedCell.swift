//
//  StatusRetwweetedCell.swift
//  DinoWeiBo
//
//  Created by liu yao on 2017/2/25.
//  Copyright © 2017年 深圳多诺信息科技有限公司. All rights reserved.
//

import UIKit


/// 转发微博
class StatusRetweetedCell: StatusCell {
    
    /// 微博视图模型 .  属性的 override
    // 如果继承父类的属性 1. 需要 override  2. 不需要super   3. 先执行父类的didSet，在执行子类的didSet
    override var viewModel: StatusViewModel?{
        didSet {
            let text = viewModel?.retweetedText ?? ""
            retweetedLabel.attributedText = EmoticonManager.sharedManager.emoticonText(string: text, font: retweetedLabel.font)

            
            pictureView.snp.updateConstraints { (make) in
                //根据配图数量，设定配图视图的顶部间距
                guard let offset = viewModel?.thumbnailUrls?.count else {
                    make.top.equalTo(retweetedLabel.snp.bottom).offset(0)
                    return
                }
                make.top.equalTo(retweetedLabel.snp.bottom).offset(offset)
            }
        }
    }
    
    // MARK: - 懒加载控件
    
    /// 背景按钮
    private lazy var backButton: UIButton = {
       let btn = UIButton()
        btn.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        return btn
    }()
    private lazy var retweetedLabel: FFLabel = FFLabel(title: "转发微博",
                                                       fontSize: 14,
                                                       color: UIColor.darkGray,
                                                       screenInset: StatusCellMargin)
        
    override func setupUI() {
        super.setupUI()
        
        //1.添加控件
        contentView.insertSubview(backButton, belowSubview: pictureView)
        contentView.insertSubview(retweetedLabel, aboveSubview: backButton)
        
        // 2.自动布局
        // 1>背景按钮
        backButton.snp.makeConstraints { (make) in
            make.top.equalTo(contentLabel.snp.bottom).offset(StatusCellMargin)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(bottonView.snp.top)
        }
        //2>转发标签
        retweetedLabel.snp.makeConstraints { (make) in
            make.top.equalTo(backButton.snp.top).offset(StatusCellMargin)
            make.left.equalTo(backButton.snp.left).offset(StatusCellMargin)
        }
        // 3 > 配图视图
        pictureView.snp.makeConstraints { (make) in
            make.top.equalTo(retweetedLabel.snp.bottom).offset(StatusCellMargin)
            make.left.equalTo(retweetedLabel.snp.left)
            make.width.equalTo(300)
            make.height.equalTo(90)
            
        }
        retweetedLabel.delegate = self
    }
}

