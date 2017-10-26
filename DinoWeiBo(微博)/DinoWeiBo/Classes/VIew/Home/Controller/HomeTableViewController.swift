//
//  HomeTableViewController.swift
//  DinoWeiBo
//
//  Created by liu yao on 2017/2/5.
//  Copyright © 2017年 深圳多诺信息科技有限公司. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD


/// 原创微博cell的可重用id
let StatusCellNormalId = "StatusCellNormalId"

/// 转发微博可重用id
let StatusRetweetedId = "StatusRetweetedId"

class HomeTableViewController: VisitorTableViewController {

    lazy var listViewModel = StatusListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !UserAccountViewModel.sharedUserAccount.userLogon {
            visitorView?.setupInfo(imageName: nil, title: "关注一些人，会这看看有什么惊喜！")
            return
        }
        prepareTableView()
        loadData()
        
        //注册通知 - 图片浏览器通知
        NotificationCenter.default.addObserver(self, selector: #selector(HomeTableViewController.gotoPhoto(notification:)), name: NSNotification.Name(rawValue: DinoSelectedPhopoNotification), object: nil)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    /// 准备表格
    private func prepareTableView() {
        
        tableView.register(StatusNormalCell.self, forCellReuseIdentifier: StatusCellNormalId)
        tableView.register(StatusRetweetedCell.self, forCellReuseIdentifier: StatusRetweetedId)
        // 预估行高需要尽量准确
        tableView.estimatedRowHeight = 400
        //取消分割线
        tableView.separatorStyle = .none
        
        // 下拉刷新  默认控件高度60
        refreshControl = WBRefreshControl()
        refreshControl?.addTarget(self, action: #selector(HomeTableViewController.loadData), for: .valueChanged)
        
        // 上拉动画
        tableView.tableFooterView = pullupView
    }

    
    /// 加载数据
    @objc func loadData() {
        refreshControl?.beginRefreshing()
        listViewModel.loadStatus(isPullup: pullupView.isAnimating) { (isSuccessed) in
            self.refreshControl?.endRefreshing()
            if !self.pullupView.isAnimating {
//                self.showPulldownTip()
            }
            
            self.pullupView.stopAnimating()
            if !isSuccessed {
                SVProgressHUD.show(withStatus: "加载数据出错，请稍后再试")
                return
            }
            
            
            self.tableView.reloadData()
        }
    }
    
    
    /// 显示下拉刷新
    private func showPulldownTip() {
        guard let count = listViewModel.pullDownCount else {
            return
        }
        QL1("下拉刷新 \(count)")
        pulldownTipLabel.text = (count == 0) ? "没有新微博" : "刷新到\(count)微博"
        let heigth: CGFloat = 44
        let rect = CGRect(x: 0, y: 0, width: self.view.width, height: heigth)
        pulldownTipLabel.frame = rect.offsetBy(dx: 0, dy: -2 * heigth)
        UIView.animate(withDuration: 1.0, animations: { 
            self.pulldownTipLabel.frame = rect.offsetBy(dx: 0, dy: heigth)
        }) { (_) in
            UIView.animate(withDuration: 1.0, animations: { 
                self.pulldownTipLabel.frame = rect.offsetBy(dx: 0, dy: -2 * heigth)
            })
        }
        
        
    }
    // MARK: - 懒加载控件
    private lazy var pulldownTipLabel: UILabel = {
        let label = UILabel(title: "", fontSize: 18, color: UIColor.white)
        label.backgroundColor = UIColor.orange
    
        self.navigationController?.navigationBar.insertSubview(label, at: 0)
        return label
    }()

    lazy var pullupView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        
        indicator.color = UIColor.lightGray
        return indicator
    }()
    
    /// 照片查看转场动画代理
    fileprivate lazy var photoBrowserAnimator: PhotoBrowserAnimator = PhotoBrowserAnimator()
}


// MARK: - 图片浏览器
fileprivate extension HomeTableViewController {
    @objc func gotoPhoto(notification: Notification) {
        guard let indexPath = notification.userInfo?[DinoSelectedPhotoIndexpathKey] as? IndexPath else {
            return
        }
        guard let urls = notification.userInfo?[DinoSelectedPhotoURLKey] as? [URL] else {
            return
        }
        // 判断cell是否遵守展现动画的协议  StatusPictureView == cell
        guard let cell = notification.object as? PhotoBrowserPresentDelegate else {
            return
        }
        let phopoBrowser = PhotoBrowserViewController(urls: urls, indexPath: indexPath)
        
        // 设置 自定义的转场动画 Transition(转场)
        phopoBrowser.modalPresentationStyle = .custom
        phopoBrowser.transitioningDelegate = photoBrowserAnimator
        
        // 设置 animator 代理参数
        self.photoBrowserAnimator.setDelegateParams(presentDelegate: cell, indexPath: indexPath, dismissDelegate: phopoBrowser)
        
        self.present(phopoBrowser, animated: true, completion: nil)
    }
}

// MARK: - 数据源方法
extension HomeTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listViewModel.statusList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let vm = listViewModel.statusList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: vm.cellId, for: indexPath) as! StatusCell
        cell.viewModel = listViewModel.statusList[indexPath.row]
        
        //判断是否是最后一条微博
        if indexPath.row == listViewModel.statusList.count - 1 && !pullupView.isAnimating {
            //上啦刷新数据
            QL2("上啦刷新数据")
            pullupView.startAnimating()
            loadData()
        }
        cell.cellDelegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // 1. 视图模型
        let vm = listViewModel.statusList[indexPath.row]
        return vm.rowHeight
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        QL2("选中\(indexPath)")
    }
}


// MARK: - StatusCellDelegate
extension HomeTableViewController: StatusCellDelegate {
    func statusCellDidClick(url: URL) {
        BaseWebViewController.showWebView(control: self, url: url.absoluteString, title: "网页")
    }
}
