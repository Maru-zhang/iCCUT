//
//  CCMoreTableController.swift
//  iCCUT
//
//  Created by Maru on 15/9/22.
//  Copyright © 2015年 Alloc. All rights reserved.
//

import UIKit

class CCMoreTableController: UITableViewController {

    
    override func viewDidLoad() {
        
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        setupSetting()
    }
    
    
    private func setupSetting() {
        
        tabBarController?.navigationItem.title = tabBarItem.title
        
        tabBarController?.navigationItem.rightBarButtonItem = nil
    }
    
    
    // MARK: - TableView Delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.selected = false
    }
}
