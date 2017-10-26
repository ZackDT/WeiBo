//
//  AFNetworkTools.swift
//  DinoWeiBo
//
//  Created by liu yao on 2017/2/9.
//  Copyright © 2017年 深圳多诺信息科技有限公司. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import SwiftyJSON

class AFNetworkTools {
    // MARK: - 应用程序信息
    let appKey = "585498302"
    let appSecret = "dad253342d33bbeefc7329bec536a720"
    let redirectUrl = "https://www.baidu.com"
    
    // 网络请求完成的回调 .类似 OC的 typeDefine
    typealias AFNRequestCallBack = (_ result: Any?, _ error: Error?) -> ()
    
    //单例
    static let sharedTools: AFNetworkTools = AFNetworkTools()
    

}

// MARK: - 发布微博
extension AFNetworkTools {
    
    /// 发布微博
    ///
    /// - Parameters:
    ///   - status: 微博文本
    ///   - image:  微博配图
    ///   - finished: 完成的回调
    /// - see: [http://open.weibo.com/wiki/2/statuses/update](http://open.weibo.com/wiki/2/statuses/update)
    /// - see:[http://open.weibo.com/wiki/2/statuses/upload](http://open.weibo.com/wiki/2/statuses/upload)
    func sendStatus(status: String, image: UIImage?, finished:@escaping AFNRequestCallBack) {
        var params = [String: Any]()
        // 2 > 设置参数
        params["status"] = status
        
        if image == nil {
            let urlStr = "https://api.weibo.com/2/statuses/update.json"
            tokenRequest(method: .post, URLString: urlStr, parameters: params, finished: finished)
        } else {
            let urlStr = "https://upload.api.weibo.com/2/statuses/upload.json"
            let data = UIImagePNGRepresentation(image!)
            upload(URLString: urlStr, data: data!, name: "pic", parameters: params, finished: finished)
        }
        
    }
}

// MARK: - OAuth 相关方法
extension AFNetworkTools {
    
    /// 授权URL
    /// - see: [http://open.weibo.com/wiki/Oauth2/authorize](http://open.weibo.com/wiki/Oauth2/authorize)
    var oauthURL: URL {
        let urlStr = "https://api.weibo.com/oauth2/authorize?client_id=\(appKey)&redirect_uri=\(redirectUrl)"
        return URL(string: urlStr)!
    }
    
    /// 加载token
    ///
    /// - Parameters:
    ///   - code: code
    ///   - finished: 完成的回调
    // - see: [http://open.weibo.com/wiki/OAuth2/access_token?sudaref=open.weibo.com](http://open.weibo.com/wiki/OAuth2/access_token?sudaref=open.weibo.com)
    func loadAccessToken(code: String, finished: @escaping AFNRequestCallBack) {
        let urlString = "https://api.weibo.com/oauth2/access_token"
        let params = ["client_id":appKey,
                      "client_secret":appSecret,
                      "grant_type":"authorization_code",
                      "code":code,
                      "redirect_uri":"https://www.baidu.com"
        ]
        request(method: .post, URLString: urlString, parameters: params, finished: finished)
    }
    
}

// MARK: - 微博数据相关方法
extension AFNetworkTools {
    
    /// 加载微博数据
    ///  - Parameter since_id: 若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0。
    ///  - Parameter max_id: 若指定此参数，则返回ID小于或等于max_id的微博，默认为0。
    /// - Parameter finished: 完成回调
    /// - see: [http://open.weibo.com/wiki/2/statuses/home_timeline](http://open.weibo.com/wiki/2/statuses/home_timeline)
    func loadStatus(since_id: Int = 0,max_id: Int = 0,finished: @escaping AFNRequestCallBack) {
        var params = [String: Any]()
        //判断是否上拉还是下拉
        if since_id > 0 {
            // 下拉刷新
            params["since_id"] = since_id
        } else if max_id > 0 {
            //上拉
            params["max_id"] = max_id - 1
        }
        
        let urlStr = "https://api.weibo.com/2/statuses/home_timeline.json"
        tokenRequest(method: .get, URLString: urlStr, parameters: params, finished: finished)
    }
}

// MARK: - 用户相关方法
extension AFNetworkTools {
    
    /// 加载用户信息
    ///
    /// - Parameters:
    ///   - uid: uid
    ///   - accessToken: accesstoken
    ///   - finished: 完成的回调
     // - see: [http://open.weibo.com/wiki/2/users/show](http://open.weibo.com/wiki/2/users/show)
    func loadUserInfo(uid: String, finished: @escaping AFNRequestCallBack) {
        
        var params = [String: Any]()
        
        let urlStr = "https://api.weibo.com/2/users/show.json"
        params["uid"] = uid
        tokenRequest(method: .get, URLString: urlStr, parameters: params, finished: finished)
    }
}

