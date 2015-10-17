
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
    
    private let sectionHeight: CGFloat = 35.0
    /** 下载item */
    var downloadItem: UIBarButtonItem {
        
        let item: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "media_download")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal), style: UIBarButtonItemStyle.Plain, target: self, action: Selector("downloadButtonClick"))
        
        item.imageInsets = UIEdgeInsets(top: 12, left: 10, bottom: 12, right: 10)
        
        return item
    }


    // Life Cycle
    override func viewDidLoad() {
        
        setupData()
        
        setupView()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        setupSetting()
    }
    
    // Private Method
    private func setupView() {
        
        //不显示垂直指示器
        tableView.showsVerticalScrollIndicator = false
        
        
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
    
    // Action
    func downloadButtonClick() {
        
    }
    
    // <TableView DataSource>
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
    
    // <TableView Delegate>
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        let playerController: MRVLCMediaController = MRVLCMediaController()
        
        let dic: NSDictionary = (dataArray?.objectAtIndex(indexPath.row))! as! NSDictionary
        
        let urlString: NSString = dic["url"] as! NSString
        
        playerController.mediaURL = NSURL(string: urlString as String)
        
        let model = CCVideoModel()
        model.name = "测试"
        model.url = urlString as String
        model.sorOne = "1"
        model.sortTwo = "2"
        
        playerController.downloadBlock = ({() in
            print("开始下载")
            
            DownloadTool.shareDownloadTool().downloadResourceToPath(model, index: indexPath)
        })
        
        presentViewController(playerController, animated: true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionHeight
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            let headView: CCMediaSelectView = CCMediaSelectView(frame: CGRectMake(0, 0,SCREEN_BOUNDS.width, sectionHeight))
            headView.dataArray = ["纪录片","学习","影视","动漫","学习","直播","原创"]
            return headView
        }else {
            return nil
        }
        
    }
    
}
