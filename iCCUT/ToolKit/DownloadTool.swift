//
//  DownloadTool.swift
//  iCCUT
//
//  Created by Maru on 15/9/24.
//  Copyright © 2015年 Alloc. All rights reserved.
//
import Alamofire

protocol DownloadToolProtocol: NSObjectProtocol {
    func downloadTooldidReceiveData()
}

class DownloadTool: NSObject {
    
    /** 声明代理 */
    weak var delegate: DownloadToolProtocol?
    /** 下载队列数组 */
    var videoQueue: NSMutableArray = NSMutableArray()
    /** 单例对象 */
    static let downloadTool: DownloadTool = DownloadTool()
    
    // MARK: - Life Cycle
    class func shareDownloadTool() -> DownloadTool {
        
        return downloadTool
    }
    
    // MARK: - Public Method
    func downloadResourceToPath(model: CCVideoModel,index: NSIndexPath) {
        
        // 排除重复下载
        for item in videoQueue {
            if item.name == model.name {
                return
            }
        }
        
        //创建一个模型实体
        let mdl = CCVideoDownModel()
        mdl.name = model.name
        videoQueue.addObject(mdl)
        
        //一个后台线程
        dispatch_async(dispatch_get_global_queue(0, 0)) { () -> Void in
            let download_request = Alamofire.download(.GET, (model.url)!) { (temporaryURL, response) -> NSURL in
                let temp = (CUR_TIME as String) + "-" +  response.suggestedFilename!
                let finalPath: NSURL = DIR_PATH.URLByAppendingPathComponent(temp)
                mdl.urlString = temp
                self.writeData()
                if DEBUG_LOG {print(finalPath)}
                return finalPath
                }.progress { (bytesRead, totalBytesRead, totalBytesExpectedToRead) -> Void in
                    print(totalBytesRead)
                    mdl.bytesRead = bytesRead
                    mdl.totalBytesRead = totalBytesRead
                    mdl.totalBytesExpectedToRead = totalBytesExpectedToRead
                    if totalBytesRead == totalBytesExpectedToRead {
                        mdl.isFinish = true
                    }
                    self.writeData()
                    guard self.delegate != nil else {
                        return
                    }
                    self.delegate!.downloadTooldidReceiveData()
            }.response(completionHandler: { (request, respones, data, resError) -> Void in
                
                if let error = resError {
                    if DEBUG_LOG {print("下载出错\(error)")}
                }else {
                    if DEBUG_LOG {print("下载成功！")}
                }
                
            })
            
            mdl.videoRequest = download_request
        }

    }
    
    func writeData() {
        
        let tempResultArray = NSMutableArray()
        
        for model in videoQueue {
            let data = NSKeyedArchiver.archivedDataWithRootObject(model)
            tempResultArray.addObject(data)
        }
        
        //不能够直接存储NSMutableArray，必须先转化成NSArray
        let resultArray = NSArray(array: tempResultArray)
        //进行存储
        NSUserDefaults.standardUserDefaults().setObject(resultArray, forKey: KLOCAL_VIDEO)
    }
    
    func readData() {
        
        if DEBUG_LOG { print("readData") }
        
        guard let readArray = NSUserDefaults.standardUserDefaults().objectForKey(KLOCAL_VIDEO) as? NSArray else {
            return
        }
        
        for data in readArray {
            let model = NSKeyedUnarchiver.unarchiveObjectWithData(data as! NSData)
            videoQueue.addObject(model!)
        }
        
    }
    
        
    
}
