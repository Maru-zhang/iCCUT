//
//  CheetahDownload.swift
//  iCCUT
//
//  Created by Maru on 16/4/25.
//  Copyright © 2016年 Alloc. All rights reserved.
//

import UIKit

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
let mar_RealmQueue = dispatch_queue_create("com.iCCUT.MainQueue", DISPATCH_QUEUE_SERIAL)

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
    /// 缓存列表
    public var modelQueue = [CheetahBaseModel]()
    /// 未完成的任务
    var resumeTask: [NSURLSessionDownloadTask]? {
        let semaphore : dispatch_semaphore_t = dispatch_semaphore_create(0)
        var tasks: [NSURLSessionDownloadTask]?
        sesstion.getTasksWithCompletionHandler { (dataTasks, uploadTasks, downloadTasks) in
            tasks = downloadTasks
            debugPrint(tasks)
            dispatch_semaphore_signal(semaphore)
        }
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
        return tasks
    }
    /// 后台Session
    private var sesstion: NSURLSession!
    
    // MARK: - Life Cycle
    override init() {

        maxWork = 3
        fileManager = NSFileManager.defaultManager()
        downloadFile = fileManager.URLsForDirectory(NSSearchPathDirectory.DownloadsDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask).first
        do {
            try fileManager.createDirectoryAtURL(downloadFile, withIntermediateDirectories: true, attributes: nil)
        }catch let error as NSError {
            debugPrint(error)
        }
        
        super.init()
        
        sesstion = NSURLSession(configuration: NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier("com.alloc.maru"), delegate: self, delegateQueue: nil)
        
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
     根据模型找到映射的Task
     
     - parameter model:	模型
     
     - returns: NSURLSessionDownloadTask
     */
    public func getModelMappingTask(model: CheetahBaseModel) -> NSURLSessionDownloadTask? {
        
        var result: NSURLSessionDownloadTask? = nil
        
        for task in resumeTask! {
            if task.originalRequest?.URL?.absoluteString == model.mar_url {
                result = task
                break
            }
        }
        
        return result
    }
    
    /**
     添加一个下载任务,添加成功返回True，失败返回False
     
     - parameter model:	下载信息模型
     */
    public func appendDownloadTaskWithModel<T: CheetahBaseModel>(model: T) -> Bool {
        
        synchronizeToDiskWithModel(model)
        
        return appendNewModel(model)
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
        
        
    }
    
    
    
    /**
     开始所有的下载任务
     */
    public func startAllTask() {
        
        for task in resumeTask! {
            task.resume()
        }
        
    }
    
    /**
     暂停/取消所有的下载任务
     */
    public func pauseAllTask() {
        
        for task in resumeTask! {
            task.suspend()
        }
        
    }
    
    /**
     重置所有的设置任务
     */
    public func resetAllTask() {
        

    }
    
    // MARK: - Private Method
    
    /**
     从数据库读取的时候，添加一个新的下载模型
     
     - parameter model:	下载模型
     */
    private func appendNewModel(model: CheetahBaseModel) -> Bool {
        
        let new = model as! CCVideoDownModel
        var newTask: NSURLSessionDownloadTask? = nil
        
        for mdl in self.modelQueue {
            let it = mdl as! CCVideoDownModel
            if it.mar_url == new.mar_url {
                debugPrint("\(CheetahUtility.ExceptForeword): same model error.")
                return false
            }
        }
        
        if !new.complete {
            
            for task  in self.resumeTask! {
                if task.originalRequest?.URL?.absoluteString == new.mar_url {
                    // 之前下载过
                    newTask = task
                    break
                }
            }
            
            if newTask == nil {
                newTask = sesstion.downloadTaskWithURL(NSURL(string: new.mar_url!)!)
            }
            
            // 开始下载任务
            newTask?.resume()
            
        }
        
        modelQueue.append(new)
    
        return true
    }
    
    

    
}

// MARK: - NSURLSessionDownloadDelegate
extension CheetahDownload: NSURLSessionDownloadDelegate {
    
    public func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        

        for (index,model) in self.modelQueue.enumerate() {
            
            if model.mar_url == downloadTask.originalRequest?.URL?.absoluteString {
                
                model.complete = true
                model.mar_url = self.downloadFile.URLByAppendingPathComponent((downloadTask.response?.suggestedFilename)!).absoluteString
                synchronizeToDiskWithModel(model)
                // 响应代理
                delegate?.cheetahDownloadDidFinishDownloading(downloadTask, index: Int64(index))
                break
            }
            
        }
        
        // 移动下载结果至指定目录
        do {
            try self.fileManager.moveItemAtURL(location, toURL: self.downloadFile.URLByAppendingPathComponent((downloadTask.response?.suggestedFilename)!))
            debugPrint("Download Success!\(location)")
        }catch let error as NSError {
            debugPrint(error)
        }
    }
    
    public func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        debugPrint(bytesWritten)
        
        for (index,model) in modelQueue.enumerate() {
            
            if model.mar_url == downloadTask.originalRequest?.URL?.absoluteString {
                
                // 计算下载百分比
                let receivedBytesCount = Double(downloadTask.countOfBytesReceived)
                let totalBytesCount = Double(downloadTask.countOfBytesExpectedToReceive)
                let progress = Float(receivedBytesCount / totalBytesCount)
                
                // 计算下载速度
                let speed = Float(bytesWritten)
                
                let info = MARProgressInfo(progress: progress, speed: speed)
                
                delegate?.cheetahDownloadDidUpdate(info, index: Int64(index))
                break
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
        
        
        dispatch_async(mar_RealmQueue) {
            
            debugPrint("\(CheetahUtility.LogForword):read from \(self.downloadFile)!")

//            do {
//                let realm = try Realm()
//                
//                let videos = realm.objects(CCVideoDownModel)
//                
//                self.modelQueue.removeAll()
//                
//                for video in videos {
//                    self.appendNewModel(video)
//                }
//                
//                
//            }catch let error as NSError {
//                debugPrint(error.description)
//            }
            
        }
        
    }
    
    
    /**
     保存所有的下载信息到本地
     */
    public func synchronizeToDiskWithModel(model: AnyObject) {
        
        /*******************************************/
        
        dispatch_async(mar_RealmQueue) {
            
            debugPrint("\(CheetahUtility.LogForword):save to disk!")
            
//            do {
//                let realm = try Realm()
//                realm.beginWrite()
//                realm.add(model,update: true)
//                try! realm.commitWrite()
//                
//            }catch let error as NSError {
//                debugPrint(error)
//            }

        }
        
        
    }
    
    
}


