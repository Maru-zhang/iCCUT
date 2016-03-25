//
//  CCVideoSearchController.swift
//  iCCUT
//
//  Created by Maru on 15/11/27.
//  Copyright © 2015年 Alloc. All rights reserved.
//  搜索资源控制器


class CCVideoSearchController: UIViewController,UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
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
        
    }
    
    private func setupSetting() {
        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // MARK: - UITableView Datasource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath)
        
        let model: CCVideoModel = dataSource[indexPath.row] as! CCVideoModel
        
        cell.textLabel?.text = model.name
        
        return cell
    }
    
    // MARK: - Tableview Delegate
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        UIApplication.sharedApplication().keyWindow?.endEditing(true)
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        let model: CCVideoModel = dataSource[indexPath.row] as! CCVideoModel
        let player = MRVLCMediaController()
        cell?.selected = false
        player.mediaURL =  NSURL(string: model.url!)
        player.downloadBlock = ({() in
            DownloadTool.shareDownloadTool().downloadResourceToPath(model, index: indexPath)
        })
        presentViewController(player, animated: true) { () -> Void in
            
        }
        
    }
    
    // MARK: - UISearchBar Delegate
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        // 请求操作
        ServerOperator.getSearchVideoList(searchText) { (videoArray) -> Void in
            
            self.dataSource = videoArray
            self.tableView.reloadData()
        }
    }
    
    // MARK: - UIScrolView Delegate
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        UIApplication.sharedApplication().keyWindow?.endEditing(true)
    }
    
    // MARK: - Event
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        UIApplication.sharedApplication().keyWindow?.endEditing(true)
    }
}
