//
//  CCNewsController.swift
//  iCCUT
//
//  Created by Maru on 15/9/22.
//  Copyright © 2015年 Alloc. All rights reserved.
//

import UIKit

class CCNewsController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        setupSetting()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    //Private Method
    func setupSetting() {
        
        //设置控制器标题
        tabBarController?.navigationItem.title = tabBarItem.title
        //item消失
        tabBarController?.navigationItem.rightBarButtonItem = nil
    }

}
