//
//  CCPlayerViewController.swift
//  iCCUT
//
//  Created by Maru on 16/4/28.
//  Copyright © 2016年 Alloc. All rights reserved.
//

import UIKit
import Cartography

class CCPlayerViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    var resource: NSURL?
    let mr_player: MRVLCPlayer = MRVLCPlayer()
    let comment: UITableView = UITableView()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        
        setupView()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        mr_player.dismiss()
    }
    
    // MARK: - Private Method
    private func setupView() {
        
        comment.dataSource = self
        comment.delegate  = self
        view.addSubview(comment)
        
        mr_player.mediaURL = resource!
        mr_player.showInView(view)
        mr_player.exitBlock = { self.exit() }
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        constrain(mr_player, comment) { (player, comment) in
            
            player.top    == (player.superview?.top)!
            player.left   == (player.superview?.left)!
            player.width  == (player.superview?.width)!
            player.height == (player.superview?.width)! * (9/16)
            
            comment.top   == player.bottom
            comment.left  == player.left
            comment.right == player.right
            comment.bottom == (player.superview?.bottom)!
            
        }
        
    }

    
    // MARK: - Event
    @objc private func exit() {
        if let _ = self.navigationController {
            self.navigationController?.popViewControllerAnimated(true)
        }else {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
    }
    
    // MARK: - TableView Delegate & DataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    
    
    // MARK: - Override
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    

}
