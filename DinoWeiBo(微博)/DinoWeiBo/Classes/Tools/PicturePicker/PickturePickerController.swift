//
//  PickturePickerControllerCollectionViewController.swift
//  003@照片选择
//
//  Created by liu yao on 2017/3/8.
//  Copyright © 2017年 深圳多诺信息科技有限公司. All rights reserved.
//

import UIKit

private let PicturePickerCellId = "Cell"

private let PicturePickerMaxCount = 8

/// 图片选择控制器
class PickturePickerController: UICollectionViewController {
    
    /// 配图数组
    lazy var pictures = [UIImage]()
    
    fileprivate var selectIndex = 0
    
    // MARK: - 构造函数
    init() {
        super.init(collectionViewLayout: PicturePickerLayout())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // collectionViewController 中的 collectionView != view
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = UIColor(white: 0.9, alpha: 1.0)

        self.collectionView!.register(PicturePickerCell.self, forCellWithReuseIdentifier: PicturePickerCellId)
    }
    
    // MARK: - 图片选择器布局
    private class PicturePickerLayout: UICollectionViewFlowLayout {
        override func prepare() {
            super.prepare()
            // iPhone 6s- 2   iPhone 6s+ 3
            let count: CGFloat = 4
            let margin = UIScreen.main.scale * 4
            let w = (collectionView!.bounds.width - margin * (count + 1)) / count // 不建议过分依赖UIScreen做布局
            itemSize = CGSize(width: w, height: w)
            //设置距离左边，上边和有变得距离
            sectionInset = UIEdgeInsetsMake(margin, margin, 0, margin)
            minimumLineSpacing = margin // 行间距
            minimumInteritemSpacing = margin // 小格子间距
        }

    }

}

// MARK: UICollectionViewDataSource
extension PickturePickerController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 达到上限不显示加好按钮
        return pictures.count + (pictures.count == PicturePickerMaxCount ? 0 : 1)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PicturePickerCellId, for: indexPath) as! PicturePickerCell
        cell.pictureDelegae = self
        cell.image = (indexPath.item < pictures.count) ? pictures[indexPath.item] : nil
        return cell
    }
}
// MARK: PicturePickerCellDelegate
extension PickturePickerController: PicturePickerCellDelegate {
    fileprivate func picturePickerCellDidAdd(cell: PicturePickerCell) {
        // 1 > 判断是否允许访问相册
        if !UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            QL4("无法访问图片库")
            return
        }
        
        // 记录当前用户选择的索引
        selectIndex = collectionView?.indexPath(for: cell)!.item ?? 0
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    fileprivate func picturePickerCellDidRemove(cell: PicturePickerCell) {
        let indexPath = collectionView!.indexPath(for: cell)!
        //删除数组
        if indexPath.item >= pictures.count {
            return
        }
        
        pictures.remove(at: indexPath.item)
        // deleteItems后Section里面的rows数量，和系统调用numberOfRowsInSection时rows数量不一致
        //collectionView?.deleteItems(at: [indexPath])  //这个方法选择满了之后崩溃
        self.collectionView?.reloadData()
        
        
    }
}

extension PickturePickerController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    /// 图片选择完成
    ///
    /// - Parameters:
    ///   - picker: 图片选择器
    ///   - info: info 字典
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        print(info)
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        let scaleImage = image.scaleToWidth(width: 600)
        // 判断选择索引是否超出数组上限
        if selectIndex >= pictures.count {
            pictures.append(scaleImage)
        }else {
            pictures[selectIndex] = scaleImage
        }
        collectionView?.reloadData()
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

/// PicturePickerCellDelegate 代理
@objc fileprivate protocol PicturePickerCellDelegate: NSObjectProtocol {
    @objc optional func picturePickerCellDidAdd(cell: PicturePickerCell)
    @objc optional func picturePickerCellDidRemove(cell: PicturePickerCell)
}


// MARK: - 图片选择cell
fileprivate class PicturePickerCell: UICollectionViewCell {
    
    weak var pictureDelegae: PicturePickerCellDelegate?
    
    var image: UIImage? {
        didSet {
            addButton.setImage(image ?? UIImage(named: "compose_pic_add"), for: .normal)
            removeButton.isHidden = (image == nil)
        }
    }
    
    // MARK: - 监听方法
    func addPicture() {
        pictureDelegae?.picturePickerCellDidAdd?(cell: self)
    }
    func removePicture() {
        pictureDelegae?.picturePickerCellDidRemove?(cell: self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(addButton)
        contentView.addSubview(removeButton)
        
        addButton.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0))
        }
        removeButton.snp.makeConstraints { (make) in
            make.right.top.equalTo(0)
        }
        
        addButton.addTarget(self, action: #selector(PicturePickerCell.addPicture), for: .touchUpInside)
        removeButton.addTarget(self, action: #selector(PicturePickerCell.removePicture), for: .touchUpInside)
        addButton.imageView?.contentMode = .scaleAspectFill // 设置填充模式
    }
    
    // MARK: - 懒加载控件
    /// 添加按钮
    private lazy var addButton: UIButton = UIButton(imageName: "compose_pic_add", backImageName: nil)
    
    /// 删除按钮
    private lazy var removeButton: UIButton = UIButton(imageName: "compose_photo_close", backImageName: nil)
}


