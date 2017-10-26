//
//  NewFeatureViewController.swift
//  DinoWeiBo
//
//  Created by liu yao on 2017/2/15.
//  Copyright © 2017年 深圳多诺信息科技有限公司. All rights reserved.
//

import UIKit

private let NewFeatureViewCellID = "Cell"
private let NewFuatureImageCount = 4


/// 新特性界面
class NewFeatureViewController: UICollectionViewController {
    
    
    /// 构造函数
    init() {
        //初始化指定的构造函数 
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = UIScreen.main.bounds.size
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        
        super.init(collectionViewLayout: layout)
        
        collectionView?.isPagingEnabled = true
        collectionView?.bounces = false
        collectionView?.showsHorizontalScrollIndicator = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView!.register(NewFeatureCell.self, forCellWithReuseIdentifier: NewFeatureViewCellID)

    }

    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return NewFuatureImageCount
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewFeatureViewCellID, for: indexPath) as! NewFeatureCell
        cell.imageIndex = indexPath.item
        return cell
    }
    //停止滚动 调用
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        if page != NewFuatureImageCount - 1 {
            return
        }
        let cell = collectionView?.cellForItem(at: IndexPath(item: page, section: 0)) as! NewFeatureCell
        cell.showButtonAnim()
    }
}


/// MARK: - 新特性 cell
private class NewFeatureCell: UICollectionViewCell {
    
    var imageIndex: Int = 0 {
        didSet {
            iconVIew.image = UIImage(named: "new_feature_\(imageIndex + 1)")
            startButton.isHidden = true
        }
    }
    
    @objc private func clickStartButton() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: DinoSwitchRootViewControllerNotification), object: nil)
    }
    
    func showButtonAnim() {
        startButton.isHidden = false
        startButton.transform = CGAffineTransform(scaleX: 0,y: 0)
        startButton.isUserInteractionEnabled = false
        UIView.animate(withDuration: 1.4,                   //动画时长
                       delay: 0,                          //延时时间
                       usingSpringWithDamping: 0.6,       // 弹力系数 ，0~1，越小越弹
                       initialSpringVelocity: 10,         // 初始速度，模拟重力加速度
                       options: [],                       //动画选项
                       animations: {
                        
            self.startButton.transform = CGAffineTransform.identity
                        
        }) { (_) in
            self.startButton.isUserInteractionEnabled = true
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
        addSubview(iconVIew)
        iconVIew.frame = bounds
        addSubview(startButton)
        startButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.snp.centerX)
            make.bottom.equalTo(self.snp.bottom).multipliedBy(0.9)
        }
        //添加监听方法
        startButton.addTarget(self, action: #selector(NewFeatureCell.clickStartButton), for: .touchUpInside)
    }
    
    //MARK : 懒加载控件
    
    /// 图像
    private lazy var iconVIew: UIImageView = UIImageView()
    
    /// 开始体验按钮
    private lazy var startButton: UIButton = UIButton(title: "开始体验", color: UIColor.white, backimageName: "new_feature_finish_button")
}
