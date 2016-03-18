//
//  CCBaseNavigationController.swift
//  iCCUT
//
//  Created by Maru on 15/9/22.
//  Copyright © 2015年 Alloc. All rights reserved.
//

import UIKit

class CCBaseNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        
        setupSetting()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    
    //Private Method
    private func setupSetting() {
        
        //设置状态栏样式
        preferredStatusBarStyle()
        //导航栏背景颜色
        navigationBar.barTintColor = NAV_COLOR
        //导航栏字体颜色
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: NAV_FONT_COLOR]
        //设置返回颜色
        navigationBar.tintColor = NAV_FONT_COLOR
        
        
    }
    

}
