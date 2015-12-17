//
//  CCVideoDownModel.swift
//  iCCUT
//
//  Created by Maru on 15/10/17.
//  Copyright © 2015年 Alloc. All rights reserved.
//

import UIKit
import Alamofire

class CCVideoDownModel: NSObject,NSCoding {
    
    // MARK: - Property
    var name: NSString!
    var bytesRead: Int64!
    var totalBytesRead: Int64!
    var totalBytesExpectedToRead: Int64!
    var request: Request?
    var urlString: NSString?
    var precent: Float {
        let precent: Float = Float(totalBytesRead!) / Float(totalBytesExpectedToRead!)
        return precent
    }
    var isDownloading: Bool = true
    var isFinish: Bool = false
    
    // MARK: - Life Cycyle
    override init() {
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeInt64(bytesRead, forKey: "read")
        aCoder.encodeInt64(totalBytesRead, forKey: "totalread")
        aCoder.encodeInt64(totalBytesExpectedToRead, forKey: "totalexpect")
        aCoder.encodeObject(urlString, forKey: "url")
        aCoder.encodeBool(isFinish, forKey: "isfinish")
//        aCoder.encodeObject(request, forKey: "request")
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObjectForKey("name") as! NSString
        self.bytesRead = aDecoder.decodeInt64ForKey("read")
        self.totalBytesRead = aDecoder.decodeInt64ForKey("totalread")
        self.totalBytesExpectedToRead = aDecoder.decodeInt64ForKey("totalexpect")
        self.urlString = aDecoder.decodeObjectForKey("url") as? NSString
        self.isFinish = aDecoder.decodeBoolForKey("isfinish")
//        self.request = aDecoder.decodeObjectForKey("request") as? Request
    }
}
