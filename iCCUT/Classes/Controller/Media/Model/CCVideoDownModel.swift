//
//  CCVideoDownModel.swift
//  iCCUT
//
//  Created by Maru on 15/10/17.
//  Copyright © 2015年 Alloc. All rights reserved.
//

import UIKit

class CCVideoDownModel: NSObject {
    var name: NSString?
    var bytesRead: Int64?
    var totalBytesRead: Int64?
    var totalBytesExpectedToRead: Int64?
    var url: NSString?
    var precent: Float {
        let precent: Float = Float(totalBytesRead!) / Float(totalBytesExpectedToRead!)
        return precent
    }
    var isFinish: Bool = false
}
