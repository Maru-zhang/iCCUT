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
    
    // MARK: - Private Method
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
        let alertViewResponder: SCLAlertViewResponder = SCLAlertView().showWait("正在登录...", subTitle: "")
        alertViewResponder.alertview.showCloseButton = false
        
        
        //如果是记住密码
        let account = self.accountText.text
        let password = self.passwordText.text
        
        //开始登录操作
        client.loginWithAccountAndPassword(account!, pwd: password!, completeHandler: { (isSuccess) -> Void in
            
            if isSuccess {
                // 登录联网成功
                
                if self.client.parser.loginStatus == CCUTLoginStatus.Sucess {
                    
                    //判断开关
                    if self.rememberSwitch.on {
                        //开始存储密码
                        self.userDefault.setObject(account, forKey: KACCOUNT)
                        self.userDefault.setObject(password, forKey: KPASSWORD)
                    }
                    
                    
                    //退出控制器
                    self.dismissViewControllerAnimated(true, completion: { () -> Void in
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            alertViewResponder.close()
                        })
                    })
                    
                }else {
                    alertViewResponder.close()
                    SCLAlertView().showError("温馨提示", subTitle: self.client.parser.loginStatusInfo as! String)
                }
            }else {
                
                // 联网失败
                alertViewResponder.close()
                SCLAlertView.showNetworkErrorView()
            }
        })

        
    }
    @IBAction func guestLoginClick(sender: AnyObject) {
        
        NSUserDefaults.standardUserDefaults().setObject(0, forKey: KAUTO_LOGIN)
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        UIApplication.sharedApplication().keyWindow?.endEditing(true)
    }
}
