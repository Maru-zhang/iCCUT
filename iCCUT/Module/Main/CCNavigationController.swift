//
//  CCNavigationController.swift
//  iCCUT
//
//  Created by Maru on 16/3/29.
//  Copyright © 2016年 Alloc. All rights reserved.
//

class CCNavigationController: UINavigationController {
    override func viewDidLoad() {
        
        preferredStatusBarStyle()
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}
