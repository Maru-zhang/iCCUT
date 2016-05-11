//
//  CheetahDownload.swift
//  iCCUT
//
//  Created by Maru on 16/4/25.
//  Copyright © 2016年 Alloc. All rights reserved.
//

import UIKit
import RealmSwift

/**
 下载器的下载设置状态
 
 - AllDownloading:	全部开始下载
 - AllPausing:		全部一直暂停
 */
enum CheetahState {
    /// 全部开始
    case AllDownloading
    /// 全部暂停
    case AllPausing
}

/**
 *	下载进度更新的模型
 *
 *	@since 1.0
 */
public struct MARProgressInfo {
    var progress: Float = 0.0
    var speed   : Float = 0.0
}

/**
 *	基类所有的属性
 *
 *	@since 1.0
 */
private struct Model_Key {
    static let data = "mar_data"
    static let url  = "mar_url"
}

public protocol CheetahDownloadDelegate: NSObjectProtocol {
    func cheetahDownloadDidUpdate(task: MARProgressInfo,index: Int64)
    func cheetahDownloadDidFinishDownloading(task: NSURLSessionDownloadTask,index: Int64)
}

/// 统一的realm线程，所有的存储相关都在这里操作
//let mar_RealmQueue = dispatch_queue_create("com.iCCUT.MainQueue", dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_UTILITY, 0))
let mar_RealmQueue = dispatch_get_main_queue()

public class CheetahDownload: NSObject {
    
    /// 更新代理
    public weak var delegate: CheetahDownloadDelegate?
    /// 最大并发下载数量
    public var maxWork: NSInteger!
    /// 下载本地目录
    public let downloadFile: NSURL!
    /// 文件管理器
    private let fileManager: NSFileManager!
    /// 单例对象
    private static let cheetahDownload =  CheetahDownload()
    /// 任务列表
    var taskQueue: [NSURLSessionDownloadTask]
    /// 缓存列表
    public var modelQueue = [AnyObject]() {
        
        
        didSet {
            
            taskQueue.removeAll()
            
            for item in modelQueue {
                
                var newTask: NSURLSessionDownloadTask? = nil
                
                let model = item as! CCVideoDownModel
                
                // 判断该模型是否已经下载完毕
                if !model.complete {
                    
                    if self.resumeTask != nil {
                        
                        for task  in self.resumeTask! {
                            if task.originalRequest?.URL?.absoluteString == model.mar_url {
                                // 之前下载过
                                newTask = task
                            }else {
                                // 全新的下载任务
                                newTask = sesstion.downloadTaskWithURL(NSURL(string: model.mar_url!)!)
                            }
                        }
                    }
                    
                    
                }
                
                defer {
                    if !taskQueue.contains(newTask!) && newTask != nil {
                        taskQueue.append(newTask!)
                    }
                }
                
                
            }
            debugPrint("同步...")
        }
    }
    
    var resumeTask: [NSURLSessionDownloadTask]? {
        let semaphore : dispatch_semaphore_t = dispatch_semaphore_create(0)
        var tasks: [NSURLSessionDownloadTask]?
        sesstion.getTasksWithCompletionHandler { (dataTasks, uploadTasks, downloadTasks) in
            tasks = downloadTasks
            dispatch_semaphore_signal(semaphore)
        }
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
        return tasks
    }

