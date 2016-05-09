
//
//  CCMediaListController.swift
//  iCCUT
//
//  Created by Maru on 15/9/20.
//  Copyright © 2015年 Alloc. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SCLAlertView

class CCMediaListController: UITableViewController,CCSortViewProtocol {
    
    /// 类别选择控制器
    lazy var sortVC: CCSortViewController = CCSortViewController(collectionViewLayout: UICollectionViewFlowLayout())
    /// 转场控制
    lazy var customPresentationController: CCMediaTransition = CCMediaTransition(presentedViewController: self.sortVC, presentingViewController: self)
    /// 标示
    let identifier = "mediaListCell"
    /// 第一分类
    var leve1: String!
    /// 第二分类
    var leve2: String?
    /// 当前的页码
    var currentIndex: NSInteger = 0
    /// 影视分类列表
    var sortList: NSArray?
    /// 数据源
    var dataArray: NSMutableArray = NSMutableArray()
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
        s.addTarget(self, action: #selector(CCMediaListController.sortViewAction(_:)), forControlEvents: UIControlEvents.TouchDown)
        return s
        
    }
    /** 下载item */
    var downloadItem: UIBarButtonItem {
        
        let item: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "media_download")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(CCMediaListController.downloadButtonClick))
        
        item.imageInsets = UIEdgeInsets(top: 12, left: 10, bottom: 12, right: 10)
        
        return item
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        
        setupView()
        
        tableView.mj_header.beginRefreshing()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        setupSetting()
        
        
    }
    
    
    // MARK: -  Private Method
    private func setupView() {
        
        // 不显示垂直指示器
        tableView.showsVerticalScrollIndicator = false
        // 添加分类按钮
        self.navigationItem.titleView = sortButton
        // 下拉刷新
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
            self.loadData(true)
        });
        
        // MJ上拉刷新
        tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { () -> Void in
            self.loadData(false)
        });
        
        // 配置转场代理
        sortVC.transitioningDelegate = customPresentationController
        // 配置选择代理
        sortVC.sortDelegate = self
        
    }
    
    private func loadData(isSetup: Bool) {
        
        // 判断重置
        if isSetup {
            currentIndex = 0
        }
        
        // 请求参数
        var parmeter: [String: String] = ["index": "\(currentIndex)","leve1": leve1!,"leve2":""]
        
        
        // 是否有leve2然后生成不同的参数
        if leve2 != nil {
            parmeter["leve2"] = leve2
        }
        
        // 发送请求
        Alamofire.request(.POST, "\(HOST)/iCCUT/MediaList", parameters:parmeter,encoding: .URLEncodedInURL)
            .responseJSON { response in
                
                switch response.result {
                case .Success:
                    
                    //第一次的时候清空数据源
                    if isSetup {
                        self.dataArray.removeAllObjects()
                    }
                    
                    
                    if let value = response.result.value {
                        
                        let json = JSON(value)
                        
                        //如果success不为1那么就相关处理
                        guard json["success"].boolValue else {
                            SCLAlertView().showInfo("温馨提示", subTitle: json["msg"].stringValue)
                            //停止刷新
                            self.tableView.mj_footer.endRefreshing()
                            self.tableView.mj_header.endRefreshing()
                            return
                        }
                        
                        for (_,subJson): (String,JSON) in json["datas"] {
                            let videoItem: CCVideoModel = CCVideoModel()
                            videoItem.name = subJson["title"].stringValue
                            videoItem.url = subJson["url"].stringValue
                            self.dataArray.addObject(videoItem)
                        }
                        
                        
                    }
                    
                    // 累加
                    self.currentIndex += 1
                    
                    // 刷新
                    self.tableView.reloadData()
                    
                    break
                case .Failure:
                    SCLAlertView.showNetworkErrorView()
                    break
                }
                //停止刷新
                self.tableView.mj_footer.endRefreshing()
                self.tableView.mj_header.endRefreshing()
        }
        
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

        sortVC.data = sortList
        presentViewController(sortVC, animated: true, completion: nil)
    }
    
    
    // MARK: - TableView DataSource
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.tableViewDisplay(emptyMessage: "暂时没有视频资源哦,刷新试试看~", count: dataArray.count)
        return (dataArray.count)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier)
        
        if ((cell) == nil) {
            
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: identifier)
        }
        
        let model: CCVideoModel = dataArray[indexPath.row] as! CCVideoModel
        
        cell?.textLabel?.text = model.name
        cell?.textLabel?.adjustsFontSizeToFitWidth = true
        
        return cell!
    }
    
    
    // MARK: - TableView Delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let playerVC = CCPlayerViewController(mediaModel: dataArray[indexPath.row] as! CCVideoModel)
        
        self.navigationController?.pushViewController(playerVC, animated: true)
        
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    // MARK: - CCSortViewProtocol
    func sortView(indexPath: NSIndexPath) {
        
        currentIndex = 0
        
        self.leve2 = sortList![indexPath.row] as? String
        
        tableView.mj_header.beginRefreshing()
    }
    
}
