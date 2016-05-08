//
//  CheetahUtility.swift
//  iCCUT
//
//  Created by Maru on 16/5/8.
//  Copyright © 2016年 Alloc. All rights reserved.
//

import Foundation

public class CheetahUtility {
    
    public static let ExceptForeword = "com.Cheetah.Exception"
    public static let LogForword     = "com.Cheetah.Log"
    
    /**
     计算文件数据大小
     
     - parameter contentLength:	字节长度
     
     - returns: 合适的单精度数据
     */
    public static func calculateFileSizeInUnit(contentLength : Int64) -> Float {
        let dataLength : Float64 = Float64(contentLength)
        if dataLength >= ( 1024.0 * 1024.0 * 1024.0 ) {
            return Float(dataLength / (1024.0 * 1024.0 * 1024.0))
        } else if dataLength >= 1024.0 * 1024.0 {
            return Float(dataLength / (1024.0 * 1024.0))
        } else if dataLength >= 1024.0 {
            return Float(dataLength / 1024.0)
        } else {
            return Float(dataLength)
        }
    }
    
    /**
     计算应该使用什么单位
     
     - parameter contentLength:	字节长度
     
     - returns: 返回的合适单位
     */
    public static func calculateUnit(contentLength : Int64) -> String {
        if(contentLength >= ( 1024*1024*1024 )) {
            return "GB"
        } else if contentLength >= ( 1024*1024 ) {
            return "MB"
        } else if contentLength >= 1024 {
            return "KB"
        } else {
            return "Bytes"
        }
    }
    
    /**
     获取空余的磁盘空间量
     
     - returns: 剩余的磁盘空间字节长度
     */
    public static func getFreeDiskspace() -> Int64? {
        let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let systemAttributes: AnyObject?
        do {
            systemAttributes = try NSFileManager.defaultManager().attributesOfFileSystemForPath(documentDirectoryPath.last!)
            let freeSize = systemAttributes?[NSFileSystemFreeSize] as? NSNumber
            return freeSize?.longLongValue
        } catch let error as NSError {
            print("Error Obtaining System Memory Info: Domain = \(error.domain), Code = \(error.code)")
            return nil;
        }
    }
}