//
//  CCVideoModel.swift
//  iCCUT
//
//  Created by Maru on 15/9/24.
//  Copyright © 2015年 Alloc. All rights reserved.
//
import ObjectMapper

class CCVideoModel: NSObject,Mappable {
    
    var id: Int!
    var name: String!
    var url: String!
    var sorOne: String!
    var sortTwo: String!
    var cover: String!
    
    override init() {
        super.init()
    }
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        id <- map["id"]
        name <- map["title"]
        url <- map["url"]
        sorOne <- map["leve1"]
        sortTwo <- map["leve2"]
        cover <- map["cover"]
    }
}
