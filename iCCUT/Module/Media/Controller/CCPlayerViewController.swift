//
//  CCPlayerViewController.swift
//  iCCUT
//
//  Created by Maru on 16/4/28.
//  Copyright © 2016年 Alloc. All rights reserved.
//

import UIKit
import Cartography

class CCPlayerViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    
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
        let containView = UIView()
        let textField = UITextField()
        textField.borderStyle = .RoundedRect
        textField.placeholder = "我来说几句"
        textField.delegate = self
        textField.center = CGPointMake(tableView.bounds.width / 2, 20)
        textField.bounds = CGRectMake(0, 0, tableView.bounds.width - 10, 30)
        containView.backgroundColor = UIColor.whiteColor()
        containView.addSubview(textField)
        return containView
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
    
    
    // MARK: - TextFiled Delegate
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        let editVC = UIStoryboard(name: "Common", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier(String(CCEditViewController))
        
        presentViewController(editVC, animated: true, completion: nil)
        
        return false
    }
    
    
    // MARK: - Override
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    

}
