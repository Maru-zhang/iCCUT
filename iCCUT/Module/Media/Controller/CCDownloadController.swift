//
//  CCDownloadController.swift
//  iCCUT
//
//  Created by Maru on 15/9/23.
//  Copyright © 2015年 Alloc. All rights reserved.
//  http://202.198.176.113/video/v8/jlp/zjkx/0901.rmvb

import UIKit
import Alamofire
import SCLAlertView

class CCDownloadController: UITableViewController {

    /** 下载器 */
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
    
    // MARK: - Private Method
    private func setupView() {
        
        navigationController?.navigationItem.title = "缓存视频"
    }
    
    private func setupSetting() {
        
        downloader.progressBlock = { [unowned self] task,progress in
            
            let index = self.downloader.taskQueue.indexOf(task)
            
            let cell  = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index!, inSection: 0)) as! CCDownloadCell
            
            if task.state == .Completed {
                cell.setStatus(.Finish)
            }else {
                cell.progressLable.text = String(progress)
                cell.progressBar.progress = progress
            }
            
        }
    }
    
    // MARK: - UITableview Datasource

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.tableViewDisplay(emptyMessage: "暂时没有任何的缓存视频！", count: downloader.itemQueue.count)
        return downloader.itemQueue.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? CCDownloadCell
        
        if cell == nil {
            
            cell = CCDownloadCell(style: UITableViewCellStyle.Default, reuseIdentifier: identifier)
        }
        
        //获取模型
        let model = downloader.itemQueue[indexPath.row] as! CCVideoDownModel
        
        //配置模型
        cell!.videoName.text = model.name
        
        return cell!
    }
    

    // MARK: - UITableView Delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! CCDownloadCell
        cell.selected = false
        
//        // 获取离线视频模型
//        let model: CCVideoDownModel = dataSource[indexPath.row] as! CCVideoDownModel
        
        downloader.startAllTask()
        
        
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
    

    
}
