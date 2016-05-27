//
//  CCVideoModel.swift
//  iCCUT
//
//  Created by Maru on 15/9/24.
//  Copyright © 2015年 Alloc. All rights reserved.
//
import ObjectMapper

class CCVideoModel: NSObject,Mappable {
    
    var name: String!
    var url: String!
    var sorOne: String!
    var sortTwo: String!
    var cover: String!
    
    
    func configureWithDic(dic: NSDictionary) {
        let urlString: String = dic["url"] as! String
        let name: String = dic["name"] as! String
        let sort_1: String = dic["sortOne"] as! String
        let sort_2: String = dic["sortTwo"] as! String
        
        self.name = name
        self.url = urlString
        self.sorOne = sort_1
        self.sortTwo = sort_2
    }
    
    override init() {
        super.init()
    }
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        name <- map["title"]
        url <- map["url"]
        sorOne <- map["leve1"]
        sortTwo <- map["leve2"]
        cover <- map["cover"]
    }
}
