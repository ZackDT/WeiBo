//
//  UITableView+Extension.swift
//  DinoWeiBo
//
//  Created by liu yao on 2017/3/26.
//  Copyright © 2017年 深圳多诺信息科技有限公司. All rights reserved.
//

import UIKit


// MARK: - 复用 cell 的扩展
extension UITableView {
    
    /// 复用cell 默认是cell类名
    ///
    /// - Parameters:
    ///   - _: cel类
    ///   - reuseIdentifier: 复用标记，默认是cell类名
    func register<T: UITableViewCell>(_: T.Type, reuseIdentifier: String = String(describing: T.self)) {
        self.register(T.self, forCellReuseIdentifier: reuseIdentifier)
    }
    
    
    /// 复用cell 默认是cell类名
    ///
    /// - Parameters:
    ///   - indexPath: indexPath
    ///   - reuseIdentifier: 复用标记，默认是cell类名
    /// - Returns: cell
    func dequeueReusableCell<T: UITableViewCell>(indexPath: IndexPath, reuseIdentifier: String = String(describing: T.self)) -> T {
        return self.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! T
    }
    
    
}

extension UITableView {
    
    func setFooterWithSpacing(_ view: UIView) {
        
        guard self.numberOfSections > 0 else {
            self.tableFooterView = view
            return
        }
        
        guard let cell = self.cellForRow(at: IndexPath(row: self.numberOfRows(inSection: self.numberOfSections - 1) - 1, section: self.numberOfSections - 1)) else {
            self.tableFooterView = view
            return
        }
        
        let cellY = cell.frame.origin.y
        let footerContainerY = cellY + cell.frame.height
        let footerContainerHeight = UIScreen.main.bounds.height - footerContainerY
        
        if footerContainerHeight > 0 {
            let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: footerContainerHeight)
            let footerContainerView = UIView(frame: frame)
            footerContainerView.backgroundColor = .clear
            let viewY = footerContainerHeight - view.frame.height
            view.frame.origin.y = viewY
            view.frame.origin.x = 0
            footerContainerView.addSubview(view)
            self.tableFooterView = footerContainerView
        } else {
            self.tableFooterView = view
        }
    }
    
    func reloadDataAnimated(_ duration: TimeInterval = 0.4, completion: (() -> Void)?) {
        UIView.transition(
            with: self,
            duration: duration,
            options: .transitionCrossDissolve,
            animations: { [weak self] _ in
                self?.reloadData()
            },
            completion: { _ in completion?() })
    }
    
}

