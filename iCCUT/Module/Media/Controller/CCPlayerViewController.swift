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
    
    var mediaURL: NSURL! {
        if let model = mediaModel {
            return NSURL(string: model.url)
        }else {
            return self.mediaURL
        }
    }
    var mediaModel: CCVideoModel?
    let mr_player: MRVLCPlayer = MRVLCPlayer()
    let comment: UITableView = UITableView()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        
        setupView()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        mr_player.dismiss()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    init(videoURL: String) {
        super.init(nibName: nil, bundle: nil)
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
        
        mr_player.mediaURL = NSURL(string: (mediaModel?.url)!)!
        mr_player.showInView(view)
        mr_player.exitBlock = { self.exit() }
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        constrain(mr_player, comment) { (player, comment) in
            
            player.top    == (player.superview?.top)!
            player.left   == (player.superview?.left)!
            player.width  == (player.superview?.width)!
            player.height == (player.superview?.width)! * (9/16)
            
            comment.top   == player.bottom
            comment.left  == player.left
            comment.right == player.right
            comment.bottom == (player.superview?.bottom)!
            
        }
        
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
    
    // MARK: - Event
    @objc private func exit() {
        if let _ = self.navigationController {
            self.navigationController?.popViewControllerAnimated(true)
        }else {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
    }
    
    // MARK: - TableView DataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(String(CCMediaInfoCell), forIndexPath: indexPath) as! CCMediaInfoCell
            cell.mediaName.text = "视频名称:\(mediaModel!.name)"
            cell.download.addTarget(self, action: #selector(addNewDownloadTask), forControlEvents: .TouchUpInside)
            
            return cell
        }else {
            let cell = tableView.dequeueReusableCellWithIdentifier("CCCommentCell", forIndexPath: indexPath) as! CCCommentCell
            cell.username.text = "测试用户名"
            cell.commentTime.text = "2016-01-31"
            cell.content.text = "这是测试评论"
            return cell
        }
        
    }
    
    // MARK: - TableView Delegate
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let editView = CCEditView(frame: CGRectMake(0, 0, tableView.frame.width, 40))
        editView.commentBlock = { textFiled in
            debugPrint("提交评论")
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
    
    
    // MARK: - TextFiled Delegate
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {

        return true
    }
    
    
    // MARK: - Override
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    

}
