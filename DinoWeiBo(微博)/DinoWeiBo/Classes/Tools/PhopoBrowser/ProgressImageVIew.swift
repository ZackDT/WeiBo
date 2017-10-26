//
//  ProgressImageVIew.swift
//  DinoWeiBo
//
//  Created by liu yao on 2017/3/14.
//  Copyright © 2017年 深圳多诺信息科技有限公司. All rights reserved.
//

import UIKit


/// 带进度的图片视图
class ProgressImageVIew: UIImageView {
    
    /// 外部传递的进度值
    var progress: CGFloat = 0 {
        didSet {
            progressView.progress = progress
        }
    }
    
    // MARK: - 构造函数
    init() {
        super.init(frame: CGRect.zero)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        // 设置布局
        addSubview(progressView)
        // 设置透明，让progressView只剩绘制的白色视图部分
        progressView.backgroundColor = UIColor.clear
        progressView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.snp.edges)
        }
    }
    
    // MARK: - 懒加载控件
    private lazy var progressView: PregressView = PregressView()

}

fileprivate class PregressView: UIView {
    
    /// 内部使用的进度值 0~1
    var progress: CGFloat = 0 {
        didSet {
            // 重绘视图
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        let center = CGPoint(x: rect.width * 0.5, y: rect.height * 0.5)
        let r = min(rect.width, rect.height) * 0.5
        let start = CGFloat(-M_PI_2)
        let end = start + progress * 2 * CGFloat(M_PI)
        let path = UIBezierPath(arcCenter: center, radius: r, startAngle: start, endAngle: end, clockwise: true)
        // 添加到中心的的线
        path.addLine(to: center)
        path.close()
        UIColor(white: 1.0, alpha: 0.3).setFill()
        path.fill()
    }
}
