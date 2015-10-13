//
//  CCNewsController.swift
//  iCCUT
//
//  Created by Maru on 15/9/22.
//  Copyright © 2015年 Alloc. All rights reserved.
//

import UIKit

class CCNewsController: UITableViewController,CirCleViewDelegate {

    
    /** header高度 */
    let headerH: CGFloat = 150
    /** 图片数组 */
    var imgArray = NSMutableArray()
    /** 标记 */
    let identifer = "newsCell"

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        setupSetting()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    /* Private Method */
    func setupSetting() {
        
        //设置控制器标题
        tabBarController?.navigationItem.title = tabBarItem.title
        //item消失
        tabBarController?.navigationItem.rightBarButtonItem = nil
        
        //隐藏滚动条
        tableView.showsVerticalScrollIndicator = false
    }
    
    
    /* <Tableview Datasource> */
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier(identifer)
        
        if cell == nil {
            cell = CCNewsTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: identifer)
        }
        
        
        return cell!
    }
    
    /* <TableView Delegate> */
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerH
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView: CirCleView = CirCleView(frame: CGRectMake(0, 0, SCREEN_BOUNDS.width, headerH), imageArray: [UIImage(named: "1"),UIImage(named: "2"),UIImage(named: "3")])
        
        headerView.delegate = self
        
        return headerView
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 60
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let webController: CCShowNewsController = UIStoryboard(name: "Common", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("webBrowse") as! CCShowNewsController
        
        webController.contentURL = NSURL(string: "http://news.ccut.edu.cn/article.php?/4728.html")

        navigationController?.pushViewController(webController, animated: true)
        
    }
    
    /* CirCleViewDelegate */

    

}
