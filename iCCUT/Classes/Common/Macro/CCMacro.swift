//
//  CCMacro.swift
//  iCCUT
//
//  Created by Maru on 15/9/21.
//  Copyright © 2015年 Alloc. All rights reserved.
//  UIColor(red: 1, green: 83.0/255.0, blue: 35.0/255.0, alpha: 1) yuanlai
//  20	178	208

import Foundation

//****** Frame *****************************
/** 屏幕Bounds */
let SCREEN_BOUNDS: CGRect = UIScreen.mainScreen().bounds
/** 状态栏的Frame */
let STATUS_FRAME = UIApplication.sharedApplication().statusBarFrame

//****** Color *****************************
/** 导航栏颜色 */
let NAV_COLOR: UIColor = UIColor(red: 20.0/255.0, green: 178.0/255.0, blue: 208.0/255.0, alpha: 1)
/** 导航栏字体颜色 */
let NAV_FONT_COLOR: UIColor = UIColor.whiteColor()

//****** Name *****************************
/** TabbarItem文字数组 */
let NAV_NAME_ARRAY: NSArray = ["主页","网络","视频","我"]

//****** Codeing *****************************
let KCodeGB2312 = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.GB_18030_2000.rawValue))

//****** Key *****************************
let KACCOUNT = "account"
let KPASSWORD = "password"
let KUSER_TYPE = "userType"
let KAUTO_LOGIN = "isAutoLogin"
let KLOCAL_VIDEO = "local_video"

//****** Dedug *****************************
let DEBUG_LOG = true

//****** Path *****************************
/** 沙盒文档路径 */
var DIR_PATH: NSURL {
    var temp: NSURL?
        do {
            temp = try NSFileManager().URLForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomain: NSSearchPathDomainMask.UserDomainMask, appropriateForURL: nil, create: true)
        }catch {
            
        }
    return temp!
}

//****** Time *****************************
/** 当前系统时间 */
var CUR_TIME: NSString {
    let formmatter = NSDateFormatter()
    formmatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let time = formmatter.stringFromDate(NSDate()) as NSString
    return time
}