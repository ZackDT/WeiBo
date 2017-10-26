//
//  CommonFunc.swift
//  DinoWeiBo
//
//  Created by liu yao on 2017/2/19.
//  Copyright © 2017年 深圳多诺信息科技有限公司. All rights reserved.
//

import Foundation


/// 延迟在主线程执行
///
/// - Parameters:
///   - time: 延迟时间
///   - callFunc:   回调
func delay(time: TimeInterval, callFunc: @escaping ()->()) {
    let t = DispatchTime.now() + time
    DispatchQueue.main.asyncAfter(deadline: t) { 
        callFunc()
    }
}


// MARK: - 参考喵神的封装
typealias Task = (_ cancel : Bool) -> Void

/// 延迟在主线程执行
///
/// - Parameters:
///   - time: 延迟时间
///   - task: 回调
/// - Returns: 返回任务
func delay(_ time: TimeInterval, task: @escaping ()->()) ->  Task? {
    
    func dispatch_later(block: @escaping ()->()) {
        let t = DispatchTime.now() + time
        DispatchQueue.main.asyncAfter(deadline: t, execute: block)
    }
    var closure: (()->Void)? = task
    var result: Task?
    
    let delayedClosure: Task = {
        cancel in
        if let internalClosure = closure {
            if (cancel == false) {
                DispatchQueue.main.async(execute: internalClosure)
            }
        }
        closure = nil
        result = nil
    }
    
    result = delayedClosure
    
    dispatch_later {
        if let delayedClosure = result {
            delayedClosure(false)
        }
    }
    return result
}

func cancel(_ task: Task?) {
    task?(true)
}
