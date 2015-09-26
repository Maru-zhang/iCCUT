//
//  CCMacro.swift
//  iCCUT
//
//  Created by Maru on 15/9/21.
//  Copyright © 2015年 Alloc. All rights reserved.
//  UIColor(red: 1, green: 83.0/255.0, blue: 35.0/255.0, alpha: 1)

import Foundation

/** Frame */
let SCREEN_BOUNDS: CGRect = UIScreen.mainScreen().bounds

/** Color */
let NAV_COLOR: UIColor = UIColor(red: 1, green: 83.0/255.0, blue: 35.0/255.0, alpha: 1)
let NAV_FONT_COLOR: UIColor = UIColor.whiteColor()

/** Name */
let NAV_NAME_ARRAY: NSArray = ["主页","网络","视频","我"]

/** Codeing */
let KCodeGB2312 = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.GB_18030_2000.rawValue))