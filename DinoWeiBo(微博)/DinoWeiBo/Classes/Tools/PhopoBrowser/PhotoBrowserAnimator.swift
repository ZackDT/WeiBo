//
//  PhotoBrowserAnimator.swift
//  DinoWeiBo
//
//  Created by liu yao on 2017/3/15.
//  Copyright © 2017年 深圳多诺信息科技有限公司. All rights reserved.
//

import UIKit


// MARK: - 展现动画协议
protocol PhotoBrowserPresentDelegate: NSObjectProtocol {
    
    /// 指定 indexPath 对应的 imageView ， 用来做动画效果的
    func imageViewForPresent(indexPath: IndexPath) -> UIImageView
    /// 动画转场的起始位置
    func photoBrowserPresentFormRect(indexPath: IndexPath) -> CGRect
    /// 动画转场的目标位置
    func photoBrowserPresentToRect(indexPath: IndexPath) -> CGRect
}

// MARK: - 解除动画协议
protocol PhotoBrowserDismissDelegate: NSObjectProtocol {
    
    /// 解除的图像视图（包含位置）
    func imageViewForDismiss() -> UIImageView
    /// 解除转场的图像索引
    func indexPathForDismiss() -> IndexPath
}


// MARK: -  提供动画转场的代理
class PhotoBrowserAnimator: NSObject,UIViewControllerTransitioningDelegate {
    /// 展现代理
    weak var presentDelegate: PhotoBrowserPresentDelegate?
    /// 解除动画代理
    weak var dismissDelegate: PhotoBrowserDismissDelegate?
    
    /// 动画图像的索引
    var indexPath: IndexPath?
    
    /// 是否 modal 展现的标记
    fileprivate var isPresented = false
    
    
    /// 设置代理相关参数
    ///
    /// - Parameters:
    ///   - presentDelegate: 展现代理对象
    ///   - indexPath: 图像索引
    func setDelegateParams(presentDelegate: PhotoBrowserPresentDelegate,
                           indexPath: IndexPath,
                           dismissDelegate: PhotoBrowserDismissDelegate) {
        self.presentDelegate = presentDelegate
        self.indexPath = indexPath
        self.dismissDelegate = dismissDelegate
    }
    
    /// 返回提供展现动画的对象
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = true
        return self
    }
    
     /// 返回 dismiss 动画的对象

     func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = false
        return self
    }
}


// MARK: - UIViewControllerAnimatedTransitioning 实现具体的动画方法
extension PhotoBrowserAnimator: UIViewControllerAnimatedTransitioning {
    
    /// 动画时长
    ///
    /// - Parameter transitionContext: 转场动画的上下文 - 提供动画所需要的素材
    /// - Returns: 时长
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    /// 实现具体的动画效果 - 一旦实现此方法，所有的动画代码交由程序员负责
    ///
    /// - Parameter transitionContext: 转场动画的上下文 - 提供动画所需要的素材
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        /*
         1、容器视图 containerView 会将 Model 要展现的视图包装在容器视图中.存放的视图要显示，必须自己制定大小。
         2、transitionContext: FromVC / ToVC
         3、transitionContext: fromView / toView
         4、completeTransition(_ didComplete: Bool) 无论转场是否取消必须被调用，否则，系统不做其他事件
         */
        let fromVC = transitionContext.viewController(forKey: .from)  //DinoWeiBo.MainViewController //dismiss的时候是DinoWeiBo.PhotoBrowserViewController
        let toVC = transitionContext.viewController(forKey: .to)     //DinoWeiBo.PhotoBrowserViewController
        
        isPresented ? presentAnimation(transitionContext: transitionContext) : dismissAnimation(transitionContext: transitionContext)
    }
    
    /// 解除转场动画
    private func dismissAnimation(transitionContext: UIViewControllerContextTransitioning) {
        
        guard let presentDelegate = presentDelegate,
            let dismissDelegate = dismissDelegate else {
            return
        }
        // 1.获取要 dismiss 的控制器视图
        let fromView = transitionContext.view(forKey: .from)!// nil dismiss的时候图片浏览器的view
        fromView.removeFromSuperview()
        
        // 2. 获取图像视图
        let iv = dismissDelegate.imageViewForDismiss()
        transitionContext.containerView.addSubview(iv)
        let indexPath = dismissDelegate.indexPathForDismiss()
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            iv.frame = presentDelegate.photoBrowserPresentFormRect(indexPath: indexPath)
        }) { (_) in
            // 告诉系统转场完成
            iv.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
    }
    
    /// 展现动画
    private func presentAnimation(transitionContext: UIViewControllerContextTransitioning) {
        // 1. 目标视图
        let toView = transitionContext.view(forKey: .to)// 获取 modal 要展现的跟视图
        transitionContext.containerView.addSubview(toView!) // 将视图添加到容器视图中
    
        // 获取目标控制器
        let toVC = transitionContext.viewController(forKey: .to) as! PhotoBrowserViewController
        toVC.collectionView.isHidden = true
        
        // 2. 能够拿到参与动画的图像视图、起始位置、目标位置
        guard let presentDelegate = presentDelegate,let indexPath = indexPath else { return }
        let iv = presentDelegate.imageViewForPresent(indexPath: indexPath)
        iv.frame = presentDelegate.photoBrowserPresentFormRect(indexPath: indexPath)
        transitionContext.containerView.addSubview(iv)
        
        toView?.alpha = 0
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: { 
            toView?.alpha = 1
            iv.frame = presentDelegate.photoBrowserPresentToRect(indexPath: indexPath)
        }) { (_) in
            // 告诉系统转场完成 删除视图
            iv.removeFromSuperview()
            toVC.collectionView.isHidden = false
            transitionContext.completeTransition(true)
        }
        
        
    }
}
