//
//  CCLoginViewController.swift
//  iCCUT
//
//  Created by Maru on 15/9/26.
//  Copyright © 2015年 Alloc. All rights reserved.
//

import UIKit

class CCLoginViewController: UIViewController {
    
    /** 密码 */
    @IBOutlet weak var passwordText: CCTextFiled!
    /** 账号 */
    @IBOutlet weak var accountText: CCTextFiled!
    /** 记住密码开关 */
    @IBOutlet weak var rememberSwitch: UISwitch!
    /** 客户端对象 */
    let client = CCHTTPClient.getInstance()
    /** 持久化对象 */
    let userDefault = NSUserDefaults.standardUserDefaults()

    override func viewDidLoad() {
        super.viewDidLoad()

        //配置界面
        setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //< Private Method >
    private func setupView() {
        
        //检测是不是有本地化数据，如果有就显示到登陆界面上面来
        if (userDefault.objectForKey(KACCOUNT) != nil) && (userDefault.objectForKey(KPASSWORD) != nil) {
            self.accountText.text = userDefault.objectForKey(KACCOUNT) as? String
            self.passwordText.text = userDefault.objectForKey(KPASSWORD)as? String
        }
    }
    
    
    //< Action >
    @IBAction func remeberClick(sender: AnyObject) {
        
    }
    @IBAction func loginClick(sender: AnyObject) {
        
        //配置等候界面
        let progressView = MBProgressHUD.showHUDAddedTo(view, animated: true)
        progressView.labelText = "正在登录"
        
        if rememberSwitch.on {
            //如果是记住密码
            let account = self.accountText.text
            let password = self.passwordText.text
            
            //开始登录操作
            client.loginWithAccountAndPassword(account!, pwd: password!)
            
            //如果已经成功登录
            if client.userType == UserType.haveLogin {
                userDefault.setObject(account, forKey: "account")
                userDefault.setObject(password, forKey: "password")
            }
            
        }else {
            //如果是不记住密码
        }
        //退出控制器
        dismissViewControllerAnimated(true, completion: { () -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                progressView.hide(true)
            })
        })
        
    }
    @IBAction func guestLoginClick(sender: AnyObject) {
        
        let client = CCHTTPClient.getInstance()
        
        client.userType = UserType.guest
        
        dismissViewControllerAnimated(true, completion: nil)
    }
}
