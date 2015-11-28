//
//  ServerOperator.swift
//  iCCUT
//
//  Created by Maru on 15/11/27.
//  Copyright © 2015年 Alloc. All rights reserved.
//

import Alamofire

class ServerOperator: NSObject {
    
    
    
    /// 搜索的地址
    static let searchAddress = "\(HOST)/iCCUT/servlet/SearchList"

    
    /**
     搜索视频的操作
     
     - parameter keyword: 关键词
     */
    static func getSearchVideoList(keyword: String,
        completeHandler: (videoArray: NSMutableArray
        ) -> Void) {
        
        let parameter = ["keyword": keyword]
        
        basicOperator(searchAddress, parameters: parameter) { (isSuccess, response) -> Void in
            
            let result = NSMutableArray()
            guard isSuccess else {
                completeHandler(videoArray: result)
                return
            }

            let json = JSON(response.result.value!)
            for (_,itemJSON) in json["datas"] {
                let model = CCVideoModel()
                model.name = itemJSON["title"].stringValue
                model.url = itemJSON["url"].stringValue
                result.addObject(model)
            }
            
            // 完成处理
            completeHandler(videoArray: result)
        }
        
    }
    
    
    /**
     基础的网络请求方法
     
     - parameter url:             请求地址
     - parameter parameters:      请求参数
     - parameter completeHandler: 请求完成闭包
     */
    static func basicOperator(url: String,parameters: [String: String],
        completeHandler: (isSuccess: Bool,response: Response<AnyObject, NSError>) -> Void) {
        
        Alamofire.request(.POST, url,parameters: parameters)
            .responseJSON { (response) -> Void in
                switch response.result {
                case .Success:
                    debugPrint(response.result)
                    completeHandler(isSuccess: true,response: response)
                    break
                case.Failure:
                    debugPrint(response.result)
                    completeHandler(isSuccess: false,response: response)
                    break
                }
        }
    }
}
