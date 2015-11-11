
//
//  CCMediaListController.swift
//  iCCUT
//
//  Created by Maru on 15/9/20.
//  Copyright © 2015年 Alloc. All rights reserved.
//

import UIKit

class CCMediaListController: UITableViewController {
    
    
    let identifier = "mediaListCell"
    
    var dataArray: NSArray?
    /** 选择视图 */
    var sortView: CCSortView = CCSortView()
    /** 标题视图 */
    var sortButton: UIButton {
        //配置导航栏中间的titleView
        let s = UIButton(type: .System)
        s.adjustsImageWhenHighlighted = false
        s.userInteractionEnabled = true
        s.backgroundColor = UIColor.clearColor()
        s.setTitle("分类", forState: .Normal)
        s.setTitle("分类", forState: .Selected)
        s.frame = CGRectMake(0, 0, 60, 40)
        s.addTarget(self, action: Selector("sortViewAction:"), forControlEvents: UIControlEvents.TouchDown)
        return s
    }
    /** 下载item */
    var downloadItem: UIBarButtonItem {
        
        let item: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "media_download")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal), style: UIBarButtonItemStyle.Plain, target: self, action: Selector("downloadButtonClick"))
        
        item.imageInsets = UIEdgeInsets(top: 12, left: 10, bottom: 12, right: 10)
        
        return item
    }


    // MARK: - Life Cycle
    override func viewDidLoad() {
        
        setupData()
        
        setupView()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        setupSetting()
    }
    
    // MARK: -  Private Method
    private func setupView() {
        
        //不显示垂直指示器
        tableView.showsVerticalScrollIndicator = false
        //添加分类按钮
        self.navigationItem.titleView = sortButton
        //添加选择视图
        sortView.frame = CGRectMake(0, 0, SCREEN_BOUNDS.width, 300)
        
    }
    
    private func setupData() {
        
        dataArray = NSArray(contentsOfURL: NSBundle.mainBundle().URLForResource("localPlist", withExtension: "plist")!)
    }
    
    private func setupSetting() {
        
        //设置Tabbar文字
        tabBarController?.navigationItem.title = tabBarItem.title
        //设置item
        tabBarController?.navigationItem.rightBarButtonItem = downloadItem
    }
    
    // MARK: - Action
    func downloadButtonClick() {
        
    }
    
    
    func sortViewAction(sender: UIButton) {
        
        if sender.selected == true {
            sender.selected = false
            sortView.removeFromSuperview()
            tableView.userInteractionEnabled = true
            sortView.userInteractionEnabled = true
            
        }else {
            sender.selected = true
            tableView.addSubview(sortView)
            tableView.userInteractionEnabled = true
            sortView.userInteractionEnabled = true
        }
    }
    
    
    // MARK: - TableView DataSource
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (dataArray?.count)!
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier)
        
        if ((cell) == nil) {
            
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: identifier)
        }
        
        let dic: NSDictionary = (dataArray?.objectAtIndex(indexPath.row))! as! NSDictionary
        
        let name: String = dic["name"] as! String
        let url: String = dic["url"] as! String
        
        cell?.textLabel?.text = name
        cell?.detailTextLabel?.text = url
        
        return cell!
    }
    
    
    // MARK: - TableView Delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        let playerController: MRVLCMediaController = MRVLCMediaController()
        
        //取出模型字典
        let dic: NSDictionary = (dataArray?.objectAtIndex(indexPath.row))! as! NSDictionary
        
        //创建一个模型
        let model: CCVideoModel = CCVideoModel()
        
        //配置一个模型
        model.configureWithDic(dic)
        
        //从模型中取出数据赋值
        playerController.mediaURL = NSURL(string: model.url!)
        
        playerController.downloadBlock = ({() in
            print("开始下载")
            
            DownloadTool.shareDownloadTool().downloadResourceToPath(model, index: indexPath)
        })
        
        presentViewController(playerController, animated: true, completion: nil)
    }
    
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
    }
    
    
}
