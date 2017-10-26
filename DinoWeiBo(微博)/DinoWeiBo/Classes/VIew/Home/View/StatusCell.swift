//
//  StatusCell.swift
//  DinoWeiBo
//
//  Created by liu yao on 2017/2/20.
//  Copyright © 2017年 深圳多诺信息科技有限公司. All rights reserved.
//

import UIKit

/// 微博cell 中控件的间距数值
let StatusCellMargin: CGFloat = 12
/// 微博头像的宽度
let StatusCellIconWidth: CGFloat = 35


protocol StatusCellDelegate: NSObjectProtocol {
    // 微博 cell 点击 URL
    func statusCellDidClick(url: URL)
}

/// 微博Cell
class StatusCell: UITableViewCell {
    
    /// cell 的代理
    weak var cellDelegate: StatusCellDelegate?
    
    /// 微博视图模型
    var viewModel: StatusViewModel? {
        didSet {
            //设置工作
            topView.viewModel = viewModel
            
            let text = viewModel?.status.text ?? ""
            contentLabel.attributedText = EmoticonManager.sharedManager.emoticonText(string: text, font: contentLabel.font)
            
            // FIXME: 动态修改约束高度，cell复用问题会导致行高计算有误。不使用自动计算高度，就可以动态修改高度
            pictureView.viewModel = viewModel
            // 配图视图应该有能力自己计算大小
            pictureView.snp.updateConstraints { (make) in
                make.height.equalTo(pictureView.bounds.height)
                make.width.equalTo(pictureView.bounds.width)
                
                //根据配图数量，设定配图视图的顶部间距
//                guard let offset = viewModel?.thumbnailUrls?.count else {
//                    make.top.equalTo(contentLabel.snp.bottom).offset(0)
//                    return
//                }
//                make.top.equalTo(contentLabel.snp.bottom).offset(offset)
            }
        }
    }
    
    /// 根据指定的视图模型 计算行高
    ///
    /// - Parameter vm: 视图模型
    /// - Returns: 返回行高
    func rowHeght(vm: StatusViewModel) -> CGFloat {
        // 1. 记录视图模型 -> 会调用上面的 didSet 设置内容，更新约束
        viewModel = vm
        // 2. 强制更新所有约束
        contentView.layoutIfNeeded()
        // 3.放回底部视图的最大高度
        return bottonView.frame.maxY
    }
    
    
    // MARK: - 构造函数
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        
        selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - 懒加载控件
    
    /// 顶部视图
    private lazy var topView: StatusCellTopView = StatusCellTopView()
    
    // 注意UILabel换行的时候一定要设定preferredMaxLayoutWidth属性，要不然行高经常出问题
    
    /// 微博标签正文
    lazy var contentLabel: FFLabel = FFLabel(title: "微博正文", fontSize: 15, color: UIColor.darkGray, screenInset: StatusCellMargin)
    
    /// 配图视图
     lazy var pictureView: StatusPictureView = StatusPictureView()
    
    /// 底部视图
    lazy var bottonView: StatusCellBottomView = StatusCellBottomView()
    
    func setupUI() {
        //设置UI
        contentView.addSubview(topView)
        contentView.addSubview(contentLabel)
        contentView.addSubview(pictureView)
        contentView.addSubview(bottonView)
        
        
        //布局
        // 1 > 顶部视图
        topView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.height.equalTo(StatusCellIconWidth + StatusCellMargin  * 2)
        }
        //2 > 内容标签
        contentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(topView.snp.bottom).offset(StatusCellMargin)
            make.left.equalTo(StatusCellMargin)
        }
        
        //4 > 底部视图
        bottonView.snp.makeConstraints { (make) in
            make.top.equalTo(pictureView.snp.bottom).offset(StatusCellMargin)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(44)
        }
        
        contentLabel.delegate = self
    }
    
}

extension StatusCell: FFLabelDelegate {
    func labelDidSelectedLinkText(label: FFLabel, text: String) {
        QL2(text)
        // 判断text是否是URL
        if text.hasPrefix("http://") {
            guard let url = URL(string: text) else {
                return
            }
            cellDelegate?.statusCellDidClick(url: url)
        }
    }
}