    private var sesstion: NSURLSession! {
        get {
            let config = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier("com.alloc.maru")
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
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(synchronizeFromDisk), name: UIApplicationDidFinishLaunchingNotification, object: nil)
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(test), name: UIApplicationWillTerminateNotification, object: nil)
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(synchronizeToDisk), name: UIApplicationDidEnterBackgroundNotification, object: nil)
 
        
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    // MARK: - Public Method
    public static func shareInstance() -> CheetahDownload {
        
        return cheetahDownload
    }
    
    /**
     添加一个下载任务,添加成功返回True，失败返回False
     
     - parameter model:	下载信息模型
     */
    public func appendDownloadTaskWithModel<T: Object>(model: T) -> Bool {
        
        if let newURL = model.valueForKey("mar_url") as? String {
            for task in taskQueue {
                if task.currentRequest?.URL?.absoluteString == newURL {
                    debugPrint("Have same task url in taskQueue!")
                    return false
                }
            }
        }
        
        modelQueue.append(model)
        return true
    }
    
    
    /**
     弹出栈顶下载任务
     */
    public func popCanceledDownloadTask() {
        
        deleteDownloadTask(atIndex: modelQueue.count - 1)
    }
    
    /**
     删除某一个位置的下载任务
     
     - parameter index:	下载任务的位置
     */
    public func deleteDownloadTask(atIndex index: NSInteger) {
        
        let task = taskQueue[index]
        task.cancel()
        modelQueue.popLast()
        
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
        
        modelQueue.removeAll()
        synchronizeToDisk()
    }
    
    // MARK: - Private Method
    
    /**
     添加一个新的下载模型
     
     - parameter model:	下载模型
     */
    private func appendNewModel(model: AnyObject) -> Bool {
        
        let new = model as! CCVideoDownModel
        let newTask: NSURLSessionDownloadTask?
        
        for mdl in self.modelQueue {
            let it = mdl as! CCVideoDownModel
            if it.mar_url == new.mar_url {
                debugPrint("\(CheetahUtility.ExceptForeword): same model error.")
                return false
            }
        }
        
        if !new.complete {
            
            if self.resumeTask != nil {
                
                for task  in self.resumeTask! {
                    if task.originalRequest?.URL?.absoluteString == new.mar_url {
                        // 之前下载过
                        newTask = task
                    }else {
                        // 全新的下载任务
                        newTask = sesstion.downloadTaskWithURL(NSURL(string: )
                    }
                }
            }
            
            
        }
        
        
        return true
    }
    
    

    
}

// MARK: - NSURLSessionDownloadDelegate
extension CheetahDownload: NSURLSessionDownloadDelegate {
    
    public func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {

        // 响应代理
        delegate?.cheetahDownloadDidFinishDownloading(downloadTask, index: Int64(taskQueue.indexOf(downloadTask)!))
        
        // 移动下载结果至指定目录
        do {
            try self.fileManager.moveItemAtURL(location, toURL: self.downloadFile.URLByAppendingPathComponent((downloadTask.response?.suggestedFilename)!))
            debugPrint("Download Success!\(location)")
        }catch let error as NSError {
            debugPrint(error)
        }
    }
    
    public func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        for (index,task) in taskQueue.enumerate() {
            if task.isEqual(downloadTask) {
                
                // 计算下载百分比
                let receivedBytesCount = Double(downloadTask.countOfBytesReceived)
                let totalBytesCount = Double(downloadTask.countOfBytesExpectedToReceive)
                let progress = Float(receivedBytesCount / totalBytesCount)
                
                // 计算下载速度
                let speed = Float(bytesWritten)
                
                let info = MARProgressInfo(progress: progress, speed: speed)
                
                delegate?.cheetahDownloadDidUpdate(info, index: Int64(index))
            }
        }
        
    }

    
    
}

extension CheetahDownload {

    private static let cacheKey = "com.alloc.maru"
    

    /**
     从本地读取所有的下载信息
     */
    public func synchronizeFromDisk() {
        
        
        dispatch_async(dispatch_get_main_queue()) {
            
            debugPrint("\(CheetahUtility.LogForword):Read from disk!")
            
            debugPrint(self.downloadFile)
            
            do {
                let realm = try Realm()
                
                let videos = realm.objects(CCVideoDownModel)
                
                self.modelQueue.removeAll()
                
                for video in videos {
                    self.modelQueue.append(video)
                }
                
            }catch let error as NSError {
                debugPrint(error.description)
            }
            
        }
        
        
        
    }
    
    /**
     保存所有的下载信息到本地
     */
    public func synchronizeToDisk() {
        
        /*******************************************/
        
        dispatch_async(dispatch_get_main_queue(), {
            
            debugPrint("\(CheetahUtility.LogForword):save to disk!")
            
            for (index,task) in self.taskQueue.enumerate() {
                task.cancelByProducingResumeData({ (resumeData) in
                    
                    let newItem = self.modelQueue[index] as! CCVideoDownModel
                    
                    if let data = resumeData {
                        newItem.mar_data = data
                    }
                    
                    do {
                        let realm = try Realm()
                        
                        try realm.write({
                            realm.add(newItem, update: true)
                        })
                    }catch let error as NSError {
                        debugPrint(error.description)
                    }
                    
                })
                
            }

        })
        


        
    }
    
    
}


