//
//  ComposeViewController.swift
//  DinoWeiBo
//
//  Created by liu yao on 2017/3/6.
//  Copyright © 2017年 深圳多诺信息科技有限公司. All rights reserved.
//

import UIKit
import SVProgressHUD

class ComposeViewController: UIViewController {
    
    fileprivate lazy var picturePickerControler = PickturePickerController()
    
    /// 表情键盘
    fileprivate lazy var emoticonView: EmoticonView = EmoticonView { [weak self](emoticon) -> () in
        self!.textView.inesetEmoticon(em: emoticon)
    }
    
    // MARK: - 监听方法
    /// 关闭控制器
    @objc fileprivate func close() {
        textView.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }
    
    /// 发布微博
    @objc fileprivate func sendStatus() {
        let text = textView.emoticonText
        let image = picturePickerControler.pictures.last
        AFNetworkTools.sharedTools.sendStatus(status: text, image: image) { (result, error) in
            if error != nil {
                QL4("出错了")
                SVProgressHUD.showInfo(withStatus: "您的网络不给力")
                return
            }
            self.close()
        }
    }
    
    /// 工具栏点击
    @objc fileprivate func itemClick(btn: UIButton) {
        let tag = btn.tag
        switch tag {
        case 100:
            pitcurePickerClick()
            break
        case 103:
            // 表情键盘
            emoticonClick()
            break
        default:
            break
        }
    }
    
    // MARK: - 键盘处理
    @objc private func keyboardChanged(n: Notification) {
//        print(n)
        // 获取键盘最终Y值 不能转成NSRect
        // 计算工具栏距离底部的间距  guard守护
        guard let endFrame = (n.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let duration = (n.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ,
            let curve = (n.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber)?.intValue else {
            return
        }
        let margin = kScreenH - endFrame.origin.y
        toolBar.snp.updateConstraints { (make) in
            make.bottom.equalTo(view.snp.bottom).offset(-margin)
        }
        
        //动画  需要设置动画属性防止跳动
        UIView.animate(withDuration: duration) {
            //设置动画曲线  曲线值 == 7 设置之后动画时长无效，变成0.5s
            UIView.setAnimationCurve(UIViewAnimationCurve(rawValue: curve)!)
            self.view.layoutIfNeeded()
        }
    }
    
    
    override func loadView() {
        view = UIView()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 如果存在图片控制器，不激活
        if picturePickerControler.view.frame.height == 0 {
            textView.becomeFirstResponder()
        }
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        //关闭键盘
        textView.resignFirstResponder()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(ComposeViewController.keyboardChanged(n:)), name: .UIKeyboardWillChangeFrame, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - 懒加载
    fileprivate lazy var toolBar = UIToolbar()
    fileprivate lazy var textView: UITextView = {
       let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 18)
        tv.textColor = UIColor.darkGray
        // 始终允许垂直滚动
        tv.alwaysBounceVertical = true
        tv.keyboardDismissMode = .onDrag // 拖拽关闭键盘
        tv.delegate = self
        return tv
    }()
    fileprivate lazy var placeHolderLabel: UILabel = UILabel(title: "分享新鲜事...", fontSize: 18, color: UIColor.lightGray)
}

extension ComposeViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        navigationItem.rightBarButtonItem?.isEnabled = true
        placeHolderLabel.isHidden = textView.hasText
    }
}


// MARK: - 工具栏点击事件
fileprivate extension ComposeViewController {
    /// 表情键盘
    func emoticonClick() {
        // 注意如果使用的是系统键盘 nil
        //退掉键盘
        textView.inputView = textView.inputView == nil ? emoticonView : nil
        //刷新键盘
        textView.reloadInputViews()
    }
    
    /// 选择图片
    func pitcurePickerClick() {
        
        // 如果已经更新，不执行后续代码
        if picturePickerControler.view.frame.height > 0 {
            return
        }
        
        picturePickerControler.view.snp.updateConstraints { (make) in
            make.height.equalTo(view.bounds.height * 0.6)
        }
        //修改文本视图的约束.重建约束
        textView.snp.remakeConstraints { (make) in
            make.top.equalTo(64)
            make.left.right.equalTo(0)
            make.bottom.equalTo(picturePickerControler.view.snp.top)
        }
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    } 
}


// MARK: - 设置UI
fileprivate extension ComposeViewController {
    func setupUI() {
        //跳转间距
        automaticallyAdjustsScrollViewInsets = false
        
        view.backgroundColor = UIColor.white

        prepareNavigationBar()
        prepareToolBar()
        prepareTextView()
        preparePicturePicker()
        // 键盘隐藏的时候，助理视图也会隐藏
//        textView.inputAccessoryView = toolBar
        
    }
    
    private func preparePicturePicker() {
        addChildViewController(picturePickerControler)
        view.insertSubview(picturePickerControler.view, belowSubview: toolBar)
        picturePickerControler.view.snp.makeConstraints { (make) in
            make.bottom.left.right.equalTo(0)
            make.height.equalTo(0)
        }
    }
    
    /// 准备视图文本
    private func prepareTextView() {
        view.addSubview(textView)
        textView.snp.makeConstraints { (make) in
            make.top.equalTo(64)
            make.left.right.equalTo(0)
            make.bottom.equalTo(toolBar.snp.top)
        }
        
        textView.addSubview(placeHolderLabel)
        placeHolderLabel.snp.makeConstraints { (make) in
            make.top.equalTo(textView.snp.top).offset(8)
            make.left.equalTo(textView.snp.left).offset(5)
        }
    }
    
    /// 准备工具条
    private func prepareToolBar() {
        view.addSubview(toolBar)
        toolBar.snp.makeConstraints { (make) in
            make.bottom.equalTo(0)
            make.left.right.equalTo(0)
            make.height.equalTo(44)
        }
        
        // 2 > 添加按钮
        let itemSettings = ["compose_toolbar_picture",
                            "compose_mentionbutton_background",
                            "compose_trendbutton_background",
                            "compose_emoticonbutton_background",
                            "compose_add_background",
                            ]
        
        var items = [UIBarButtonItem]()
        for index in 0..<itemSettings.count {
            let btn = UIButton(imageName: itemSettings[index], backImageName: "")
            btn.addTarget(self, action: #selector(ComposeViewController.itemClick(btn:)), for: .touchUpInside)
            btn.tag = 100 + index
            let item = UIBarButtonItem(customView: btn)
            items.append(item)
            items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        }
        
        items.removeLast()
        toolBar.items = items
    }
    
    /// 设置导航栏
    private func prepareNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(ComposeViewController.close))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发布", style: .plain, target: self, action: #selector(ComposeViewController.sendStatus))
        
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        // 2 > 标题视图
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 32))
        navigationItem.titleView = titleView
        
        // 3> 添加子控件
        let titleLabel = UILabel(title: "发微博", fontSize: 15)
        let nameLabel = UILabel(title: UserAccountViewModel.sharedUserAccount.account?.screen_name ?? "", fontSize: 13, color: UIColor.lightGray)
        titleView.addSubview(titleLabel)
        titleView.addSubview(nameLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(titleView.snp.centerX)
            make.top.equalTo(titleView.snp.top)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(titleView.snp.centerX)
            make.bottom.equalTo(titleView.snp.bottom)
        }
    }
}
