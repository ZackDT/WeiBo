//
//  UIColor+Extension.swift
//  DinoWeiBo
//
//  Created by liu yao on 2017/2/18.
//  Copyright © 2017年 深圳多诺信息科技有限公司. All rights reserved.
//
import Foundation
import UIKit

extension UIColor {
    
    convenience init(r:CGFloat,g:CGFloat,b:CGFloat) {
        assert(r >= 0 && r <= 255, "Invalid red component")
        assert(g >= 0 && g <= 255, "Invalid green component")
        assert(b >= 0 && b <= 255, "Invalid blue component")
        
        self.init(red: r/255.0 ,green: g/255.0 ,blue: b/255.0 ,alpha:1.0)
    }
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    class func randomColor() -> UIColor {
        // 0 ~ 255
        return UIColor(r: CGFloat(arc4random_uniform(256)), g: CGFloat(arc4random_uniform(256)), b: CGFloat(arc4random_uniform(256)))
    }
    
    convenience init(hex: Int) {
        self.init(red: (hex >> 16) & 0xff, green: (hex >> 8) & 0xff, blue: hex & 0xff)
    }
    
    /// 支持格式包括： #ff21af64   #21af64   0x21af64
    class func RGB(_ rgbValue: String) -> UIColor? {
        
        ///  支持格式包括： #ff21af64   #21af64   0x21af64
        if (rgbValue.hasPrefix("#") || (rgbValue.hasPrefix("0x"))) {
            let mutStr = (rgbValue as NSString).mutableCopy() as! NSMutableString
            
            if (rgbValue.hasPrefix("#")) {
                mutStr.deleteCharacters(in: NSRange.init(location: 0, length: 1))
            } else {
                mutStr.deleteCharacters(in: NSRange.init(location: 0, length: 2))
            }
            
            if (mutStr.length == 6) {
                mutStr.insert("ff", at: 0)
            }
            
            
            let aStr = mutStr.substring(with: NSRange.init(location: 0, length: 2))
            let rStr = mutStr.substring(with: NSRange.init(location: 2, length: 2))
            let gStr = mutStr.substring(with: NSRange.init(location: 4, length: 2))
            let bStr = mutStr.substring(with: NSRange.init(location: 6, length: 2))
            
            let alpha = aStr.hexValue()
            let red = rStr.hexValue()
            let green = gStr.hexValue()
            let blue = bStr.hexValue()
            
            return UIColor.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: CGFloat(alpha) / 255.0)
        }else{
            assert(false, "16进制字符串转UIColor：格式不支持")
            return nil
        }
    }
    
    class func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    /// 通过16进制设置颜色
    ///
    /// - Parameter hex: 0x00ffad
    /// - Returns: 相应的颜色对象
    class func colorWithHex(hex: UInt32) -> UIColor {
        let r: CGFloat = CGFloat((hex & 0xff0000) >> 16)
        let g: CGFloat = CGFloat((hex & 0x00ff00) >> 8)
        let b: CGFloat = CGFloat(hex & 0x0000ff)
        
        return rgb(red: r, green: g, blue: b)
    }
    
    
    static let system = UIColor(hex: 0x035d9a)
    static let background = UIColor(hex: 0xf4f5f7)
    static let systemGray = UIColor(hex: 0xe2e2e2)
    
}
