//
//  DataBaseManager.swift
//  iCCUT
//
//  Created by Maru on 15/10/16.
//  Copyright © 2015年 Alloc. All rights reserved.
//

import UIKit
import CoreData

class DataBaseManager: NSObject {
    
    /** 单例对象 */
    static let manager = DataBaseManager()
    /** 模型 */

    /* Life Cycle */
    class func getInstance() -> DataBaseManager {
        return manager
    }
    
    override init() {
        super.init()
    }
    
}
