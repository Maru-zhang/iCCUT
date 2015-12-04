//
//  CCNewsController.swift
//  iCCUT
//
//  Created by Maru on 15/9/22.
//  Copyright © 2015年 Alloc. All rights reserved.
//

import UIKit
import Alamofire

class CCNewsController: UITableViewController,CirCleViewDelegate {

    /// 分页页码
    var pageIndex: NSInteger = 0
    /// 新闻数据源
    let dataSource = NSMutableArray()
    /** header高度 */
    let headerH: CGFloat = 150
    /** 图片数组 */
    var imgArray = NSMutableArray()
    /** 标记 */
    let identifer = "newsCell"

    // MARK: - Life cycle
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
    
    // MARK: - Private Method
    func setupView() {
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
            self.loadMoreData(true)
        })
        tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { () -> Void in
            self.loadMoreData(false)
        })
        
        tableView.backgroundView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("clearAction")))
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
        
        self.loadMoreData(true)
    }
    
    // MARK: - Action
    func loadMoreData(isSetup: Bool) {
        
        // 是否需要初始化
        if isSetup {
            self.pageIndex = 0
        }
        
        let parmeter = ["index": pageIndex]
        
        Alamofire.request(.POST, "\(HOST)/iCCUT/NewsList",parameters:parmeter,encoding: .URLEncodedInURL)
            .responseJSON { (response) -> Void in
                
                if isSetup {
                    self.dataSource.removeAllObjects()
                }
            
                switch response.result {
                    
                case .Success:
                    
                    let json = JSON(response.result.value!)
                    
                    debugPrint(json)
                    
                    for (_,itemJson) in json["datas"] {
                        // 遍历添加数据
                        let newsModel: NewsModel = NewsModel()
                        newsModel.title = itemJson["title"].stringValue
                        newsModel.url = itemJson["url"].stringValue
                        newsModel.time = itemJson["time"].stringValue
                        self.dataSource.addObject(newsModel)
                        
                    }
                    
                    // 刷新
                    self.tableView.reloadData()
                    self.tableView.mj_header.endRefreshing()
                    self.tableView.mj_footer.endRefreshing()
                    
                    self.pageIndex++
                    
                    break
                case .Failure:
                    self.tableView.mj_header.endRefreshing()
                    self.tableView.mj_footer.endRefreshing()
                    break
                }
        }

    }
    
    func clearAction() {
        UIApplication.sharedApplication().keyWindow?.endEditing(true)
    }
    
    
    // MARK: - Tableview Datasource
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.tableViewDisplay(emptyMessage: "没有更多的通知哦，刷新试试看！", count: dataSource.count)
        return dataSource.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: CCNewsTableViewCell? = tableView.dequeueReusableCellWithIdentifier(identifer) as? CCNewsTableViewCell
        
        if cell == nil {
            cell = CCNewsTableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: identifer)
        }
        
        let model: NewsModel = dataSource[indexPath.row] as! NewsModel
        
        debugPrint(model.time)
        
        cell?.title.text = model.title
        cell?.time.text = model.time
        
        return cell!
    }
    
    /* <TableView Delegate> */
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerH
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView: CirCleView = CirCleView(frame: CGRectMake(0, 0, SCREEN_BOUNDS.width, headerH), imageArray: [UIImage(named: "banner-1"),UIImage(named: "banner-2"),UIImage(named: "banner-3")])
        
        headerView.delegate = self
        
        return headerView
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 60
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let webController: CCShowNewsController = UIStoryboard(name: "Common", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("webBrowse") as! CCShowNewsController
        
        let model: NewsModel = (dataSource[indexPath.row] as? NewsModel)!
        
        webController.contentURL = NSURL(string: model.url)

        navigationController?.pushViewController(webController, animated: true)
        
    }
    
    /* CirCleViewDelegate */
    func clickCurrentImage(currentIndxe: Int) {
        print("当前点击了第\(currentIndxe)张图片！")
    }
    

}
