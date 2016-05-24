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

struct API_Route {
    
    /// 参数映射
    static let TypeMapping = ["纪录片": "documentary","学习": "study","动漫频道": "cartoon","影视": "movie"];
    
    /// 新闻接口路由
    static let News = "\(HOST)/api/newslist"
    /// 视频列表路由
    static let Videos = "\(HOST)/api/vides"
}

class CCNetService {
    
    static func fetchNewsList(page: Int,success:()->(),fail:()->()) {
        Alamofire.request(.GET, "http://127.0.0.1:5050/api/newslist?index=0", parameters: nil, encoding: .URLEncodedInURL)
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
}
