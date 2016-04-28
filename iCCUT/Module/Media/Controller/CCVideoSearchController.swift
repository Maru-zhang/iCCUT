//
//  CCVideoSearchController.swift
//  iCCUT
//
//  Created by Maru on 15/11/27.
//  Copyright © 2015年 Alloc. All rights reserved.
//  搜索资源控制器

import Cartography

class CCVideoSearchController: UITableViewController,UISearchBarDelegate,UISearchResultsUpdating,UISearchControllerDelegate {
    
    var resultVC: UITableViewController!
    let searchController = UISearchController(searchResultsController: UITableViewController(style: .Plain))

    /// 唯一标识
    let identifier = "searchCell"
    /// 数据源
    var dataSource = NSMutableArray()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSetting()
        
        setupView()
    }
    
    // MARK: - Private Method
    private func setupView() {
        
        self.tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: identifier)
        
        tableView.tableHeaderView = searchController.searchBar
        
        searchController.searchBar.sizeToFit()
        searchController.searchBar.tintColor = UIColor.whiteColor()
        searchController.searchBar.placeholder = "请输入视频名称/关键字"
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        
        resultVC = searchController.searchResultsController as! UITableViewController
        resultVC.tableView.delegate = self
        resultVC.tableView.dataSource = self
        
    }
    
    private func setupSetting() {
        
    }
    
    // MARK: - UITableView Datasource
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active {
            return dataSource.count
        }else {
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if searchController.active {
            
            var cell = tableView.dequeueReusableCellWithIdentifier(identifier)
            
            if cell == nil {
                
                cell = UITableViewCell(style: .Default, reuseIdentifier: identifier)
            }
            
            let model: CCVideoModel = dataSource[indexPath.row] as! CCVideoModel
            
            cell!.textLabel?.text = model.name
            
            return cell!
        }
        
        return UITableViewCell()
        
    }
    
    // MARK: - Tableview Delegate
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        UIApplication.sharedApplication().keyWindow?.endEditing(true)
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        let model: CCVideoModel = dataSource[indexPath.row] as! CCVideoModel
        cell?.selected = false

        let player = CCPlayerViewController()
        player.resource = NSURL(string: model.url!)
        
        dispatch_async(dispatch_get_main_queue()) { 
            
            self.searchController.presentViewController(player, animated: true, completion: nil)
        }
        
    }
    
    // MARK: - UISearchController
    func updateSearchResultsForSearchController(searchController: UISearchController) {
//        dispatch_async(dispatch_get_main_queue()) { 
//            self.resultVC.tableView.reloadData()
//        }
    }
    
    
    // MARK: - UISearchBar Delegate
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        // 请求操作
        ServerOperator.getSearchVideoList(searchText) { (videoArray) -> Void in
            
            self.dataSource = videoArray
            
            self.resultVC.tableView.reloadData()
        }
    }
    
    
}
