//
//  CCHTTPClient.swift
//  iCCUT
//
//  Created by Maru on 15/9/26.
//  Copyright © 2015年 Alloc. All rights reserved.
//

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
    var resultArray: NSArray = NSArray()

    
    
    //< Life Cycle >
    class func getInstance() -> CCHTTPClient {
        return client
    }
    
    override init() {
        super.init()
    }
    
    
    //< Public Method >
    //登陆操作
    func loginWithAccountAndPassword(act: NSString,pwd: NSString) -> Bool {
        
        var result: Bool = false
        
        Alamofire.request(.POST, parser.pageURL, parameters: ["DDDDD": act,"upass": pwd,"0MKKey": "登录 Login"])
            .response { request, response, data, error in
                //更新状态,获取最新的数据
                self.updateQueryLoginPage()
                
                if self.parser.loginStatus == CCUTLoginStatus.Sucess {
                    print("成功登陆!")
                    //结果为成功登陆
                    result = true
                }else if self.parser.loginStatus == CCUTLoginStatus.UnLogin {
                    print("未登陆!")
                }else if self.parser.loginStatus == CCUTLoginStatus.Error {
                    print("登陆失败!")
                }
     
        }
        
        return result
    }
    
    //登出操作
    func logout() -> Bool {
        
        var result: Bool = true

        // 开始请求
        Alamofire.request(.GET, "http://222.28.211.100/F.htm", parameters: nil)
            .response { request, response, data, error in
                //更新状态,获取最新的数据
                
                if (error != nil) {
                    print(error)
                    result = false
                }else {
                    debugPrint("注销成功")
                }
                
        }
        //返回结果
        return result
    }
    
    //更新登录数据
    func updateQueryLoginPage() {
        
        var htmlContent:NSString?
        
        do {
            htmlContent = try NSString(contentsOfURL: NSURL(string: parser.pageURL)!, encoding: KCodeGB2312)
        }catch {
            print("获取网页内容出错!")
        }
        
        parser.parseHTMLWithPageString(htmlContent!)
        
        resultArray = parser.resultArray
    }

}
