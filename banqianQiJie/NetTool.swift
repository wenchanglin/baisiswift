//
//  NetTool.swift
//  banqianQiJie
//
//  Created by banbo on 2017/8/10.
//  Copyright © 2017年 banbo. All rights reserved.
//

import UIKit
import AFNetworking
class NetTool: NSObject {
    enum RequestType {
        case Get
        case Post
    }
    static let shareInstance = NetTool()
    private override init() {
    let mangaer = AFHTTPSessionManager()
        mangaer.responseSerializer.acceptableContentTypes = ["text/html","text/plain"]
        mangaer.securityPolicy.allowInvalidCertificates = true
        mangaer.securityPolicy.validatesDomainName = false
        AFNetworkReachabilityManager.shared().startMonitoring()
    }
    func requset(requestType:RequestType,url:String,parameters:[String:Any],resultBlock:@escaping([String:Any]?,Error?) -> ()) {
        // 成功闭包
        let successBlock = { (task: URLSessionDataTask, responseObj: Any?) in
            resultBlock(responseObj as? [String : Any], nil)
        }
        
        // 失败的闭包
        let failureBlock = { (task: URLSessionDataTask?, error: Error) in
            resultBlock(nil, error)
        }
        
        // Get 请求
        if requestType == .Get {
            let manger = AFHTTPSessionManager()
           manger.get(url, parameters: parameters, progress: nil, success: successBlock, failure: failureBlock)
        }
        
        // Post 请求
        if requestType == .Post {
            let manger = AFHTTPSessionManager()
            manger.post(url, parameters: parameters,progress:nil,success: successBlock, failure: failureBlock)
        }
    }
    // 将成功和失败的回调分别写在两个逃逸闭包中
    func request(requestType :RequestType, url : String, parameters : [String : Any], succeed : @escaping([String : Any]?) -> (), failure : @escaping(Error?) -> ()) {
        
        // 成功闭包
        let successBlock = { (task: URLSessionDataTask, responseObj: Any?) in
            succeed(responseObj as? [String : Any])
        }
        
        // 失败的闭包
        let failureBlock = { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        }
        
        // Get 请求
        if requestType == .Get {
            let manger = AFHTTPSessionManager()
           
            manger.get(url, parameters: parameters ,progress:nil, success: successBlock, failure: failureBlock)
        }
        
        // Post 请求
        if requestType == .Post {
            let manger = AFHTTPSessionManager()
          
            manger.post(url, parameters: parameters,progress:nil, success: successBlock, failure: failureBlock)
        }
    }

    
}
