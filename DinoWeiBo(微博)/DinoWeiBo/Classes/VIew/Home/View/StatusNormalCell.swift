//
//  StatusnormalCell.swift
//  DinoWeiBo
//
//  Created by liu yao on 2017/2/26.
//  Copyright © 2017年 深圳多诺信息科技有限公司. All rights reserved.
//

import UIKit


/// 原创微博
class StatusNormalCell: StatusCell {
    
    /// 微博视图模型
    override var viewModel: StatusViewModel? {
        didSet {
            // 配图视图应该有能力自己计算大小
            pictureView.snp.updateConstraints { (make) in
                //根据配图数量，设定配图视图的顶部间距
                guard let offset = viewModel?.thumbnailUrls?.count else {
                    make.top.equalTo(contentLabel.snp.bottom).offset(0)
                    return
                }
                make.top.equalTo(contentLabel.snp.bottom).offset(offset)
            }
        }
    }

    
    override func setupUI() {
        super.setupUI()
        // 3 > 配图视图
        pictureView.snp.makeConstraints { (make) in
            make.top.equalTo(contentLabel.snp.bottom).offset(StatusCellMargin)
            make.left.equalTo(contentLabel.snp.left)
            make.width.equalTo(300)
            make.height.equalTo(90)
            
        }
    }

}
