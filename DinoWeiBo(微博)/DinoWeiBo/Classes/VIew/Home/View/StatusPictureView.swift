//
//  StatusPictureView.swift
//  DinoWeiBo
//
//  Created by liu yao on 2017/2/23.
//  Copyright © 2017年 深圳多诺信息科技有限公司. All rights reserved.
//

import UIKit
import Kingfisher

private let StatusPictureViewItemMargin: CGFloat = 8

private let StatusPictureCellId = "StatusPictureCellId"


/// 微博图片视图
class StatusPictureView: UICollectionView {
    
    /// 微博视图模型
    var viewModel: StatusViewModel?{
        didSet {
            sizeToFit()
            
            // 刷新数据 .每次赋值模型在调用的话需要调用刷新数据
            reloadData()
        }
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return calcViewSize()
    }
    
    // MARK: - 构造函数
    init() {
        let layout = UICollectionViewFlowLayout()
        // 设置间距
        let margin = UIScreen.main.scale * 4
        layout.minimumLineSpacing = margin
        layout.minimumInteritemSpacing = margin
        
        super.init(frame: CGRect.zero, collectionViewLayout: layout)
        backgroundColor = UIColor(white: 0.8, alpha: 1.0)
        isScrollEnabled = false
        // 设置数据源
        // 应用场景： 自定义视图的小框架。 自己做自己的数据源
        dataSource = self
        delegate = self
        register(StatucPictureCell.self, forCellWithReuseIdentifier: StatusPictureCellId)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}


// MARK: - 数据源
extension StatusPictureView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.thumbnailUrls?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StatusPictureCellId, for: indexPath) as! StatucPictureCell
        cell.imageURL = viewModel?.thumbnailUrls![indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 传递数组和当前索引
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: DinoSelectedPhopoNotification), object: self, userInfo: [DinoSelectedPhotoIndexpathKey: indexPath,DinoSelectedPhotoURLKey:viewModel!.thumbnailUrls!])
    }
}


// MARK: - 图片查看器的展现协议
extension StatusPictureView: PhotoBrowserPresentDelegate {
    /// 创建一个imageView来参与动画
    func imageViewForPresent(indexPath: IndexPath)  -> UIImageView {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        if let url = viewModel?.thumbnailUrls?[indexPath.item] {
            iv.kf.setImage(with: url)
        }
        return iv
    }
    /// 动画转场的起始位置
    func photoBrowserPresentFormRect(indexPath: IndexPath) -> CGRect {
        let cell = self.cellForItem(at: indexPath)!
        
        // 获取屏幕的准确位置。不同坐标之间坐标转换。 self. 是cell的父视图
        // 由 collectionView 将 cell 的 frame 位置转换成 keyWindow的位置
        let rect = self.convert(cell.frame, to: UIApplication.shared.keyWindow)
        
        //测试代码 位置
//        let v = imageViewForPresent(indexPath: indexPath)
//        v.frame = rect
//        UIApplication.shared.keyWindow?.addSubview(v)
//        
        return rect
    }
    /// 动画转场的目标位置
    func photoBrowserPresentToRect(indexPath: IndexPath) -> CGRect {
        // 根据所旅途等比例计算大小
        guard let key = viewModel?.thumbnailUrls?[indexPath.item].absoluteString else {
            
            return CGRect.zero
        }
        guard let image = KingfisherManager.shared.cache.retrieveImageInDiskCache(forKey: key) else {
            return CGRect.zero
        }
        let w = UIScreen.main.bounds.width
        let h = image.size.height * w / image.size.width
        
        let screenHeight = UIScreen.main.bounds.height
        var y: CGFloat = 0
        if h < screenHeight {
            //图片，垂直居中
            y = (screenHeight - h) * 0.5
        }
        //测试代码 位置
        //        let v = imageViewForPresent(indexPath: indexPath)
        //        v.frame = CGRect(x: 0, y: y, width: w, height: h)
        //        UIApplication.shared.keyWindow?.addSubview(v)
        
        return CGRect(x: 0, y: y, width: w, height: h)
    }
}



// MARK: - 计算视图大小
extension StatusPictureView {
    
    /// 计算视图大小
    fileprivate func calcViewSize() -> CGSize {
        // 1. 准备
        
        let rowCount: CGFloat = 3
        let margin = UIScreen.main.scale * 4
        let maxWidth = UIScreen.main.bounds.width - 2 * StatusCellMargin
        let itemWidth = (maxWidth - 2 * margin) / rowCount
        
        // 2.设置layout的 ItmeSize的大小
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        let count = viewModel?.thumbnailUrls?.count ?? 0
        
        // 计算开始
        // 1 > 没有图片
        if count == 0 {
            return CGSize.zero
        }
        
        // 2 > 一张图片
        if count == 1 {
            var size = CGSize(width: 150, height: 120)
            if let key = viewModel?.thumbnailUrls?.first?.absoluteString {
                let image = KingfisherManager.shared.cache.retrieveImageInDiskCache(forKey: key)
                size = image?.size ?? CGSize(width: 150, height: 120)
            }
            // 过窄处理
            size.width = size.width < 40 ? 40 : size.width
            // 过宽处理
            if size.width > 300 {
                let w: CGFloat = 300
                let h = size.height * w / size.width
                size = CGSize(width: w, height: h)
            }
            
            layout.itemSize = size
            return size
        }
        
        // 3 > 四张图片 2 * 2的大小
        if count == 4 {
            let w = 2 * itemWidth + margin
            return CGSize(width: w, height: w)
        }
        
        // 4 > 其他图片 按照九宫格显示
        // 计算行数
        let row = CGFloat((count - 1) / Int(rowCount) + 1) // 2  3  5  6  7  8  9 张图片
        let h = row * itemWidth + (row - 1) * margin
        let w = rowCount * itemWidth + (rowCount - 1) * margin
        
        return CGSize(width: w, height: h)
    }
}

// MARK: - 微博配图cell
private class StatucPictureCell: UICollectionViewCell {
    var imageURL: URL? {
        didSet {
            iconView.kf.setImage(with: imageURL)
            let ext = ((imageURL?.absoluteString ?? "") as NSString).pathExtension
            gifIconView.isHidden = (ext != "gif")
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        // 添加控件
        contentView.addSubview(iconView)
        contentView.addSubview(gifIconView)
        
        //iconView.frame = bounds
        iconView.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView.snp.edges)
        }
        gifIconView.snp.makeConstraints { (make) in
            make.right.equalTo(iconView.snp.right)
            make.bottom.equalTo(iconView.snp.bottom)
        }
    }
    
    /// MARK: - 懒加载控件
    private lazy var iconView: UIImageView = {
       let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    private lazy var gifIconView: UIImageView = UIImageView(imageName: "timeline_image_gif")
}

