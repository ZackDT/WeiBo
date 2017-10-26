//
//  MainViewController.swift
//  DinoWeiBo
//
//  Created by liu yao on 2017/4/2.
//  Copyright © 2017年 深圳多诺信息科技有限公司. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        QL1("当前进入\(String(describing: self))控制器" )
    }
    
    deinit {
        QL1("\(String(describing: self))控制器正常释放")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   

}
