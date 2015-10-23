//
//  CCDownloadController.swift
//  iCCUT
//
//  Created by Maru on 15/9/23.
//  Copyright © 2015年 Alloc. All rights reserved.
//  http://202.198.176.113/video/v8/jlp/zjkx/0901.rmvb

import UIKit

class CCDownloadController: UITableViewController,DownloadToolProtocol {

    /** downloadTool单例 */
    let downloadTool = DownloadTool.shareDownloadTool()
    /** 数据源 */
    var dataSource: NSMutableArray = DownloadTool.shareDownloadTool().videoQueue
    /** Cell唯一标示 */
    let identifier = "downloadCell"
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupView()
        
        setupSetting()
        
    }
    
    // MARK: - Private Method
    private func setupView() {
        
        navigationController?.navigationItem.title = "缓存视频"
    }
    
    private func setupSetting() {
        downloadTool.delegate = self
    }
    
    // MARK: - UITableview Datasource
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier)
        
        if cell == nil {
            
            cell = CCDownloadCell(style: UITableViewCellStyle.Default, reuseIdentifier: identifier)
        }
        
        let model = dataSource[indexPath.row] as! CCVideoDownModel
        (cell as! CCDownloadCell).progressBar.progress = model.precent
        (cell as! CCDownloadCell).progressLable.text = "\(Int(model.precent * 100))%"
        (cell as! CCDownloadCell).videoName.text = model.name as String
        
        return cell!
    }
    

    // MARK: - UITableView Delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let model: CCVideoDownModel = dataSource[indexPath.row] as! CCVideoDownModel
        
        guard model.isFinish else {
            return
        }
        
        let player = MRVLCMediaController()
        player.mediaURL = DIR_PATH.URLByAppendingPathComponent(model.urlString as! String)
        presentViewController(player, animated: true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .Delete
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let model = downloadTool.videoQueue[indexPath.row] as! CCVideoDownModel
            //删除本地视频
            if model.isFinish {
                do {
                    try NSFileManager.defaultManager().removeItemAtURL(DIR_PATH.URLByAppendingPathComponent(model.urlString as! String))
                }catch {
                    if DEBUG_LOG {print("删除失败!")}
                }
            }
            //从队列中删除
            downloadTool.videoQueue.removeObjectAtIndex(indexPath.row)
            //本地化队列
            downloadTool.writeData()
            tableView.reloadData()
            if DEBUG_LOG {print(downloadTool.videoQueue)}
        }
    }
    
    override func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        return "删除视频"
    }
    

    // MARK: - DownloadProtocol
    func downloadTooldidReceiveData() {
        /* 异步队列主线程 */
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            for (index,model) in self.dataSource.enumerate() {
                let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0)) as! CCDownloadCell
                let tempModel = model as! CCVideoDownModel
                cell.progressBar.progress = tempModel.precent
                cell.progressLable.text = "\(Int(tempModel.precent * 100))%"
            }
        }
    }
}
