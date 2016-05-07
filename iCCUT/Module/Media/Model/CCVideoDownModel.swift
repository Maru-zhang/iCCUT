//
//  CCVideoDownModel.swift
//  iCCUT
//
//  Created by Maru on 15/10/17.
//  Copyright © 2015年 Alloc. All rights reserved.
//

import UIKit
import RealmSwift

public class CCVideoDownModel: Object {
    
    dynamic var mar_url: String? = nil
    dynamic var mar_data: NSData? = nil
    dynamic var name: String? = nil
    dynamic var sorOne: String? = nil
    dynamic var sortTwo: String? = nil
    
    override public static func primaryKey() -> String? {
        return "mar_url"
    }
}
