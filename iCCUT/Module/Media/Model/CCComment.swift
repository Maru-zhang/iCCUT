//
//  CCComment.swift
//  iCCUT
//
//  Created by Maru on 16/5/28.
//  Copyright © 2016年 Alloc. All rights reserved.
//

import UIKit
import ObjectMapper

struct CCComment: Mappable {
    
    /// 评论内容
    var content: String!
    /// 评论时间
    var datetime: String!
    /// 点赞数量
    var good: Int!
    /// 评论的用户
    var user: String!
    
    
    init?(_ map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        content   <- map["content"]
        datetime  <- map["datetime"]
        good      <- map["good"]
        user      <- map["user"]
    }
}