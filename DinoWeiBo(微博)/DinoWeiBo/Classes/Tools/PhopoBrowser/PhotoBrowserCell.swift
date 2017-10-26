//
//  PhotoBrowserCell.swift
//  DinoWeiBo
//
//  Created by liu yao on 2017/3/12.
//  Copyright © 2017年 深圳多诺信息科技有限公司. All rights reserved.
//

import UIKit
import Kingfisher
import SVProgressHUD

protocol  PhotoBrowserCellDelegate: NSObjectProtocol{
    
    func photoBrowserCellShouldDismiss()
    
    
    /// 通知代理缩放的比例
    ///
    /// - Parameter scale: 缩放比例
    func photoBrowserCellDidZoom(scale: CGFloat)
}

/// 照片查看cell
class PhotoBrowserCell: UICollectionViewCell {
    
    weak var photoDelegate: PhotoBrowserCellDelegate?
    
    // MARK: - 监听方法
    @objc private func tapImage() {
        photoDelegate?.photoBrowserCellShouldDismiss()
    }
    
    
    /// 图像地址
    var imageURL: URL? {
        didSet {
            guard let url = imageURL else {
                return
            }
            resetScrollView()
            // 1 > 下载的时候显示缩略图
            let placeholderImage = KingfisherManager.shared.cache.retrieveImageInDiskCache(forKey: url.absoluteString)
            
            setPlaceHolder(image: placeholderImage)
            
            // 2 > 成功之后显示下载大图 。 
            // 清除之后的图片/如果之前的图片也是一部下载，但是没有完成，取消之前的异步操作
            imageView.kf.setImage(with: bmiddleURL(url: url), placeholder: nil, options: nil, progressBlock: { (current, total) in

                self.placeHolder.progress = CGFloat(current) / CGFloat(total)
                
            }) { (image, _, _, _) in
                guard let dowmImg = image else {
                    SVProgressHUD.showInfo(withStatus: "您的网络不给力!")
                    return
                }
                self.placeHolder.isHidden = true
                self.setPosition(image: dowmImg)
            }
        }
    }
    
    /// 设置占位图像的视图内容
    private func setPlaceHolder(image: UIImage?) {
        placeHolder.isHidden = false
        placeHolder.image = image
        placeHolder.sizeToFit()
        placeHolder.center = scrollView.center
    }
    
    /// 重设 scrollview 内容属性。不然小图第三张的contentSize会更改
    private func resetScrollView() {
        // 重设 imageVIew 的内容属性
        imageView.transform = CGAffineTransform.identity
        
        scrollView.contentInset = UIEdgeInsets.zero
        scrollView.contentOffset = CGPoint.zero
        scrollView.contentSize = CGSize.zero
    }
    
    /// 设置 imageView 的位置
    private func setPosition(image: UIImage) {
        // 自动设置大小
        let size = self.displaySize(image: image)
        // contentInset -> 缩放完成之后的居中
        // contentSize -> 觉得 scrollView 的滚动范围
        // contetnOffset -> 觉得scrollView的偏移位置
        // 判断图片高度
        if size.height < scrollView.bounds.height {
            let y = (scrollView.bounds.height - size.height) * 0.5
            // 调整 frame 的x/y 一旦缩放，影响滚动范围 y不能设为y
            imageView.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            
            // 内容边距 - 会跳转控件位置，但是不会影响控件的滚动
            scrollView.contentInset = UIEdgeInsetsMake(y, 0, 0, 0)
        }else {
            self.imageView.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            scrollView.contentSize = size
        }

    }
    
    /// 返回中等尺寸的URL
    ///
    /// - Parameter url: 缩略图URL
    /// - Returns: 中等尺寸URL
    private func bmiddleURL(url: URL) -> URL {
        let urlString = url.absoluteString
        let bmiddleStr = urlString.replacingOccurrences(of: "/thumbnail/", with: "/bmiddle/")
        return URL(string: bmiddleStr)!
    }
    
    /// 根据 scrollView 的宽度计算等比例缩放之后的图片尺寸
    ///
    /// - Parameter image: image
    /// - Returns: 缩放之后的尺寸
    private func displaySize(image: UIImage) -> CGSize {
        let w = scrollView.bounds.width
        let h = image.size.height * w / image.size.width
        
        return CGSize(width: w, height: h)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(placeHolder)
        
        var rect = bounds
        rect.size.width -= 20
        scrollView.frame = rect
        
        // 设置 scrollView 缩放
        scrollView.delegate = self
        scrollView.minimumZoomScale = 0.5
        scrollView.maximumZoomScale = 2.0
        
        //添加手势
        let tap = UITapGestureRecognizer(target: self, action: #selector(PhotoBrowserCell.tapImage))
        imageView.addGestureRecognizer(tap)
        imageView.isUserInteractionEnabled = true
    }
    
    // MARK: - 懒加载控件
    lazy var scrollView: UIScrollView = UIScrollView()
    lazy var imageView: UIImageView = UIImageView()
    fileprivate lazy var placeHolder: ProgressImageVIew = ProgressImageVIew()
}

extension PhotoBrowserCell: UIScrollViewDelegate {
    // 返回被缩放的视图
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    /// 缩放完成被调用
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        // 如果缩放比例 < 1 ，直接关闭
        if scale < 1 {
            photoDelegate?.photoBrowserCellShouldDismiss()
            return
        }
        // 缩放完成后设置居中
        var offsetY = (scrollView.bounds.height - view!.frame.height) * 0.5
        offsetY = offsetY < 0 ? 0 : offsetY // 小于0 的时候有部分看不到
        
        var offsetX = (scrollView.bounds.width - view!.frame.width) * 0.5
        offsetX = offsetX < 0 ? 0 : offsetX // 小于0 的时候有部分看不到
        // 设置间距
        scrollView.contentInset = UIEdgeInsetsMake(offsetY, 0, offsetX, 0)
    }
    
    /// 只要缩放就会调用
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        /*
         a d => 缩放比例
         a b c d => 共同决定旋转
         tx ty => 设置位移
         定义控件位置
         */
        photoDelegate?.photoBrowserCellDidZoom(scale: imageView.transform.a)
    }
}
