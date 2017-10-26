//
//  NSDate+Extension.swift
//  DinoWeiBo
//
//  Created by liu yao on 2017/2/18.
//  Copyright © 2017年 深圳多诺信息科技有限公司. All rights reserved.
//

import Foundation
import UIKit

public struct Constants {
    
    public struct Formatters {
        
        static let monthDateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM"
            
            return formatter
        }()
        
        static let yearDateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy"
            
            return formatter
        }()
        
        static let dayDateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd"
            
            return formatter
        }()
        
        static let currencyFormatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            return formatter
        }()
        
        static let currencyFormatterWithoutComma: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = NumberFormatter.Style.currency
            formatter.maximumFractionDigits = 0
            return formatter
        }()
        
    }
    
}


extension Date{
    
    static func getCurrentTime() -> String {
        let nowDate = Date()
        
        let interval = Int(nowDate.timeIntervalSince1970)
        
        return "\(interval)"
    }
    
    /// 返回当前日期的描述信息
    /*
     刚刚（一分钟内）
     X分钟前（一小时内）
     X小时前（当天）
     昨天 HH：mm
     MM-dd HH：mm（一年内）
     yyyy-MM-dd HH：MM （更早期） 
     
     */
    var dateDescription: String {
        let calendar = Calendar.current
        if calendar.isDateInToday(self) {
            let delta = Int(Date().timeIntervalSince(self))
            if delta < 60 {
                return "刚刚"
            }
            if delta < 3600 {
                return "\(delta / 60)分钟前"
            }
            return "\(delta / 3600)小时前"
        }
        var fmt = " HH:mm"
        if calendar.isDateInYesterday(self) {
            fmt = "昨天" + fmt
        }else {
            fmt = "MM-dd" + fmt
            //canlendar.component(.year, from: date)  // 直接获取年的数值
            let comps = calendar.dateComponents([.year], from: self, to: Date())
            if comps.year! > 0 {
                fmt = "yyyy-" + fmt
            }
        }
        
        //根据格式字符串生成描述字符串
        let df = DateFormatter()
        df.locale = Locale(identifier: "en")
        df.dateFormat = fmt
        return df.string(from: self)
    }
    
    func isOver18Years() -> Bool {
        var comp = (Calendar.current as NSCalendar).components(NSCalendar.Unit.month.union(.day).union(.year), from: Date())
        guard comp.year != nil && comp.day != nil else { return false }
        
        comp.year! -= 18
        comp.day! += 1
        if let date = Calendar.current.date(from: comp) {
            if self.compare(date) != ComparisonResult.orderedAscending {
                return false
            }
        }
        return true
    }
    
    /// returns the month of a date in `MMMM` format
    func monthName() -> String {
        return Constants.Formatters.monthDateFormatter.string(from: self)
    }
    
    /// returns the year of a date in `yyyy` format
    func year() -> String {
        return Constants.Formatters.yearDateFormatter.string(from: self)
    }
    
    /// returns the day of a date in `dd` format
    func day() -> String {
        return Constants.Formatters.dayDateFormatter.string(from: self)
    }
    
}
