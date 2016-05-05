//
//  CCMoreTableController.swift
//  iCCUT
//
//  Created by Maru on 15/9/22.
//  Copyright © 2015年 Alloc. All rights reserved.
//

import UIKit

class CCMoreTableController: UITableViewController {

    @IBOutlet weak var autoSwitch: UISwitch!
    
    override func viewDidLoad() {
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        setupSetting()
    }
    
    
    private func setupSetting() {
        
        tabBarController?.navigationItem.title = tabBarItem.title
        
        tabBarController?.navigationItem.rightBarButtonItem = nil
        
        let isAuto = NSUserDefaults.standardUserDefaults().boolForKey(AutoLoginKey)
        
        if isAuto {
            self.autoSwitch.on = true
        }else {
            self.autoSwitch.on = false
        }
        
    }
    
    // MARK: - Action
    @IBAction func switchAction(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().setBool(self.autoSwitch.on, forKey: AutoLoginKey)
    }
    
    // MARK: - TableView Delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.selected = false
    }

}
