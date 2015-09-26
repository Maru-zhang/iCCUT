//
//  CCHTTPClient.swift
//  iCCUT
//
//  Created by Maru on 15/9/26.
//  Copyright © 2015年 Alloc. All rights reserved.
//


class CCHTTPClient: AFHTTPRequestOperationManager {
    
    static let client = AFHTTPRequestOperationManager()
    
    class func getInstance() -> CCHTTPClient {
        return client as! CCHTTPClient
    }

}
