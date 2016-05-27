//
//  CCNetService.swift
//  iCCUT
//
//  Created by Maru on 16/5/23.
//  Copyright © 2016年 Alloc. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import ObjectMapper

struct API_Route {
    
    /// 参数映射
    static let TypeMapping = ["纪录片": "documentary","学习": "study","动漫频道": "cartoon","影视": "movie"];
    
    /// 新闻接口路由
    static let News = "\(HOST)/api/newslist"
    /// 视频列表路由
    static let Videos = "\(HOST)/api/vides"
    /// 视频搜索路由
    static let Search = "\(HOST)/api/videoSearch"
}

class CCNetService {
    
    static func fetchNewsList(page: Int,success:()->(),fail:()->()) {
        Alamofire.request(.POST, API_Route.News, parameters: nil, encoding: .URLEncodedInURL)
            .responseJSON { (response) in
                switch response.result {
                case .Success(_):
                    let json = JSON(response.result.value!)

                    break
                case .Failure(_):
                    break
                }
        }
    }
    
    static func fetchSearchResult(key: String,success: ([CCVideoModel])->(),fail: (msg: String)->()) {
        Alamofire.request(.POST, API_Route.Search,parameters: ["key": key],encoding: .URLEncodedInURL)
            .responseJSON { (response) in
                switch response.result {
                case .Success(_):
                    
                    let json = JSON(response.result.value!)
                    
                    guard json["code"] == 200 else {
                        fail(msg: json["msg"].stringValue)
                        return
                    }
                    
                    let modelArr = Mapper<CCVideoModel>().mapArray(json["data"].rawString())
                    
                    success(modelArr!)
                    
                    break
                case .Failure(_):
                    break
                }
        }
    }
}
