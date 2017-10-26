//
//  DatePickerTestController.swift
//  DinoWeiBo
//
//  Created by liu yao on 2017/4/7.
//  Copyright © 2017年 深圳多诺信息科技有限公司. All rights reserved.
//

import UIKit

class DatePickerTestController: MainViewController {
    
    // 有些情况需要时加上 44
    var datePicker: DatePickerView = DatePickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "日期选择器", style: .plain, target: self, action: #selector(ProfileTableViewController.dataPickerShow))
        
        self.datePicker.canButtonReturnB = {
            
            self.view.ttDismissPopupViewControllerWithanimationType(TTFramePopupViewSlideBottomTop)
        }
        self.datePicker.sucessReturnB = { result in
            QL2(result)
            self.view.ttDismissPopupViewControllerWithanimationType(TTFramePopupViewSlideBottomTop)
        }
    }

    func dataPickerShow() {
        
        self.view.ttPresentFramePopupView(datePicker, animationType: TTFramePopupViewSlideBottomTop) {
            
        }
    }
    

}
