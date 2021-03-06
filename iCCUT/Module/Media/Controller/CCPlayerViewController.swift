//
//  CCPlayerViewController.swift
//  iCCUT
//
//  Created by Maru on 16/4/28.
//  Copyright © 2016年 Alloc. All rights reserved.
//

import UIKit
import Cartography
import SCLAlertView

class CCPlayerViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    

    /// 视频模型
    var mediaModel: CCVideoModel!
    /// 播放器
    let mr_player: MRVLCPlayer = MRVLCPlayer()
    /// 评论列表
    let comment: UITableView = UITableView()
    /// 评论模型
    var source: [CCComment] = []
    /// 页码
    var page: Int = 0

    
    // MARK: - Initialize
    init(mediaModel: CCVideoModel) {
        super.init(nibName: nil, bundle: nil)
        self.mediaModel = mediaModel
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        
        setupView()
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        self.mr_player.dismiss()
    }
    

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Method
    private func setupView() {
        
        comment.dataSource = self
        comment.delegate  = self
        comment.bouncesZoom = false
        comment.zoomScale = 10
        comment.bounces = false
        comment.showsVerticalScrollIndicator = false
        comment.registerNib(UINib(nibName: String(CCMediaInfoCell),bundle: NSBundle.mainBundle()), forCellReuseIdentifier: String(CCMediaInfoCell))
        comment.registerNib(UINib(nibName: String(CCCommentCell), bundle: NSBundle.mainBundle()), forCellReuseIdentifier: String(CCCommentCell))
        view.addSubview(comment)
        

        mr_player.mediaURL = NSURL(string: (mediaModel.url)!)!
        mr_player.showInView(view)
        mr_player.exitBlock = { self.exit() }
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        mr_player.frame = CGRectMake(0, 0, SCREEN_BOUNDS.width, SCREEN_BOUNDS.width * (9 / 16))
        comment.frame   = CGRectMake(0, SCREEN_BOUNDS.width * (9 / 16), SCREEN_BOUNDS.width, SCREEN_BOUNDS.height - SCREEN_BOUNDS.width * (9 / 16))
        
        fetchComments(true)
        
    }

    // MARK: - Private Method
    func addNewDownloadTask() {
        
        debugPrint("添加新的任务")
        
        let downloader = CheetahDownload.shareInstance()
        let model = CCVideoDownModel()
        
        model.name = mediaModel?.name
        model.mar_url = mediaModel?.url
        model.mar_data = nil
        model.sorOne = mediaModel?.sorOne
        model.sortTwo = mediaModel?.sortTwo
        
        
        if downloader.appendDownloadTaskWithModel(model) {
            SCLAlertView.showPromptView("已添加到下载队列..")
        }else {
            SCLAlertView.showPromptView("该任务正在下载中..")
        }
        
    }

    // MARK: - TextFiled Delegate
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {

        return true
    }
    
    
    // MARK: - Override
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    

}

extension CCPlayerViewController {
    
    // MARK: - Private Method
    
    @objc private func exit() {
        
        if let _ = self.navigationController {
            self.navigationController?.popViewControllerAnimated(true)
        }else {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    
    /**
     传入一个Bool，如果是true那就从头获取数据，否则使用下一页
     
     - parameter flag:	标记
     */
    private func fetchComments(flag: Bool) {
        
        if flag { page = 0 }
        
        CCNetService.fetchCommentList(page, vid: mediaModel.id, success: { [unowned self] (comments) in
            if flag { self.source.removeAll() }
            self.source.appendContentsOf(comments)
            self.comment.reloadData()
            }) { (msg) in
                CCToastService.showNetworkFail()
        }
    }
}


extension CCPlayerViewController {
    
    // MARK: - TableView DataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.tableViewDisplay(emptyMessage: "暂时还没有评论哦，来做沙发吧~", count: source.count)
        if section == 0 {
            return 1
        }else {
            return source.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(String(CCMediaInfoCell), forIndexPath: indexPath) as! CCMediaInfoCell
            cell.mediaName.text = "视频名称:\(mediaModel!.name)"
            cell.download.addTarget(self, action: #selector(addNewDownloadTask), forControlEvents: .TouchUpInside)
            
            return cell
        }else {
            let cell = tableView.dequeueReusableCellWithIdentifier("CCCommentCell", forIndexPath: indexPath) as! CCCommentCell
            cell.username.text = source[indexPath.row].user
            cell.commentTime.text = source[indexPath.row].datetime
            cell.content.text = source[indexPath.row].content
            cell.goodCount.text = String(source[indexPath.row].good)
            return cell
        }
        
    }
    
    // MARK: - TableView Delegate
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let editView = CCEditView(frame: CGRectMake(0, 0, tableView.frame.width, 40))
        
        editView.commentBlock = { [unowned self] textFiled in
            CCNetService.submitComment(self.mediaModel.id, uid: -1, content: textFiled.text!, success: {
                textFiled.text = ""
                CCToastService.showMessage("提交成功")
//                self.fetchComments(true)
                }, fail: { (msg) in
                    CCToastService.showMessage("提交失败")
            })
        }
        
        return editView
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return 40
        }else {
            return 70
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 40
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        UIApplication.sharedApplication().keyWindow?.endEditing(true)
    }
    
}
