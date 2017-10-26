//
//  PhotoBrowserViewController.swift
//  DinoWeiBo
//
//  Created by liu yao on 2017/3/12.
//  Copyright © 2017年 深圳多诺信息科技有限公司. All rights reserved.
//

import UIKit
import SVProgressHUD

private let PhotoBrowserCellId = "PhotoBrowserCellId"

class PhotoBrowserViewController: UIViewController {
    
    fileprivate var urls: [URL]
    fileprivate var currentIndexPath: IndexPath
    
    // MARK: - 监听方法
    @objc fileprivate func close() {
        dismiss(animated: true, completion: nil)
    }
    @objc fileprivate func save() {
        let cell = collectionView.visibleCells[0] as! PhotoBrowserCell
        guard let image = cell.imageView.image else {
            return
        }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(PhotoBrowserViewController.image(image:didFinishSavingWithError:contextInfo:)), nil)
    }
    //- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
    // 监听的OC方法，注意这里需要将OC方法转换成Swift方法
    func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: Any?) {
        let message = (error == nil) ? "保存成功" : "保存失败"
        SVProgressHUD.showInfo(withStatus: message)
    }
    
    init(urls: [URL], indexPath: IndexPath) {
        self.urls = urls
        self.currentIndexPath = indexPath
        super.init(nibName: nil, bundle: nil)
    }
    // 和 xib &sb 等价的，主要创建视图层次结构，loadView执行完毕，view上的元素要全部创建完毕。如果view = nil 自动创建view
    override func loadView() {
        var rect = UIScreen.main.bounds
        rect.size.width += 20
        view = UIView(frame: rect)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // loadView执行完毕之后执行，主要做数据加载或者其他处理。目前市场上很多程序子控件代码都在这里。
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.scrollToItem(at: currentIndexPath, at: .centeredHorizontally, animated: false)
    }
    
    // MARK: - 懒加载控件
    lazy var collectionView: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: PhotoBrowserViewLayout())
    fileprivate lazy var closeButton: UIButton = UIButton(title: "关闭", fontSize: 14, color: UIColor.white, imageName: nil, backColor: UIColor.darkGray)
    fileprivate lazy var saveButton: UIButton = UIButton(title: "保存", fontSize: 14, color: UIColor.white, imageName: nil, backColor: UIColor.darkGray)
    
    // MARK: - 自定义流水布局
    private class PhotoBrowserViewLayout: UICollectionViewFlowLayout {
         override func prepare() {
            super.prepare()
            itemSize = collectionView!.bounds.size
            minimumLineSpacing = 0
            minimumInteritemSpacing = 0
            scrollDirection = .horizontal
            
            collectionView?.isPagingEnabled = true
            collectionView?.bounces = false
            collectionView?.showsHorizontalScrollIndicator = false
        }
    }

}


// MARK: - 设置UI
fileprivate extension PhotoBrowserViewController {
    func setupUI() {
        // 1 > 添加控制器
        view.addSubview(collectionView)
        view.addSubview(closeButton)
        view.addSubview(saveButton)
        
        // 2 > 布局
        collectionView.frame = view.bounds
        closeButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(-8)
            make.left.equalTo(8)
            make.size.equalTo(CGSize(width: 100, height: 36))
        }
        saveButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(-8)
            make.right.equalTo(-28)
            make.size.equalTo(CGSize(width: 100, height: 36))
        }
        // 3 > 监听方法
        closeButton.addTarget(self, action: #selector(PhotoBrowserViewController.close), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(PhotoBrowserViewController.save), for: .touchUpInside)
        
        prepareCollectionView()
    }
    
    func prepareCollectionView() {
        collectionView.register(PhotoBrowserCell.self, forCellWithReuseIdentifier: PhotoBrowserCellId)
        collectionView.dataSource = self
    }
}

// MARK: - UICollectionViewDataSource
extension PhotoBrowserViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return urls.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoBrowserCellId, for: indexPath) as! PhotoBrowserCell
        cell.imageURL = urls[indexPath.item]
        cell.photoDelegate = self
        return cell
    }
}


// MARK: - PhotoBrowserCellDelegate
extension PhotoBrowserViewController: PhotoBrowserCellDelegate {
    func photoBrowserCellShouldDismiss() {
        close()
    }
    
    func photoBrowserCellDidZoom(scale: CGFloat) {
        let isHidden = (scale < 1)
        hideControls(isHidden: isHidden)
        
        if scale < 1 {
            // 1、修改根视图的透明度 缩放比例
            view.alpha = scale
            view.transform = CGAffineTransform(scaleX: scale, y: scale);
        }else {
            view.alpha = 1.0
            view.transform = CGAffineTransform.identity
        }
        
        
    }
    
    private func hideControls(isHidden: Bool) {
        closeButton.isHidden = isHidden
        saveButton.isHidden = isHidden
        collectionView.backgroundColor = isHidden ? UIColor.clear : UIColor.black
    }
}

// MARK: - PhotoBrowserDismissDelegate
extension PhotoBrowserViewController: PhotoBrowserDismissDelegate {
    func imageViewForDismiss() -> UIImageView {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        let cell = collectionView.visibleCells[0] as! PhotoBrowserCell
        iv.image = cell.imageView.image
        
        // 设置位置 - 坐标转换（由父视图进行转换）
        iv.frame = cell.scrollView.convert(cell.imageView.frame, to: UIApplication.shared.keyWindow)
        
        return iv
    }
    
    func indexPathForDismiss() -> IndexPath {
        let indexPaths = collectionView.indexPathsForVisibleItems
        return indexPaths[0]
    }
}
