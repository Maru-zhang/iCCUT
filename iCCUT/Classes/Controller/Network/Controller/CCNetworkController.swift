//
//  CCNetworkController.swift
//  iCCUT
//
//  Created by Maru on 15/9/22.
//  Copyright © 2015年 Alloc. All rights reserved.
//

import UIKit

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
    @IBOutlet weak var detailButton: UIButton!
    /** 默认属性 */
    let defaultText = "暂无数据"
    
    
    // < Life Cycle>
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        setupSetting()
        
        print(client.userType.rawValue)
        
        if client.userType == UserType.nerverLogin || client.userType == UserType.unremeber{
            
            //用户第一次进入
            let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("login")
            presentViewController(loginVC, animated: true, completion: nil)
            
        }else if client.userType == UserType.haveLogin {
            print(client.userType)
            //自动登录
            let account = NSUserDefaults.standardUserDefaults().objectForKey(KACCOUNT) as! NSString
            let password = NSUserDefaults.standardUserDefaults().objectForKey(KPASSWORD)as! NSString
            //异步线程
            client.loginWithAccountAndPassword(account, pwd: password)
            
        }else if client.userType == UserType.guest {
            //游客模式，不需要登录
        }else if client.userType == UserType.haveOut {
            //已经登出，需要重新登录
            let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("login")
            presentViewController(loginVC, animated: true, completion: nil)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //进入页面的时候默认刷新一次
        performSelector(Selector("updateFlowData"), withObject: nil, afterDelay: 1)
    }
    
    // < Action >
    @IBAction func refreshClick(sender: AnyObject) {
        updateFlowData()
    }
    @IBAction func detailButtonClick(sender: AnyObject) {
    }
    
    // <Private Method>
    
    
    // Private Method
    private func setupSetting() {
        
        tabBarController?.navigationItem.title = tabBarItem.title
        tabBarController?.navigationItem.rightBarButtonItem = nil
    }
    
    func updateFlowData() {
        
        print("======刷新数据=======")
        //检测数据正确性
        if client.resultArray.count > 0 {
            //获取对印的数值
            let time = client.resultArray[0] as! NSNumber
            let flow = client.resultArray[1] as! NSNumber
            let menoy = client.resultArray[2] as! NSNumber
            
            timeLable.text = NSString(format: "%d分钟", time.integerValue) as String
            flowLable.text = NSString(format: "%d MByte", flow.integerValue) as String
            feeLable.text = NSString(format: "%d元", menoy.integerValue) as String
        }else {
            timeLable.text = defaultText
            flowLable.text = defaultText
            feeLable.text = defaultText
        }
    }
}
