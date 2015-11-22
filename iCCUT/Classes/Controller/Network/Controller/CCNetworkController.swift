//
//  CCNetworkController.swift
//  iCCUT
//
//  Created by Maru on 15/9/22.
//  Copyright © 2015年 Alloc. All rights reserved.
//

import UIKit
import Alamofire

class CCNetworkController: UIViewController {
    
    
    /** HTTP管理 */
    let client = CCHTTPClient.getInstance()
    /** 时间标签 */
    @IBOutlet weak var timeLable: UILabel!
    /** 流量标签 */
    @IBOutlet weak var flowLable: UILabel!
    /** 费用标签 */
    @IBOutlet weak var feeLable: UILabel!
    /** 注销按钮 */
    @IBOutlet weak var cancelButton: UIButton!
    /** 自动登陆开关 */
    @IBOutlet weak var autoSwitch: UISwitch!
    /** 默认属性 */
    let defaultText = "暂无数据"
    
    // < Life Cycle>
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        setupView()
        
        setupSetting()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //获取22.28.211.100的页面
        var pageContent: NSString?
        
        Alamofire.request(.GET, "http://222.28.211.100", parameters: nil)
            .response { request, response, data, error in

                pageContent = NSString(data: data!, encoding: KCodeGB2312)
                
                //检查是已经登陆还是还没有登陆
                self.client.parser.parseHTMLWithPageString(pageContent!)
                
                if self.client.parser.loginStatus == CCUTLoginStatus.UnLogin {
                    //还没有登陆
                    self.autoLoginOrNot()
                }else if self.client.parser.loginStatus == CCUTLoginStatus.Sucess {
                    //已经登陆
                    self.updateFlowData()
                }
                
        }
  
    }
    
    // < Action >
    @IBAction func loginSwitch(sender: AnyObject) {
        let loginSwitch: UISwitch = sender as! UISwitch
        let user = NSUserDefaults.standardUserDefaults()
        
        if loginSwitch.on {
            user.setInteger(1, forKey: "isAutoLogin")
        }else {
            user.setInteger(0, forKey: "isAutoLogin")
        }
    }
    @IBAction func refreshClick(sender: AnyObject) {
        updateFlowData()
    }
    
    @IBAction func cancelClick(sender: AnyObject) {
        
        if cancelButton.selected {
            
            //显示登陆界面
            let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("login")
            presentViewController(loginVC, animated: true, completion: nil)
            cancelButton.selected = false
            
        }else {
            let progressView = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            
            progressView.labelText = "正在注销"
            
            //登出成功和登出失败
            if client.logout() {
                
                progressView.hide(true)
                self.cancelButton.selected = true
                showDefaultLlowData()
                
            }else {
                print("注销失败")
                progressView.labelText = "注销失败!"
                self.cancelButton.selected = false
            }
        }
        
    }

    
    // <Private Method>
    func setupView() {
        
        //根据client的自动登录设置来显示Switch
        if client.userType.rawValue == 1 {
            autoSwitch.on = true
        }else {
            autoSwitch.on = false
        }
        
        self.cancelButton.setTitle("登陆", forState: UIControlState.Selected)
        self.cancelButton.setTitle("注销", forState: UIControlState.Normal)
    }
    
    
    // Private Method
    private func setupSetting() {
        
        tabBarController?.navigationItem.title = tabBarItem.title
        tabBarController?.navigationItem.rightBarButtonItem = nil
        
        autoSwitch.addObserver(self, forKeyPath: "autoKey", options: NSKeyValueObservingOptions.New, context: nil)
    }
    
    func updateFlowData() {
        
        print("======刷新数据=======")
        
        Alamofire.request(.GET, "http://222.28.211.100", parameters: nil)
            .response { request, response, data, error in
                
                if error != nil {
                    // 网络访问出错的情况
                    debugPrint("error=========")
                }else {
                    // 网络访问正常的情况
                    //更新数据
                    self.client.updateQueryLoginPage()
                    
                    //检测数据正确性
                    if self.client.resultArray.count > 0 {
                        self.showLatestFlowData()
                    }else {
                        self.showDefaultLlowData()
                        
                    }
                }
  
        }
        
    }
    
    func autoLoginOrNot() {
        
        let userDefault = NSUserDefaults.standardUserDefaults()

        let account = userDefault.objectForKey(KACCOUNT)
        let password = userDefault.objectForKey(KPASSWORD)
        
        if (client.userType == CCUserLoginType.AutoLogin) && (account != nil){
            //可以自动登陆
            client.loginWithAccountAndPassword(account as! NSString, pwd: password as! NSString)
            
            
            //查看是否登陆成功
            if client.parser.loginStatus ==  CCUTLoginStatus.Sucess {
                //刷新
                updateFlowData()
                self.cancelButton.selected = false
            }else {
                //登陆失败
                MBProgressHUD.showError("登陆失败！", toView: self.view)
                self.cancelButton.selected = true
            }
            
            
            
        }else {
            //显示登陆界面
            let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("login")
            presentViewController(loginVC, animated: true, completion: nil)
        }
    }
    
    
    //显示最新的数据或者显示默认的数据
    private func showDefaultLlowData() {
        timeLable.text = defaultText
        flowLable.text = defaultText
        feeLable.text = defaultText
    }
    
    private func showLatestFlowData() {
        //获取对印的数值
        let time = client.resultArray[0] as! NSNumber
        let flow = client.resultArray[1] as! NSNumber
        let menoy = client.resultArray[2] as! NSNumber
        
        timeLable.text = NSString(format: "%d分钟", time.integerValue) as String
        flowLable.text = NSString(format: "%d MByte", flow.integerValue) as String
        feeLable.text = NSString(format: "%d元", menoy.integerValue) as String
    }
    
    
    // < Call Back >
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        if keyPath == "autoKey" {
            print("====")
        }
    }
}

