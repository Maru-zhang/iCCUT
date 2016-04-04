//
//  CCMainTabbarController.swift
//  iCCUT
//
//  Created by Maru on 15/9/19.
//  Copyright © 2015年 Alloc. All rights reserved.
//

import UIKit

class CCMainTabbarController: UITabBarController,UITabBarControllerDelegate {

    //Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        setupSetting()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

    }
    

    
    //Private Method
    private func setupView() {
        
        viewControllers = [UIStoryboard.mainBoard("Home"),UIStoryboard.mainBoard("Network"),UIStoryboard.mainBoard("Media"),UIStoryboard.mainBoard("More")]
        
        let tabbarItems: [UITabBarItem] = self.tabBar.items!
        
        //加载图片
        func configItem(imgName: String,title: String,item: UITabBarItem) {
            item.image = UIImage(named: imgName)?.imageWithRenderingMode(.AlwaysOriginal)
            item.selectedImage = UIImage(named: imgName + "_selected")?.imageWithRenderingMode(.AlwaysOriginal)
            item.title = title
        }
        
        configItem("tabbar_home", title: "主页", item: tabbarItems[0])
        configItem("tabbar_network", title: "网络", item: tabbarItems[1])
        configItem("tabbar_video", title: "视频", item: tabbarItems[2])
        configItem("tabbar_profile", title: "我", item: tabbarItems[3])

        //设置字体颜色
        let attributesN =  [NSForegroundColorAttributeName: UIColor.grayColor()]
        let attributesH = [NSForegroundColorAttributeName: NAV_COLOR]
        //赋值字体颜色
        UITabBarItem.appearance().setTitleTextAttributes(attributesN, forState: UIControlState.Normal)
        UITabBarItem.appearance().setTitleTextAttributes(attributesH, forState: UIControlState.Selected)
    }
    
    private func setupSetting() {
        delegate = self
    }
    
    
    // MARK: - Tabbar Controller Delegate
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        let animation = CATransition()
        animation.type = kCATransitionFade
        animation.duration = 0.25
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        self.view.window?.layer.addAnimation(animation, forKey: "fadeTransition")
        
        return true
    }
    

    
    

}
