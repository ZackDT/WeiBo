//
//  BaseWebViewController.swift
//  DinoWeiBo
//
//  Created by liu yao on 2017/4/2.
//  Copyright © 2017年 深圳多诺信息科技有限公司. All rights reserved.
//

import UIKit
import WebKit

private let WebViewNav_TintColor: UIColor = UIColor.orange

class BaseWebViewController: MainViewController {
    internal var homeUrl: URL?
    fileprivate var progressView: UIProgressView?
    fileprivate var webView: WKWebView?
    
    
    /// 初始化方法
    ///
    /// - Parameters:
    ///   - control: 传入控制器
    ///   - url: url字符串
    ///   - title: 标题
    class func showWebView(control: UIViewController, url: String, title: String) {
        let urlStr = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let webCtl = BaseWebViewController()
        webCtl.homeUrl = URL(string: urlStr!)
        webCtl.title = title
        control.navigationController?.pushViewController(webCtl, animated: true)
    }
    
    // MARK: - 普通点击事件
    func menuBtnPressed(sender: UIButton) {
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let defultAction1 = UIAlertAction(title: "safari打开", style: .default, handler: { (action) -> Void in
            self.actionSheetPress(index: 0)
        })
        let defultAction2 = UIAlertAction(title: "复制链接", style: .default, handler: { (action) -> Void in
            self.actionSheetPress(index: 1)
        })
        let defultAction3 = UIAlertAction(title: "分享", style: .default, handler: { (action) -> Void in
            
        })
        let defultAction4 = UIAlertAction(title: "刷新", style: .default, handler: { (action) -> Void in
            
        })
        let actions = [cancelAction,defultAction1,defultAction2,defultAction3,defultAction4]
        displayAlert(nil, message: nil, actions: actions, preferredStyle:.actionSheet)
       
    }
    
    func actionSheetPress(index: Int) {
        let urlStr = homeUrl?.absoluteString
        switch index {
        case 0:
            // safari打开
            UIApplication.shared.openURL(URL(string: urlStr!)!)
        case 1:
            // 复制链接
            if urlStr != nil {
                UIPasteboard.general.string = urlStr
                displayAlert(message: "已复制链接到黏贴板")
                
            }
        default: break
            
        }
    }
    
    // MARK: - 设置UI
    override func viewDidLoad() {
        super.viewDidLoad()
        // 必须加上这个，要不然 progressView不显示出来
        edgesForExtendedLayout = UIRectEdge()
        view.backgroundColor = UIColor.white
        configUI()
        configBackItem()
    }
    
    deinit {
        webView?.removeObserver(self, forKeyPath: "estimatedProgress")
        webView?.removeObserver(self, forKeyPath: "loading")
        webView?.removeObserver(self, forKeyPath: "title")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            let newProgress = Float((webView?.estimatedProgress)!)
            if newProgress == 1 {
                progressView?.isHidden = true
                progressView?.setProgress(0, animated: true)
            }else {
                progressView?.isHidden = false
                progressView?.setProgress(newProgress, animated: true)
            }
        }else if keyPath == "loading" {
            QL2("loading")
        }else if keyPath == "title" {
            title = webView?.title
        }

    }
    
}


// MARK: - 设置UI
extension BaseWebViewController {
    fileprivate func configUI() {
        // 1. 进度条
        let progressView = UIProgressView(frame: CGRect(x: 0, y: 0, width: self.view.width, height: 0))
        progressView.tintColor = WebViewNav_TintColor
        progressView.trackTintColor = UIColor.white
        view.addSubview(progressView)
        self.progressView = progressView
        
        // 2. 浏览器 8.0 以上。
        let wkWebView = WKWebView(frame: self.view.bounds)
        wkWebView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        wkWebView.backgroundColor = UIColor.white
        wkWebView.navigationDelegate = self
        view.insertSubview(wkWebView, belowSubview: progressView)
        //KVO 监听支持KVO属性
        DispatchQueue.main.async {
            wkWebView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil) // 页面内容加载的进度
            wkWebView.addObserver(self, forKeyPath: "loading", options: .new, context: nil) //是否正在加载
            wkWebView.addObserver(self, forKeyPath: "title", options: .new, context: nil)   //页面的标题
        }
        var request = URLRequest(url: homeUrl!)
        request.cachePolicy = .returnCacheDataElseLoad
        wkWebView.load(request)
        self.webView = wkWebView
    }
    
    fileprivate func configBackItem() {
        // 导航栏的菜单按钮
        var menuImage = UIImage(named: "cc_webview_menu")
        menuImage = menuImage?.withRenderingMode(.alwaysTemplate)
        let menuBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 5, height: 20))
        menuBtn.tintColor = WebViewNav_TintColor
        menuBtn.setImage(menuImage, for: UIControlState())
        menuBtn.addTarget(self, action: #selector(BaseWebViewController.menuBtnPressed(sender:)), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: menuBtn)
    }
    
}


// MARK: - WKNavigationDelegate
extension BaseWebViewController: WKNavigationDelegate {
    
}
