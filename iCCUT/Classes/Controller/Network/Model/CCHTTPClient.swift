//
//  CCHTTPClient.swift
//  iCCUT
//
//  Created by Maru on 15/9/26.
//  Copyright © 2015年 Alloc. All rights reserved.
//

enum UserType: NSString {
    //第一次登陆的用户
    case nerverLogin
    //以游客身份进入的用户
    case guest
    //登陆过但是没有选择自动登陆的用户
    case unremeber
    //已经登录
    case haveLogin
    //已经登出
    case haveOut
    //不想登入
    case wantOut
}

class CCHTTPClient: NSObject {
    
    /** 单例对象 */
    static let client = CCHTTPClient()
    /** 请求地址 */
    let postAddress = "http://222.28.211.100"
    /** 是否成功登陆 */
    var userType: UserType = UserType.nerverLogin
    /** HTTP操作管理 */
    let operationManager: AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
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
        
        //如果本地化了用户类型，那么就复制给成员变量->userType
        if userDefault.objectForKey(KUSER_TYPE) != nil {
            let user = userDefault.objectForKey(KUSER_TYPE) as! NSString
            self.userType = UserType(rawValue: user)!
        }
    }
    
    
    //< Public Method >
    func loginWithAccountAndPassword(act: NSString,pwd: NSString) -> Bool {
        
        //配置POST参数
        let parameters: NSDictionary = ["DDDDD": act,"upass": pwd,"0MKKey": "登录 Login"]
        
        //配置超时
        operationManager.requestSerializer.timeoutInterval = 3
        
        //配置响应类型
        operationManager.responseSerializer.acceptableContentTypes = NSSet(object: "text/html") as Set<NSObject>
        
        //开始POST请求
        operationManager.POST(postAddress, parameters: parameters, success: { (operation: AFHTTPRequestOperation, operationObject) -> Void in
            print("Success")
            
  
            //更新状态,获取最新的数据
            self.updateQueryLoginPage()
            
            if self.parser.loginStatus == CCUTLoginStatus.Sucess {
                //更改用户身份
                self.userType = UserType.haveLogin
                self.userDefault.setObject(self.userType.rawValue, forKey: KUSER_TYPE)
            }else if self.parser.loginStatus == CCUTLoginStatus.UnLogin {
                //更改用户身份
                self.userType = UserType.haveOut
                self.userDefault.setObject(self.userType.rawValue, forKey: KUSER_TYPE)
            }else if self.parser.loginStatus == CCUTLoginStatus.Error {
                //更改用户身份
                self.userType = UserType.haveOut
                self.userDefault.setObject(self.userType.rawValue, forKey: KUSER_TYPE)
            }
            
            })
            { (operation, operationError) -> Void in
                print("POST失败!")
                print(operationError)
        }
        
        //判断是否成功登录
        if self.userType == UserType.haveLogin {
            return true
        }else {
            return false
        }

    }
    
    //更新登录数据
    func updateQueryLoginPage() {
        
        var htmlContent:NSString?
        
        do {
            htmlContent = try NSString(contentsOfURL: NSURL(string: postAddress)!, encoding: KCodeGB2312)
        }catch {
            print("获取网页内容出错!")
        }
        
        parser.parseHTMLWithPageString(htmlContent!)
        
        resultArray = parser.resultArray
 
        print(resultArray)
        
    }

}
