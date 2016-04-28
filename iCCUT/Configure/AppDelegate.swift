//
//  AppDelegate.swift
//  iCCUT
//
//  Created by Maru on 15/9/19.
//  Copyright © 2015年 Alloc. All rights reserved.
//

import UIKit
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    

    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        dispatch_async(dispatch_get_global_queue(0, 0)) {
            DownloadTool.shareDownloadTool().readData()
        }
        
        // 设置全局样式
        setupAppearence()
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.rootViewController = CCNavigationController(rootViewController: CCMainTabbarController())
        window?.makeKeyAndVisible()
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    /*
     响应3DTouch的相关操作
     */
    func application(application: UIApplication, performActionForShortcutItem shortcutItem: UIApplicationShortcutItem, completionHandler: (Bool) -> Void) {
        
        let navVC = UIApplication.sharedApplication().keyWindow?.rootViewController as! CCNavigationController
        let tabbarVC = navVC.topViewController as! CCMainTabbarController
        
        if shortcutItem.type == "Fast" {
            tabbarVC.selectedIndex = 1
        }else if shortcutItem.type == "Search" {
            tabbarVC.selectedIndex = 2
            let movie_vc = tabbarVC.selectedViewController as! CCListViewController
            movie_vc.searchButtonClick()
        }
    }
    
    
    // MARK: - Private Method
    private func setupAppearence() {
        
        //导航栏背景颜色
        UINavigationBar.appearance().barTintColor = NAV_COLOR
        //导航栏字体颜色
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: NAV_FONT_COLOR]
        //设置返回颜色
        UINavigationBar.appearance().tintColor = NAV_FONT_COLOR
    }


}

