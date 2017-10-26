//
//  OAuthViewController.swift
//  DinoWeiBo
//
//  Created by liu yao on 2017/2/11.
//  Copyright © 2017年 深圳多诺信息科技有限公司. All rights reserved.
//

import UIKit
import WebKit
import SVProgressHUD

/// 用户登录控制器
class OAuthViewController: UIViewController {
    
    private lazy var webView = WKWebView()
    
    func close() {
        SVProgressHUD.dismiss()
        dismiss(animated: true, completion: nil)
    }
    
    /// 自动填充用户名和密码  web注入（以代码方式注入代码）
    @objc private func autoFill() {
        let js = "document.getElementById('userId').value = '18665840117';" + "document.getElementById('passwd').value = 'liuyao441';"
        //让webView执行js
        webView.evaluateJavaScript(js, completionHandler: nil)
    }
    
    // MARK: - 设置界面
    override func loadView() {
        view = webView
        webView.navigationDelegate = self
        
        title = "登录新浪微博"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(OAuthViewController.close))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "自动填充", style: .plain, target: self, action: #selector(OAuthViewController.autoFill))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //开发中，如果是纯代码开发，视图最好设置背景颜色。如果为nil，会影响渲染效率
        view.backgroundColor = UIColor.white
        //加载页面
        self.webView.load(URLRequest(url: AFNetworkTools.sharedTools.oauthURL))
        
    }
}

extension OAuthViewController: WKNavigationDelegate {
    /// 1 在发送请求之前，决定是否跳转
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void) {
        decisionHandler(.allow)
    }
    /// 3 在收到服务器的响应头，根据response相关信息，决定是否跳转。decisionHandler必须调用，来决定是否跳转，参数WKNavigationActionPolicyCancel取消跳转，WKNavigationActionPolicyAllow允许跳转
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Swift.Void) {
        //判断主机名是否是百度，是的话不允许跳转
        guard let url = navigationResponse.response.url, url.host == "www.baidu.com" else {
            decisionHandler(.allow)
            return
        }
        //从百度地址url中提取token
        guard let query = url.query, query.hasPrefix("code=") else {
            QL2("取消授权")
            close()
            decisionHandler(.cancel)
            return
        }
        let code = query.substring(from: "code=".endIndex)
        QL2("授权码是： "+code)
        //4、加载token
        UserAccountViewModel.sharedUserAccount.loadAccessToken(code: code) { (isSuccessed) in
            if !isSuccessed {
                SVProgressHUD.showInfo(withStatus: "你的网络不给力！")
                delay(time: 1.0) { self.close() }
                return
            }
            // 这个方法不会立即把控制器销毁 。必须销毁之后才能发送通知。
//            self.dismiss(animated: false, completion: nil)
            self.dismiss(animated: false, completion: {
                SVProgressHUD.dismiss()//停止指示器
                // 通知中心是同步的，一旦发送通知会立即执行监听方法，然后在执行下面的方法。
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: DinoSwitchRootViewControllerNotification), object: "welcome")
            })
            
            
        }
        decisionHandler(.cancel)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        SVProgressHUD.show()
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        SVProgressHUD.dismiss()
    }
    
}
