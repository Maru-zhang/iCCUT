//
//  TSModel.swift
//  NSURLSessionTest
//
//  Created by Maru on 16/4/28.
//  Copyright © 2016年 张斌辉. All rights reserved.
//

import RealmSwift


public class Video: Object {
    
    dynamic var url: String? = nil
    dynamic var resumeData: NSData? = nil
    
    override public static func primaryKey() -> String? {
        return "url"
    }
}

extension Video {
    
}