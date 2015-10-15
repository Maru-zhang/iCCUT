//
//  CCHTTPClient.swift
//  iCCUT
//
//  Created by Maru on 15/9/26.
//  Copyright © 2015年 Alloc. All rights reserved.
//

enum CCUserLoginType: NSString {

    //自动登陆
    case AutoLogin
    //手动登陆
    case ManuLogin
}

class CCHTTPClient: NSObject {
    
    /** 单例对象 */
    static let client = CCHTTPClient()
    /** 是否成功登陆 */
    var userType: CCUserLoginType = CCUserLoginType.AutoLogin
    /** 网络类型监控 */
    let networkManager: AFNetworkReachabilityManager = AFNetworkReachabilityManager.sharedManager()
    /** 网页分析器 */
    let parser: CCHTMLParser = CCHTMLParser()
    /** 账号密码本地化 */
    let userDefault: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    /** 登陆结果 */
    var resultArray: NSArray = NSArray()
    /** HTTP操作管理 */
    var operationManager: AFHTTPRequestOperationManager {
        get {
            let httpManageer = AFHTTPRequestOperationManager()
            //配置超时
            httpManageer.requestSerializer.timeoutInterval = 1.0
            //配置响应类型
            httpManageer.responseSerializer.acceptableContentTypes = NSSet(object: "text/html") as Set<NSObject>
            return httpManageer
        }
        set {
            
        }
    }
    
    
    
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
        
        //配置POST参数
        let parameters: NSDictionary = ["DDDDD": act,"upass": pwd,"0MKKey": "登录 Login"]
        
        //开始POST请求
        operationManager.POST(parser.pageURL, parameters: parameters, success: { (operation: AFHTTPRequestOperation, operationObject) -> Void in
            
            //更新状态,获取最新的数据
            self.updateQueryLoginPage()
            
            if self.parser.loginStatus == CCUTLoginStatus.Sucess {
                print("成功登陆!")
                //结果为成功登陆
                result = true
            }else if self.parser.loginStatus == CCUTLoginStatus.UnLogin {
                print("未登陆!")
            }else if self.parser.loginStatus == CCUTLoginStatus.Error {
            }
                print("登陆失败!")
            })
            { (operation, operationError) -> Void in
                print("POST失败!")
                print(operationError)
        }
        
        return result
    }
    
    //登出操作
    func logout() -> Bool {
        
        var result: Bool = true
        
        //开始请求
        operationManager.GET("http://222.28.211.100/F.htm", parameters: nil, success: { (operation, operationObject) -> Void in
        
            print("注销成功")
            
            })
        { (operation, operationError) -> Void in
            print(operationError)
            result = false
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
 
        print(resultArray)
        
    }

}
