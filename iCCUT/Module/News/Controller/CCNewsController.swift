//
//  CCNewsController.swift
//  iCCUT
//
//  Created by Maru on 15/9/22.
//  Copyright © 2015年 Alloc. All rights reserved.
//

import UIKit

class CCNewsController: UITableViewController,CirCleViewDelegate {

    /** 视图模型 */
    let viewModel = NewsViewModel()
    /** 图片数组 */
    var imgArray = NSMutableArray()
    /** 标记 */
    let identifer = "newsCell"

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        
        setupSetting()
    }
    
    // MARK: - Private Method
    func setupView() {
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
            self.viewModel.fetchData(true)
        })
        tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { () -> Void in
            self.viewModel.fetchData(false)
        })
        
        tableView.backgroundView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clearAction)))
    }
    
    func setupSetting() {
        
        //设置控制器标题
        tabBarController?.navigationItem.title = tabBarItem.title
        //item消失
        tabBarController?.navigationItem.rightBarButtonItem = nil
        //隐藏滚动条
        tableView.showsVerticalScrollIndicator = false
        
        viewModel.successHandler = {
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            self.tableView.reloadData()
        }
        
        viewModel.errorHandler = {
            self.tableView.reloadData()
        }
        
        tableView.mj_header.beginRefreshing()
    }
    
    func clearAction() {
        UIApplication.sharedApplication().keyWindow?.endEditing(true)
    }
    
    
    // MARK: - Tableview Datasource
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.tableViewDisplay(emptyMessage: "没有更多的通知哦，刷新试试看！", count: viewModel.dataSource.count)
        return viewModel.dataSource.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCellWithIdentifier("CCNewsTableViewCell", forIndexPath: indexPath) as! CCNewsTableViewCell
        viewModel.updating(cell, index: indexPath)
        return cell
    }
    
    /* <TableView Delegate> */
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return viewModel.headerHeight
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView: CirCleView = CirCleView(frame: CGRectMake(0, 0, SCREEN_BOUNDS.width, viewModel.headerHeight), imageArray: [UIImage(named: "banner-1"),UIImage(named: "banner-2"),UIImage(named: "banner-3")])
        
        headerView.delegate = self
        
        return headerView
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return viewModel.cellForHeight(indexPath)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let webController: CCShowNewsController = UIStoryboard(name: "Common", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("webBrowse") as! CCShowNewsController
        
        let model: NewsModel = viewModel.dataSource[indexPath.row]
        
        webController.contentURL = NSURL(string: model.url!)

        navigationController?.pushViewController(webController, animated: true)
        
    }
    
    /* CirCleViewDelegate */
    func clickCurrentImage(currentIndxe: Int) {
        print("当前点击了第\(currentIndxe)张图片！")
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    

}
