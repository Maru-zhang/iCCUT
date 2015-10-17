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
    /** 进度字典 */
    let progressDic = NSMutableDictionary()
    /** 后台SesstionID */
    let sessionID = "download"
    /** 单例对象 */
    static let downloadTool: DownloadTool = DownloadTool()
    /** 默认的沙盒下载地址 */
    var filePath: NSURL{
        var temp: NSURL?
        do {
            temp = try NSFileManager().URLForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomain: NSSearchPathDomainMask.UserDomainMask, appropriateForURL: nil, create: true)
        }catch {
            
        }
         return temp!
    }
    /** 下载队列数组 */
    var videoQueue: NSMutableArray = NSMutableArray()
    
    // Life Cycle
    class func shareDownloadTool() -> DownloadTool {
        
        return downloadTool
    }
    
    // Public Method
    func downloadResourceToPath(model: CCVideoModel,index: NSIndexPath) {
        
        //创建一个模型实体
        let mdl = CCVideoDownModel()
        mdl.name = model.name
        videoQueue.addObject(mdl)
        
        //一个后台线程
        dispatch_async(dispatch_get_global_queue(0, 0)) { () -> Void in
            Alamofire.download(.GET, (model.url)!) { (temporaryURL, response) -> NSURL in
                let finalPath: NSURL = self.filePath.URLByAppendingPathComponent(response.suggestedFilename!)
                mdl.url = finalPath.absoluteString
                print(self.filePath)
                return finalPath
                }.progress { (bytesRead, totalBytesRead, totalBytesExpectedToRead) -> Void in
                    print(totalBytesRead)
                    mdl.bytesRead = bytesRead
                    mdl.totalBytesRead = totalBytesRead
                    mdl.totalBytesExpectedToRead = totalBytesExpectedToRead
                    if totalBytesRead == totalBytesExpectedToRead {
                        mdl.isFinish = true
                    }
                    guard self.delegate != nil else {
                        return
                    }
                    self.delegate!.downloadTooldidReceiveData()
            }
        }

    }
    
        
    
}
