//
//  CheetahBaseModel.swift
//  iCCUT
//
//  Created by Maru on 16/5/8.
//  Copyright © 2016年 Alloc. All rights reserved.
//

import Foundation
import RealmSwift

public class CheetahBaseModel: Object {

    /// 资源的URL地址
    dynamic var mar_url: String? = nil
    /// 资源的ResumeData
    dynamic var mar_data: NSData? = nil
    /// 资源的名称
    dynamic var name: String? = nil
    /// 是否已经下载完毕
    dynamic var complete: Bool = false
    
    override public static func primaryKey() -> String? {
        return "mar_url"
    }
    
}