//
//  WBRefreshControl.swift
//  DinoWeiBo
//
//  Created by liu yao on 2017/2/27.
//  Copyright © 2017年 深圳多诺信息科技有限公司. All rights reserved.
//

import UIKit

private let WBRefreshControlOffset: CGFloat = -60

/// 自定义刷新控件 - 负责处理刷新逻辑
class WBRefreshControl: UIRefreshControl {
    
    // MARK: - 重写系统方法
    override func endRefreshing() {
        super.endRefreshing()
        //停止动画
        refreshView.stopAnimation()
    }
    override func beginRefreshing() {
        super.beginRefreshing()
        refreshView.startAnimation()
    }
    
    // MARK: - KVO 监听方法
    
    /// 箭头旋转标记
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        /* 始终待在屏幕上。下拉是frame的y一直变小，相反（向上推）一直变大。默认y是0 */
        if frame.origin.y > 0 {
            return
        }
        // 判断是否正在刷新
        if isRefreshing {
            refreshView.startAnimation()
            return
        }
        
        // 零界点判断
        if frame.origin.y <  WBRefreshControlOffset && !refreshView.rotateflag{
            //反过来
//            print("反过来")
            refreshView.rotateflag = true
        } else if frame.origin.y >= WBRefreshControlOffset && refreshView.rotateflag {
            //转过去
//            print("转过去")
            refreshView.rotateflag = false

        }
    }
    
    // MARK: - 构造函数
    override init() {
        super.init()
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    private func setupUI() {
        tintColor = UIColor.clear //隐藏转轮
        
        addSubview(refreshView)
        // 自动布局 - 从XIB加载的控件需要制定大小约束
        refreshView.snp.makeConstraints { (make) in
            make.center.equalTo(self.snp.center)
            make.size.equalTo(refreshView.bounds.size)
        }
        
        // 使用 KVO 监听位置变化
        // 第一个对象是要监听的对象self 
        //第一个参数：谁负责监听，这里直接监听直接   
        //frame控件位置
        DispatchQueue.main.async {
            //让允许循环中所有代码执行完毕，运行循环结束前，开始监听。
            // 方法触发会在下一次开始！ 多线程中的使用技巧。
            self.addObserver(self, forKeyPath: "frame", options: [], context: nil)
        }
        
    }
    
    deinit {
        // 删除 KVO 监听方法
        self.removeObserver(self, forKeyPath: "frame")
    }
    
    private lazy var refreshView = WBRefreshView.refreshView()
}


/// 刷新视图 - 负责处理动画显示
class WBRefreshView: UIView {
    @IBOutlet weak var tipIconView: UIImageView!
    
    @IBOutlet weak var loadingIconView: UIImageView!
    @IBOutlet weak var tipView: UIView!
    var rotateflag =  false {
        didSet {
            rotateTipIcon()
        }
    }
    
    class func refreshView() -> WBRefreshView{
        // 推荐使用UINib加载XIB文件
        return UINib(nibName: "WBRefreshView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! WBRefreshView
        // 使用Bundle 加载控件
//        return  Bundle.main.loadNibNamed("WBRefreshView", owner: self, options: nil)?.first as! WBRefreshView
        
    }
    
    
    /// 旋转图标动画
    private func rotateTipIcon() {
        var angle = CGFloat(M_PI)
        angle += rotateflag ? -0.000001 : 0.000001
        
        // 旋转动画特点： 顺时针优先 + 就近原则
        UIView.animate(withDuration: 0.5) { 
            self.tipIconView.transform = self.tipIconView.transform.rotated(by: CGFloat(angle))
        }
    }
    
    /// 播放加载动画
    func startAnimation() {
        tipView.isHidden = true
        
        // 判断动画是否被添加
        let key = "transform.rotation"
        if loadingIconView.layer.animation(forKey: key) != nil {
            //动画已经有了返回
            return
        }
        
        let anim = CABasicAnimation(keyPath: key)
        anim.toValue = 2 * M_PI
        anim.repeatCount = MAXFLOAT
        anim.duration = 0.5
        loadingIconView.layer.add(anim, forKey: key)
    }
    
    ///停止加载动画
    func stopAnimation() {
         tipView.isHidden = false
        loadingIconView.layer.removeAllAnimations()
    }
    
    
}
