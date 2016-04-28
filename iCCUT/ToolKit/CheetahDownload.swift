//
//  CheetahDownload.swift
//  iCCUT
//
//  Created by Maru on 16/4/25.
//  Copyright © 2016年 Alloc. All rights reserved.
//

import Foundation

public class CheetahDownload: NSObject,NSURLSessionDownloadDelegate {
    
    public var maxWork: NSInteger!
    private let downloadFile: NSURL!
    private let fileManager: NSFileManager!
    private let userDefault: NSUserDefaults!
    private static let cheetahDownload =  CheetahDownload()
    
    
    /// 任务列表
    lazy var taskQueue: [NSURLSessionDownloadTask] = []
    /// 缓存列表
    var cacheQueue: [String: NSData] = [:]
    
    private var sesstion: NSURLSession! {
        get {
            let config = NSURLSessionConfiguration.defaultSessionConfiguration()
            return NSURLSession(configuration: config, delegate: self, delegateQueue: nil)
        }
    }
    
    // MARK: - Life Cycle
    override init() {
        
        maxWork = 3
        userDefault = NSUserDefaults.standardUserDefaults()
        fileManager = NSFileManager.defaultManager()
        downloadFile = fileManager.URLsForDirectory(NSSearchPathDirectory.DownloadsDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask).first
        do {
            try fileManager.createDirectoryAtURL(downloadFile, withIntermediateDirectories: true, attributes: nil)
        }catch let error as NSError {
            debugPrint(error)
        }
        super.init()
        
    }
    
    // MARK: - Public Method
    public static func shareInstance() -> CheetahDownload {
        
        return cheetahDownload
    }
    
    public func beginDownloadWithModel(model: [String: String]) {
        
        // 解包
        if let downloadURL = model["url"] {
            
            let downloadTask = sesstion.downloadTaskWithURL(NSURL(string: downloadURL)!)
            
            taskQueue.append(downloadTask)
            
            downloadTask.resume()
        }
        
    }
    
    /**
     暂停/取消所有的下载任务
     */
    public func pauseAllTask() {
        
        for task in taskQueue {
            task.cancelByProducingResumeData({ (resumeData) in
                if let request = task.originalRequest {
                    self.cacheQueue[(request.URL?.absoluteString)!] = resumeData
                }
            })
        }
    }
    

    
    // MARK: - NSURLSessionDownloadDelegate
    public func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        do {
            try self.fileManager.moveItemAtURL(location, toURL: self.downloadFile)
        }catch let error as NSError {
            debugPrint(error)
        }
    }
    
}

extension CheetahDownload {

    private static let cacheKey = "com.alloc.maru"
    
    // MARK: - Private Method
    
    /**
     保存所有的下载信息到本地
     */
    private func saveToCache() {
        dispatch_async(dispatch_get_global_queue(0, 0)) {
            
            self.userDefault.setObject(self.cacheQueue, forKey: CheetahDownload.cacheKey)
        }
    }
    
    /**
     从本地读取所有的下载信息
     */
    private func readFromCache() {
        
        dispatch_async(dispatch_get_global_queue(0, 0)) {
            
            if let temp = self.userDefault.objectForKey(CheetahDownload.cacheKey) {
                self.cacheQueue = temp as! [String: NSData]
            }
            
            
        }
    }
    
}