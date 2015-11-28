//
//  CCHTTPClient.swift
//  iCCUT
//
//  Created by Maru on 15/9/26.
//  Copyright © 2015年 Alloc. All rights reserved.
//  这个类是用来管理客户网络状态的

import Alamofire

enum CCUserLoginType: NSInteger {
    //自动登陆
    case AutoLogin = 1
    //手动登陆
    case ManuLogin = 0
}

class CCHTTPClient: NSObject {
    
    /** 单例对象 */
    static let client = CCHTTPClient()
    /** 是否成功登陆 */
    var userType: CCUserLoginType {
        let user = NSUserDefaults.standardUserDefaults()
        if (user.objectForKey(KAUTO_LOGIN) != nil) {
            let num = user.objectForKey(KAUTO_LOGIN) as! NSInteger
            return CCUserLoginType(rawValue: num)!
        }else {
            user.setObject(1, forKey: KAUTO_LOGIN)
            return CCUserLoginType(rawValue: 1)!
        }
    }
    /** 网页分析器 */
    let parser: CCHTMLParser = CCHTMLParser()
    /** 账号密码本地化 */
    let userDefault: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    /** 登陆结果 */
    var resultArray: NSArray?
    
    
    // MARK: - Life Cycle
    class func getInstance() -> CCHTTPClient {
        return client
    }
    
    override init() {
        super.init()
    }
    
    
    // MARK: - Public Method
    //登陆操作
    func loginWithAccountAndPassword(act: NSString,pwd: NSString,completeHandler: (isSuccess: Bool) -> Void) -> Bool {
        
        var result: Bool = false
        
        Alamofire.request(.POST, SCHOOL_GATE, parameters: ["DDDDD": act,"upass": pwd,"0MKKey": "登录 Login"])
            .response { request, response, data, error in
                
                if error == nil {
                    // 成功
                    //更新状态,获取最新的数据
                    self.parser.parseHTMLWithPageString(NSString(data: data!, encoding: KCodeGB2312)!)
                    
                    if self.parser.loginStatus == CCUTLoginStatus.Sucess {
                        print("成功登陆!")
                        //结果为成功登陆
                        result = true
                    }else if self.parser.loginStatus == CCUTLoginStatus.UnLogin {
                        print("未登陆!")
                    }else if self.parser.loginStatus == CCUTLoginStatus.Error {
                        print("登陆失败!")
                    }
                    // 调用成功闭包
                    completeHandler(isSuccess: true)
                    
                }else {
                    completeHandler(isSuccess: false)
                }
                
                
        }
        
        return result
    }
    
    // 登出操作
    func logout(completeHandler: (isSuccess: Bool) -> Void) {
        
        // 开始请求
        Alamofire.request(.GET, SCHOOL_OUTGATE, parameters: nil)
            .response { request, response, data, error in
                //更新状态,获取最新的数据
                
                if (error != nil) {
                    completeHandler(isSuccess: false)
                }else {
                    completeHandler(isSuccess: true)
                }
                
        }
    }
    
    // 更新登录数据
    func updateQueryLoginPage(completeHandler: (isConnect: Bool) -> Void) {
        
        Alamofire.request(.GET, SCHOOL_GATE)
        .response { (_, _, data, error) -> Void in
            
            if error == nil {
                
                //成功
                let htmlContent = String(data: data!, encoding: KCodeGB2312)
                
                self.parser.parseHTMLWithPageString(htmlContent!)
                
                self.resultArray = self.parser.parseHTMLWithPageString(htmlContent!)
                
                // 成功请求的闭包
                completeHandler(isConnect: true)

            }else {
                //失败
                completeHandler(isConnect: false)
            }
        }
        
        
    }

}
