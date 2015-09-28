//
//  CCHTMLParser.swift
//  iCCUT
//
//  Created by Maru on 15/9/26.
//  Copyright © 2015年 Alloc. All rights reserved.
//

enum CCUTLoginStatus: NSString {
    case Sucess
    case Error
    case UnLogin
}

class CCHTMLParser: NSObject {
    
    /** 登陆地址 */
    let pageURL = "http://222.28.211.100"
    /** 登陆状态 */
    var loginStatus: CCUTLoginStatus? = CCUTLoginStatus.UnLogin
    /** 登陆状态信息 */
    var loginStatusInfo: NSString?
    /** 解析结果数据 */
    var resultArray: NSArray = NSArray()
    /** 登陆信息表 */
    let msgKey: NSArray = (NSDictionary(contentsOfURL: NSBundle.mainBundle().URLForResource("Msg", withExtension: "plist")!)?.allKeys)!
    let msgDic:NSDictionary = NSDictionary(contentsOfURL: NSBundle.mainBundle().URLForResource("Msg", withExtension: "plist")!)!
    
    
    
    // <Public Method>
    func parseHTMLWithPageString(page: NSString) {
        
        let msg: NSString = page.substringWithRange(NSMakeRange(313, 2))
        
        print(msg)
        
        if msg.isEqualToString("'w") || msg.isEqualToString("cr") {
            //成功登陆
            self.loginStatus = CCUTLoginStatus.Sucess
            
            self.loginStatusInfo = "您已经成功登录"
            
            queryFlow()
        }else if msg.isEqualToString("va") {
            //还未登陆
            self.loginStatus = CCUTLoginStatus.UnLogin
        }else {
            var isInCCUT = false
            
            for info in msgKey {
                
                if msg.isEqualToString(info as! String) {
                    
                    isInCCUT = true
                    
                    self.loginStatus = CCUTLoginStatus.Error
                    
                    self.loginStatusInfo = msgDic[info as! String] as? NSString
                }
            }
            if !isInCCUT {
                self.loginStatus = CCUTLoginStatus.Error
                self.loginStatusInfo = "未加入CCUT!"
            }
        }
    }
    
    //获取数据
    func queryFlow() {
        
        var pageString: NSString?
        
        do {
            pageString = try String(contentsOfURL: NSURL(string: pageURL)!, encoding: KCodeGB2312)
            
        }catch {
            
        }
        
        //获取源数据
        let timeString: NSString = pageString!.substringWithRange(NSMakeRange(332, 10))
        let time = timeString.integerValue
        
        let fString: NSString = (pageString?.substringWithRange(NSMakeRange(350, 10)))!
        let f = fString.integerValue
        
        let fee1String: NSString = (pageString?.substringWithRange(NSMakeRange(375, 10)))!
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
        self.resultArray = NSArray(array: [NSNumber(integer: time),NSNumber(integer: flow),NSNumber(integer: fee)])
        print(self.resultArray)
    }
}
