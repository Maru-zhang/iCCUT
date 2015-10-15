//
//  DownloadTool.swift
//  iCCUT
//
//  Created by Maru on 15/9/24.
//  Copyright © 2015年 Alloc. All rights reserved.
//

class DownloadTool: NSObject {
    
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
    var videoQueue: NSMutableArray {
        return NSMutableArray()
    }
    
    // Life Cycle
    class func shareDownloadTool() -> DownloadTool {
        
        return downloadTool
    }
    
    // Public Method
    func downloadResourceToPath(model: CCVideoModel,index: NSIndexPath) {

        print(model.url)
        //获取请求
        let request = NSURLRequest(URL: NSURL(string: (model.url)!)!)
        //配置confiure
        let configure = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier((model.url)!)
        //配置manager
        let manager = AFURLSessionManager(sessionConfiguration: configure)
        //配置下载任务
        let downloadTask = manager.downloadTaskWithRequest(request, progress: nil, destination: { (url, respones) -> NSURL in
            print("正在下载....")
            let finalPath: NSURL = self.filePath.URLByAppendingPathComponent(respones.suggestedFilename!)
            return finalPath
            }) { (response, url, downloadError) -> Void in
                

        }
        //最终的沙盒存储地址
        print(filePath)
        //开始下载任务
        downloadTask.resume()
        
    }
    
}
