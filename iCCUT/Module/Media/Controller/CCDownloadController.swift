//
//  CCDownloadController.swift
//  iCCUT
//
//  Created by Maru on 15/9/23.
//  Copyright © 2015年 Alloc. All rights reserved.

import UIKit
import Alamofire
import SCLAlertView

class CCDownloadController: UITableViewController,CheetahDownloadDelegate {

    let downloader = CheetahDownload.shareInstance()

    /** 数据源 */
    var dataSource: NSMutableArray = NSMutableArray()
    /** Cell唯一标示 */
    let identifier = "downloadCell"
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupView()
        
        setupSetting()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        
    }
    
    // MARK: - Private Method
    private func setupView() {
        
        navigationController?.navigationItem.title = "缓存视频"
    }
    
    private func setupSetting() {
        
        CheetahDownload.shareInstance().delegate = self
    }
    
    // MARK: - UITableview Datasource

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.tableViewDisplay(emptyMessage: "暂时没有任何的缓存视频！", count: downloader.modelQueue.count)
        return downloader.modelQueue.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? CCDownloadCell
        
        if cell == nil {
            
            cell = CCDownloadCell(style: UITableViewCellStyle.Default, reuseIdentifier: identifier)
        }
        
        cell?.selectionStyle = .None

        // 获取模型
        let model = downloader.modelQueue[indexPath.row] as! CCVideoDownModel
        
        // 配置模型
        cell!.videoName.text = model.name
        if model.complete {
            cell?.progressLable.text = "100%"
            cell?.progressBar.progress = 1.0
            cell?.setStatus(.Finish)
        }else {
            cell?.progressLable.text = "正在计算中"
            cell?.progressBar.progress = 0.0
        }
        
        return cell!
    }
    

    // MARK: - UITableView Delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let model = downloader.modelQueue[indexPath.row]
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! CCDownloadCell
        
        if model.complete {
            
            //已经下载完毕
            
            dispatch_async(dispatch_get_main_queue(), {
                let model = self.downloader.modelQueue[indexPath.row] as! CCVideoDownModel
                let newModek = CCVideoModel()
                newModek.name = model.name
                newModek.url = model.mar_url
                newModek.sorOne = model.sorOne
                newModek.sortTwo = model.sortTwo
                self.navigationController?.pushViewController(CCPlayerViewController(mediaModel: newModek), animated: true)
            })
        }else {
            
            if let task = downloader.getModelMappingTask(model) {
                // 存在对应的Task
                if task.state == .Running {
                    task.suspend()
                    dispatch_async(dispatch_get_main_queue(), {
                        cell.setStatus(.Pause)
                    })
                }else if task.state == .Suspended {
                    task.resume()
                    dispatch_async(dispatch_get_main_queue(), {
                        cell.setStatus(.Loading)
                    })
                }
                
            }
        }
        


    }
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .Delete
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {

    }
    
    override func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        return "删除视频"
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let maskView = UIView()
        maskView.backgroundColor = UIColor.lightGrayColor()
        return maskView
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.5
    }
    
    // MARK: - CheetahDownload Delegate
    func cheetahDownloadDidUpdate(task: MARProgressInfo,index: Int64) {
        
        dispatch_async(dispatch_get_main_queue()) {
            
            if let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: Int(index), inSection: 0)) as? CCDownloadCell {
                cell.progressLable.text = String(format: "%.2f%%",task.progress)
                cell.progressBar.progress = task.progress
            }
        }
        
        debugPrint("正在下载:\(task.progress)")
    }
    
    func cheetahDownloadDidFinishDownloading(task: NSURLSessionDownloadTask, index: Int64) {
        
        dispatch_async(dispatch_get_main_queue()) {
            
            if let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: Int(index), inSection: 0)) as? CCDownloadCell {
                cell.progressLable.text = "100%"
                cell.progressBar.progress = 1.0
                cell.setStatus(.Finish)
            }
        }
    }
    


    
}
