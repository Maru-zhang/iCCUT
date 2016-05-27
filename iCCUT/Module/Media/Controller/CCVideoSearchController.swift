//
//  CCVideoSearchController.swift
//  iCCUT
//
//  Created by Maru on 15/11/27.
//  Copyright © 2015年 Alloc. All rights reserved.
//  搜索资源控制器

import Cartography

class CCVideoSearchController: UITableViewController {
    
    var resultVC: UITableViewController!
    var searchController: UISearchController!

    /// 数据源
    var dataSource = [CCVideoModel]()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    // MARK: - Private Method
    private func setupView() {
        
        resultVC = UITableViewController(style: .Plain)
        resultVC.automaticallyAdjustsScrollViewInsets = false
        resultVC.tableView.contentInset = UIEdgeInsetsMake(54, 0, 0, 0)
        searchController = UISearchController(searchResultsController: resultVC)
                
        tableView.tableHeaderView = searchController.searchBar
        
        searchController.searchBar.sizeToFit()
        searchController.searchBar.tintColor = UIColor.whiteColor()
        searchController.searchBar.placeholder = "请输入视频名称/关键字"
        searchController.dimsBackgroundDuringPresentation = true
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        
        resultVC.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: String(UITableViewCell))
        resultVC.tableView.delegate = self
        resultVC.tableView.dataSource = self
        
    }
    
    
}

extension CCVideoSearchController {
    
    
    // MARK: - UITableView Datasource
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active {
            return dataSource.count
        }else {
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(String(UITableViewCell), forIndexPath: indexPath)
        if searchController.active {
            cell.textLabel?.text = dataSource[indexPath.row].name!
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
        cell?.selected = false
        
        let player = CCPlayerViewController(mediaModel: (dataSource[indexPath.row]))
        
        dispatch_async(dispatch_get_main_queue()) {
            
            self.searchController.presentViewController(player, animated: true, completion: nil)
        }
        
    }
    
}

extension CCVideoSearchController: UISearchBarDelegate,UISearchResultsUpdating,UISearchControllerDelegate {
    
    // MARK: - UISearchController
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        //        dispatch_async(dispatch_get_main_queue()) {
        //            self.resultVC.tableView.reloadData()
        //        }
    }
    
    func didPresentSearchController(searchController: UISearchController) {
        searchController.searchResultsController?.view.layoutIfNeeded()
    }
    
    
    // MARK: - UISearchBar Delegate
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        CCNetService.fetchSearchResult(searchText, success: { [unowned self] (models) in
            self.dataSource = models
            self.resultVC.tableView.reloadData()
        }) { (msg) in
            
        }
    }
    

}
