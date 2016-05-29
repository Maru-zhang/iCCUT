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
    /// 评论列表路由
    static let comment = "\(HOST)/api/commentlist"
    /// 提交评论路由
    static let commit = "\(HOST)/api/add_comment"
}

class CCNetService {
    
    /**
     获取相应的视频列表
     
     - parameter page:	页码
     - parameter success:	成功回调
     - parameter fail:	失败回调
     */
    static func fetchNewsList(page: Int,success:()->(),fail:()->()) {
        Alamofire.request(.POST, API_Route.News, parameters: nil, encoding: .URLEncodedInURL)
            .responseJSON { (response) in
                switch response.result {
                case .Success(_):
                    let _ = JSON(response.result.value!)

                    break
                case .Failure(_):
                    break
                }
        }
    }
    
    /**
     获取视频搜索列表
     
     - parameter key:		关键字
     - parameter success:	成功回调
     - parameter fail:	返回回调
     */
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
    
    /**
     获取视频评论列表
     */
    static func fetchCommentList(index: Int,vid: Int,success: ([CCComment])->(),fail: (msg: String)->()) {
        Alamofire.request(.POST, API_Route.comment, parameters: ["index": index,"videoid": vid], encoding: .URLEncodedInURL)
            .responseJSON { (response) in
                switch response.result {
                case .Success(_):
                    
                    let json = JSON(response.result.value!)
                    
                    guard json["code"] == 200 else {
                        fail(msg: json["msg"].stringValue)
                        return
                    }
                    
                    let result = Mapper<CCComment>().mapArray(json["data"].rawString())
                    
                    success(result!)
                    
                    break
                case .Failure(_):
                    break
                }
        }
    }
    
    
    static func submitComment(vid: Int,uid: Int?,content: String,success: ()->(),fail: (msg: String)->()) {
        
        var args: [String: String] = ["vid": String(vid),"content": content]
        if let userID = uid { args["uid"] = String(userID) }
        
        Alamofire.request(.POST, API_Route.commit, parameters: args, encoding: .URLEncodedInURL)
            .responseJSON { (response) in
                switch response.result {
                case .Success(_):
                    
                    let json = JSON(response.result.value!)
                    
                    guard json["code"] == 200 else {
                        fail(msg: json["msg"].stringValue)
                        return
                    }
                    
                    success()
                    
                    break
                case .Failure(_):
                    break
                }
        }
    }

}
