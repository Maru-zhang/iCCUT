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
        
        preferredStatusBarStyle()
        
        viewControllers = [UIStoryboard.mainBoard("Home"),UIStoryboard.mainBoard("Network"),UIStoryboard.mainBoard("Media"),UIStoryboard.mainBoard("More")]
        
        let tabbarItems: [UITabBarItem] = self.tabBar.items!
        
        let item_0 = tabbarItems[0]
        let item_1 = tabbarItems[1]
        let item_2 = tabbarItems[2]
        let item_3 = tabbarItems[3]
        
        
        //加载图片
        item_0.image = UIImage(named: "tabbar_home")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        item_0.title = "主页"
        item_0.selectedImage = UIImage(named: "tabbar_home_selected")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        
        item_1.image = UIImage(named:"tabbar_network")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        item_1.title = "网络"
        item_1.selectedImage = UIImage(named: "tabbar_network_selected")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        
        item_2.image = UIImage(named: "tabbar_video")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        item_2.title = "视频"
        item_2.selectedImage = UIImage(named:"tabbar_video_selected")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        
        item_3.image = UIImage(named: "tabbar_profile")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        item_3.title = "我"
        item_3.selectedImage = UIImage(named: "tabbar_profile_selected")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        
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
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
