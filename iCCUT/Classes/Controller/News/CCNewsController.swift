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
    /** 新闻数组 */
    var newsArray = NSArray()
    /** 标记 */
    let identifer = "newsCell"

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        setupView()
        
        setupData()
        
        setupSetting()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    /* Private Method */
    func setupView() {
        
        tableView.header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
            self.loadMoreData()
        })
        
        tableView.header.beginRefreshing()
        
    }
    
    func setupSetting() {
        
        //设置控制器标题
        tabBarController?.navigationItem.title = tabBarItem.title
        //item消失
        tabBarController?.navigationItem.rightBarButtonItem = nil
        
        //隐藏滚动条
        tableView.showsVerticalScrollIndicator = false
    }
    
    func setupData() {
        
        let testDataURL = NSBundle.mainBundle().URLForResource("NewsPlist", withExtension: "plist")
        let testData = NSArray(contentsOfURL: testDataURL!)
        newsArray = testData!
    }
    
    /* Action */
    func loadMoreData() {
        
        NSThread.sleepForTimeInterval(1)
        
        tableView.header.endRefreshing()
    }
    
    
    /* <Tableview Datasource> */
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: CCNewsTableViewCell? = tableView.dequeueReusableCellWithIdentifier(identifer) as? CCNewsTableViewCell
        
        
        if cell == nil {
            cell = CCNewsTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: identifer)
        }
        
        let dic = newsArray[indexPath.row]
        
        cell?.title.text = dic["title"] as? String
        cell?.time.text = dic["time"] as? String
        
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
        
        let dic = newsArray[indexPath.row]
        
        webController.contentURL = NSURL(string: (dic["url"] as? String)!)

        navigationController?.pushViewController(webController, animated: true)
        
    }
    
    /* CirCleViewDelegate */

    

}