// MARK: - 封装请求方法
extension AFNetworkTools {
    
    
    /// 向 parameters 字典中追加 token 参数
    ///
    /// - Parameter parameters: 参数字典
    /// - Returns: 是否追加成功
    /// - 默认情况下，关于函数参数，在调用时，会做一次copy，函数内部参数改变，不会影响到外部的值
    /// - inout 关键字，相当于 在 OC 中传递对象的地址
    private func appendToken(parameters: inout [String: Any]?) -> Bool {
        
        guard let token = UserAccountViewModel.sharedUserAccount.accessToken else {
            return false
        }
        if parameters == nil {
            parameters = [String: Any]()
        }
        parameters!["access_token"] = token
        return true
    }
    
    /// 使用token进行网络请求
    ///
    /// - Parameters:
    ///   - method: 请求方式 GET POST
    ///   - URLString: URLString
    ///   - parameters: 参数字典
    ///   - finished: 完成的回调
    fileprivate func tokenRequest(method: HTTPMethod, URLString: String, parameters: [String: Any]?, finished: @escaping AFNRequestCallBack) {
        
        // 1 > 追加token
        var tokenparameters = parameters
        if !appendToken(parameters: &tokenparameters ) {
            finished(nil, NSError(domain: "www.baodu.error", code: -1001, userInfo: ["message": "token为空"]))
        }
        
        request(method: method, URLString: URLString, parameters: tokenparameters, finished: finished)
    }
    /// 网络请求
    ///
    /// - Parameters:
    ///   - method: 请求方式 GET POST
    ///   - URLString: URLString
    ///   - parameters: 参数字典
    ///   - finished: 完成的回调
    fileprivate func request(method: HTTPMethod = .get, URLString: URLConvertible, parameters: [String : Any]?, finished: @escaping AFNRequestCallBack) {
        
        // 显示网络指示器
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        Alamofire.request(URLString, method: method, parameters: parameters).responseJSON { (response) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if response.result.isFailure {
                QL4("网络请求失败\(String(describing: response.result.error))")
            }
            finished(response.result.value,response.result.error)
        }
        
    }
    
    /// 上传文件
    fileprivate func upload(URLString: String,data: Data, name: String, parameters: [String: Any]?, finished: @escaping AFNRequestCallBack) {
        
        var tokenparameters = parameters
        if !appendToken(parameters: &tokenparameters ) {
            finished(nil, NSError(domain: "www.baodu.error", code: -1001, userInfo: ["message": "token为空"]))
        }
        /**
         //             *  1. data 要上传文件的二进制数据
         //                2.name 是服务器定义的字段名称 - 后台接口会提示
         //                3.fileName 是保存在服务器的文件名，但是现在通常可以随意写，后天会做后续处理
         //                    --根据上传生成缩略图、中等图、高清图
         //                    -- 保存在不同路径，并且自动生成文件名
         //                    -- fileName 是HTTP协议定义的属性
         //                4. mimeType / contentType: 客户端告诉服务器，二进制数据的准确类型
         //                    --image/jpg image/gif image/png
         //                    --text/plain text/html
         //                    --application/json
         //                    --不想告诉服务器准确类型 application/octet-stream
         //             */
        
        let headers = ["content-type":"multipart/form-data"]
        // 上传文件
        Alamofire.upload(multipartFormData: { (fromData) in
            
            
            // 遍历参数字典，生成对应的参数数据
            if let parameters = parameters {
                for (k, v) in parameters {
                    let str = v as! String
                    let strData = str.data(using: .utf8)
                    fromData.append(strData!, withName: k)
                    
                }
            }
            
            //拼接上传文件的二进制数据
            fromData.append(data, withName: name, fileName: "liuimg", mimeType: "image/png")
            
        }, usingThreshold: 5 * 1024 * 1024, to: URLString, method: .post, headers: headers) { (encodingResult) in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    
                    if response.result.isFailure {
                        QL4("网络请求失败\(String(describing: response.result.error))")
                    }
                    
                    if let value = response.result.value as? [String: AnyObject]{
                        finished(value, nil)
                    }
                }
                break
            case .failure(let encodingError):
                QL4("上传文件编码错误\(encodingError)")
                break
            }
        }
        
    }
    
}
