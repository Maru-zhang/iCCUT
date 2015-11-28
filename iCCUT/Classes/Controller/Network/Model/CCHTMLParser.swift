//
//  CCHTMLParser.swift
//  iCCUT
//
//  Created by Maru on 15/9/26.
//  Copyright © 2015年 Alloc. All rights reserved.
//  这个类只是用来分析网页的，来判断当前的登录状态，它不管理网络连接状态


import Alamofire

enum CCUTLoginStatus: NSString {
    case UnLogin /* 还没有登陆 */
    case Sucess  /* 已成功登陆 */
    case Error   /* 出现错误 */
}

class CCHTMLParser: NSObject {
    
    /** 登陆状态 */
    var loginStatus: CCUTLoginStatus? = CCUTLoginStatus.UnLogin
    /** 登陆状态信息 */
    var loginStatusInfo: NSString?
    /** 登陆信息表 */
    let msgKey: NSArray = (NSDictionary(contentsOfURL: NSBundle.mainBundle().URLForResource("Msg", withExtension: "plist")!)?.allKeys)!
    let msgDic:NSDictionary = NSDictionary(contentsOfURL: NSBundle.mainBundle().URLForResource("Msg", withExtension: "plist")!)!

    
    // MARK: - Public Method
    /**
    分析HTMl源码，如果是正确的已登录状态，那么就获取相应的登录信息，否则返回空值
    
    - parameter page: HTML字符串
    
    - returns: 一个包含登录信息的数组
    */
    func parseHTMLWithPageString(page: NSString) -> NSArray? {
        
        let info: NSString = page.substringWithRange(NSMakeRange(313, 2))
        
        if info.isEqualToString("'w") || info.isEqualToString("cr") {
            //成功登陆
            self.loginStatus = CCUTLoginStatus.Sucess
            
            self.loginStatusInfo = "您已经成功登录"
            
            //获取源数据
            let timeString: NSString = page.substringWithRange(NSMakeRange(332, 10))
            let time = timeString.integerValue
            
            let fString: NSString = page.substringWithRange(NSMakeRange(350, 10))
            let f = fString.integerValue
            
            let fee1String: NSString = page.substringWithRange(NSMakeRange(375, 10))
            var fee1 = fee1String.integerValue
            
            //流量
            var f1 = f % 1024
            let f2 = f - f1
            f1 *= 1000
            f1 = f1 - (f1 % 1024)
            let f3: NSString = (f1 / 1024 < 100) ? (f1 / 1024 < 10 ? ".00" : ".0") : "."
            let flowString = NSString(format: "%li%@%li",  f2 / 1024, f3, f1 / 1024)
            let flow = flowString.integerValue
            
            //金额
            fee1 -= (fee1 % 100);
            let fee = fee1 / 10000;
            
            //传送结果
            let returnValue = NSArray(objects: NSNumber(integer: time),NSNumber(integer: flow),NSNumber(integer: fee))
            
            return returnValue
            
            
        }else if info.isEqualToString("va") {
            
            //还未登陆
            self.loginStatus = CCUTLoginStatus.UnLogin
            
            self.loginStatusInfo = "尚未登录"
            
            return nil
            
        }else {
            
            self.loginStatus = CCUTLoginStatus.Error
            
            self.loginStatusInfo = msgDic.objectForKey(info) as? NSString
            
            return nil
        }
        
        
    }

}
