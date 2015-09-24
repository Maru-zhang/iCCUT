//
//  DownloadTool.swift
//  iCCUT
//
//  Created by Maru on 15/9/24.
//  Copyright © 2015年 Alloc. All rights reserved.
//

class DownloadTool: NSObject {
    
    /** 后台SesstionID */
    let sessionID = "downloadBG"
    /** 单例对象 */
    static let downloadTool: DownloadTool = DownloadTool()
    /** 下载队列数组 */
    var videoQueue: NSMutableArray {
        return NSMutableArray()
    }
    
    // Life Cycle
    class func shareDownloadTool() -> DownloadTool {
        
        return downloadTool
    }
    
    // Public Method
    func downloadResourceToPath(model: CCVideoModel,filePath: NSURL,index: NSIndexPath) {

        //获取请求
        let request = NSURLRequest(URL: NSURL(string: (model.url)!)!)
        //配置confiure
        let configure = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier(sessionID)
        //配置manager
        let manager = AFURLSessionManager(sessionConfiguration: configure)
        //配置下载任务
        let downloadTask = manager.downloadTaskWithRequest(request, progress: nil, destination: { (url, respones) -> NSURL in
            let finalPath = filePath.URLByAppendingPathComponent(respones.suggestedFilename!)
            return finalPath
            }) { (response, url, downloadError) -> Void in
                

        }
        
        downloadTask.resume()
        
    }
    
}
