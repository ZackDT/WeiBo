//
//  ProfileTableViewController.swift
//  DinoWeiBo
//
//  Created by liu yao on 2017/2/5.
//  Copyright © 2017年 深圳多诺信息科技有限公司. All rights reserved.
//

import UIKit

class ProfileTableViewController: VisitorTableViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        visitorView?.setupInfo(imageName: "visitordiscover_image_profile", title: "登录后，你的微薄、相册、个人资料会显示在这里，展示给别人。")
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "日期选择器", style: .plain, target: self, action: #selector(ProfileTableViewController.dataPickerShow))
        
        
    }
    
    
    
    func dataPickerShow() {
        
        navigationController?.pushViewController(DatePickerTestController(), animated: true)
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }


}
