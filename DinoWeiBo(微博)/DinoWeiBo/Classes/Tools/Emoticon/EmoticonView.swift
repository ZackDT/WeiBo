//
//  EmoticonView.swift
//  表情键盘
//
//  Created by liu yao on 2017/3/1.
//  Copyright © 2017年 深圳多诺信息科技有限公司. All rights reserved.
//

import UIKit
import SnapKit

private let EmoticonViewCellId = "EmoticonViewCellId"

class EmoticonView: UIView {
    
    /// 选中表情的回调
    fileprivate var selectedEmoticonCallBack: (_ emoticon: Emoticon)->()
    
    // MARK: - 监听方法
    @objc private func clickItem(item: UIBarButtonItem) {
       let indexPath = IndexPath(item: 0, section: item.tag)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
    }
    
    // MARK: - 构造函数
    init(selectedEmoticon: @escaping (_ emoticon: Emoticon)->()) {
        selectedEmoticonCallBack = selectedEmoticon
        var rect = UIScreen.main.bounds
        rect.size.height = 226
        super.init(frame: rect)
        
        backgroundColor = UIColor.white
        
        setupUI()
        //滚动到第一页
        let indexPath = IndexPath(item: 0, section: 1)
        DispatchQueue.main.async {
            // 主队列：在主线程中任务都跑完的时候，才会调用这里的方法。
            self.collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 懒加载
    private lazy var collectionView: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: EmoticonLayout())
    private lazy var toolBar = UIToolbar()
    
    func setupUI() {
    /// 设置界面
    addSubview(toolBar)
    addSubview(collectionView)
    
    //自动布局
    toolBar.snp.makeConstraints { (make) in
        make.bottom.equalTo(self.snp.bottom)
        make.left.equalTo(self.snp.left)
        make.right.equalTo(self.snp.right)
        make.height.equalTo(44)
    }
    collectionView.snp.makeConstraints { (make) in
        make.top.equalTo(self.snp.top)
        make.bottom.equalTo(toolBar.snp.top)
        make.left.equalTo(self.snp.left)
        make.right.equalTo(self.snp.right)
    }
    
    prepareToolBar()
    prepareCollectionView()
    
}
    
    /// 准备工具栏
    private func prepareToolBar() {
        
        toolBar.tintColor = UIColor.darkGray
        
        var items = [UIBarButtonItem]()
        var index = 0
        for p in packages {
            items.append(UIBarButtonItem(title: p.group_name_cn, style: .plain, target: self, action: #selector(EmoticonView.clickItem(item:))))
            items.last?.tag = index
            index += 1
            items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        }
        items.removeLast()
        toolBar.items = items
    }
    
    /// 准备collectionView
    private func prepareCollectionView() {
        collectionView.backgroundColor = UIColor.white
        
        collectionView.register(EmoticonViewCell.self, forCellWithReuseIdentifier: EmoticonViewCellId)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    fileprivate lazy var packages = EmoticonManager.sharedManager.packages
    
    private class EmoticonLayout: UICollectionViewFlowLayout {
        
        /// 第一次布局的自动调用一次 尺寸：216 - 36
        override func prepare() {
            super.prepare()
            let col: CGFloat = 7
            let row: CGFloat = 3
            
            let w = collectionView!.bounds.width / col
            let margin = (collectionView!.bounds.height - row * w) * 0.5
            
            itemSize = CGSize(width: w, height: w)
            minimumLineSpacing = 0
            minimumInteritemSpacing = 0
            sectionInset = UIEdgeInsets(top: margin, left: 0, bottom: margin, right: 0)
            scrollDirection = .horizontal
            collectionView?.isPagingEnabled = true
            collectionView?.bounces = false
            collectionView?.showsHorizontalScrollIndicator = false
        }
    }
    
}

// MARK: - UICollectionViewDataSource协议
extension EmoticonView: UICollectionViewDataSource,UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return packages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return packages[section].emoticons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmoticonViewCellId, for: indexPath) as! EmoticonViewCell
        cell.emoticon = packages[indexPath.section].emoticons[indexPath.item]
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let em = packages[indexPath.section].emoticons[indexPath.item]
        if indexPath.section > 0 {
            // 第0个分组不参加计算
             EmoticonManager.sharedManager.addFavorite(em: em)
        }
       
        // 执行回调
        selectedEmoticonCallBack(em)
    }
}


// MARK: - 表情视图cell
private class EmoticonViewCell: UICollectionViewCell {
    
    var emoticon: Emoticon? {
        didSet {
            emoticonButton.setImage(UIImage(contentsOfFile: emoticon!.imagePath!), for: .normal)
            
            emoticonButton.setTitle(emoticon?.emoji, for: .normal)
            // 注意这里不能用nil进行判断，因为会出现复用问题
            if emoticon?.emoji == nil { }
            if emoticon!.isRemoved {
                emoticonButton.setImage(UIImage(named: "compose_emotion_delete"), for: .normal)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(emoticonButton)
        emoticonButton.backgroundColor = UIColor.white
        emoticonButton.setTitleColor(UIColor.darkGray, for: .normal)
        emoticonButton.frame = bounds.insetBy(dx: 4, dy: 4)
        emoticonButton.titleLabel?.font = UIFont.systemFont(ofSize: 32)
        emoticonButton.isUserInteractionEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var emoticonButton: UIButton = UIButton()
    
}
