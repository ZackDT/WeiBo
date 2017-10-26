//
//  UIImageView+Extension.swift
//  DinoWeiBo
//
//  Created by liu yao on 2017/2/7.
//  Copyright © 2017年 深圳多诺信息科技有限公司. All rights reserved.
//

import UIKit

extension UIImageView {
    
    convenience init(imageName: String ) {
        let img = UIImage(named: imageName)
        self.init(image: img)
    }
    
}
