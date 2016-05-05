//
//  SCLAlertViewExtension.swift
//  iCCUT
//
//  Created by Maru on 15/11/26.
//  Copyright © 2015年 Alloc. All rights reserved.
//

import SCLAlertView

extension SCLAlertView {
    
    /**
     快速显示一个网络错误的提示框
     */
    static func showNetworkErrorView() {
        
        let alertView = SCLAlertView()
        alertView.showCloseButton = false
        alertView.showError("温馨提示", subTitle: "网络连接失败，请检查是否连接至CCUT！",duration: 1.5)
        
    }
    
    /**
     快速显示一个温馨提示框
     
     - parameter content: 提示的内容
     */
    static func showPromptView(content: String) {
        let alertView = SCLAlertView()
        alertView.showCloseButton = false
        alertView.showNotice("温馨提示", subTitle: content,duration: 1)
    }
}