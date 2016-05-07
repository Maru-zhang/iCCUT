//
//  CheetahDownload.swift
//  iCCUT
//
//  Created by Maru on 16/4/25.
//  Copyright © 2016年 Alloc. All rights reserved.
//

import UIKit
import RealmSwift


public class CheetahDownload: NSObject {
    
    /// 最大并发下载数量
    public var maxWork: NSInteger!
    /// 下载进度回调闭包
    public var progressBlock: ((NSURLSessionDownloadTask,Float) -> Void)?
    /// 下载本地目录
    private let downloadFile: NSURL!
    private let fileManager: NSFileManager!
    private static let cheetahDownload =  CheetahDownload()
    private struct Model_Key {
        static let data = "mar_data"
        static let url  = "mar_url"
    }
    
    /// 任务列表
    var taskQueue: [NSURLSessionDownloadTask]
    
    /// 缓存列表
    public var itemQueue = [AnyObject]() {
        didSet {
            taskQueue.removeAll()
            for item in itemQueue {
                var task: NSURLSessionDownloadTask? = nil

                if let resumeData = item.valueForKey(Model_Key.data) as? NSData {
                    task = sesstion.downloadTaskWithResumeData(resumeData)
                }else {
                    task = sesstion.downloadTaskWithURL(NSURL(string: item.valueForKey(Model_Key.url) as! String)!)
                };
                
                defer {
                    if !taskQueue.contains(task!) && task != nil {
                        taskQueue.append(task!)
                    }
                }
            }
            debugPrint("同步了。。")
        }
    }

    private var sesstion: NSURLSession! {
        get {
            let config = NSURLSessionConfiguration.defaultSessionConfiguration()
            return NSURLSession(configuration: config, delegate: self, delegateQueue: nil)
        }
    }
    
    // MARK: - Life Cycle
    override init() {
        
        maxWork = 3
        taskQueue = [NSURLSessionDownloadTask]()
        fileManager = NSFileManager.defaultManager()
        downloadFile = fileManager.URLsForDirectory(NSSearchPathDirectory.DownloadsDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask).first
        do {
            try fileManager.createDirectoryAtURL(downloadFile, withIntermediateDirectories: true, attributes: nil)
        }catch let error as NSError {
            debugPrint(error)
        }
        
        super.init()
        
        // setup notification
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(synchronizeFromDisk), name: UIApplicationDidBecomeActiveNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(synchronizeToDisk), name: UIApplicationDidEnterBackgroundNotification, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: - Public Method
    public static func shareInstance() -> CheetahDownload {
        
        return cheetahDownload
    }
    
    /**
     添加一个下载任务
     
     - parameter model:	下载信息模型
     */
    public func appendDownloadTaskWithModel<T: Object>(model: T) {
        
        if let newURL = model.valueForKey("mar_url") as? String {
            for task in taskQueue {
                if task.currentRequest?.URL?.absoluteString == newURL {
                    debugPrint("Have same task url in taskQueue!")
                    return
                }
            }
        }
        
        itemQueue.append(model)
    }
    
    /**
     弹出栈顶下载任务
     */
    public func popCanceledDownloadTask() {
        
        deleteDownloadTask(atIndex: itemQueue.count - 1)
    }
    
    /**
     删除某一个位置的下载任务
     
     - parameter index:	下载任务的位置
     */
    public func deleteDownloadTask(atIndex index: NSInteger) {
        
        let task = taskQueue[index]
        task.cancel()
        itemQueue.popLast()
        
    }
    
    
    
    /**
     开始所有的下载任务
     */
    public func startAllTask() {
        
        for task in taskQueue {
            task.resume();
        }
    }
    
    /**
     暂停/取消所有的下载任务
     */
    public func pauseAllTask() {
        
        for task in taskQueue {
            task.suspend()
        }
        
        
    }
    
    /**
     重置所有的设置任务
     */
    public func resetAllTask() {
        
        for task in taskQueue {
            task.cancel()
        }
        
        itemQueue.removeAll()
        synchronizeToDisk()
    }
    

    
}

// MARK: - NSURLSessionDownloadDelegate
extension CheetahDownload: NSURLSessionDelegate {
    
    public func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        do {
            try self.fileManager.moveItemAtURL(location, toURL: self.downloadFile.URLByAppendingPathComponent((downloadTask.response?.suggestedFilename)!))
            debugPrint("Download Success!\(location)")
        }catch let error as NSError {
            debugPrint(error)
        }
    }
    
    public func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        if let configProgress = progressBlock {
            dispatch_async(dispatch_get_main_queue(), {
                let precent = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
                configProgress(downloadTask, precent)
                debugPrint(precent)
            })
        }
    }
}

extension CheetahDownload {

    private static let cacheKey = "com.alloc.maru"
    
    // MARK: - Private Method
    
    /**
     保存所有的下载信息到本地
     */
    public func synchronizeToDisk() {
        
        debugPrint("save to disk!")

        /*******************************************/
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
            
            for task in self.taskQueue {
                task.cancelByProducingResumeData({ (resumeData) in
                    
                    if let data = resumeData {
                        
                        let realm = try! Realm()
                        
                        let newItem = CCVideoDownModel()
                        newItem.mar_url = (task.originalRequest?.URL?.absoluteString)!
                        newItem.mar_data = data
                        
                        try! realm.write({
                            realm.add(newItem, update: true)
                        })
                    }
                })
                
            }
        }

    }
    
    /**
     从本地读取所有的下载信息
     */
    public func synchronizeFromDisk() {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            
            debugPrint(self.downloadFile)
            
            let realm = try! Realm()
            
            let videos = realm.objects(CCVideoDownModel)

            self.itemQueue.removeAll()
            
            for video in videos {
                self.itemQueue.append(video)
            }
            
        }
    }
    
}
