//
//  CCDownloadController.swift
//  iCCUT
//
//  Created by Maru on 15/9/23.
//  Copyright © 2015年 Alloc. All rights reserved.
//  http://202.198.176.113/video/v8/jlp/zjkx/0901.rmvb

import UIKit

class CCDownloadController: UITableViewController {

    /** downloadTool单例 */
    let downloadTool = DownloadTool.shareDownloadTool()
    /** 数据源 */
    var dataSource: NSArray?
    
    let identifier = "downloadCell"
    
    // Life Cycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupView()
    
        //配置下载路径
        var docPth: NSURL?
        
        do {
            try docPth = NSFileManager().URLForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomain: NSSearchPathDomainMask.UserDomainMask, appropriateForURL: nil, create: false)
        }catch {
            
        }
        let videoURL = docPth?.URLByAppendingPathComponent("1.jpg")
        print(videoURL)
        
        
        //配置模型
        let model = CCVideoModel()
        model.name = "海底迷城"
        model.sorOne = "纪录片"
        model.sortTwo = "走近科学"
        model.url = "http://image.baidu.com/search/down?tn=download&word=download&ie=utf8&fr=detail&url=http%3A%2F%2Fpic38.nipic.com%2F20140228%2F5571398_215900721128_2.jpg&thumburl=http%3A%2F%2Fimg4.imgtn.bdimg.com%2Fit%2Fu%3D434281914%2C1810736344%26fm%3D21%26gp%3D0.jpg"
        
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)

        downloadVideoToPath(model, filePath: videoURL!, index: indexPath)
    }
    
    // Private Method
    func downloadVideoToPath(video: CCVideoModel,filePath: NSURL,index: NSIndexPath) {
        //获取显示的slider
//        let cell: CCDownloadCell = tableView.cellForRowAtIndexPath(index) as! CCDownloadCell
//        let slider = cell.videoSlider
        //配置progress
//        let progress = NSProgress()
        //获取请求
        let request = NSURLRequest(URL: NSURL(string: (video.url)!)!)
        //配置confiure
        let configure = NSURLSessionConfiguration.defaultSessionConfiguration()
        //配置manager
        let manager = AFURLSessionManager(sessionConfiguration: configure)
        //配置下载任务
        let downloadTask = manager.downloadTaskWithRequest(request, progress: nil, destination: { (url, request) -> NSURL in
            print(filePath)
            return filePath
            })
            { (response, url, downloadError) -> Void in

        }
        
        downloadTask.resume()
        
    }
    
    // <Private Method>
    private func setupView() {
        
        navigationController?.navigationItem.title = "缓存视频"
        
    }
    // <UITableview Datasource>
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier)
        
        if cell == nil {
            
            cell = CCDownloadCell(style: UITableViewCellStyle.Default, reuseIdentifier: identifier)
        }
        
        return cell!
    }
}
