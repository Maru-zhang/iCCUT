
//
//  CCToastService.swift
//  iCCUT
//
//  Created by Maru on 16/5/27.
//  Copyright © 2016年 Alloc. All rights reserved.
//

import UIKit
import JLToast

class CCToastService {
    
    /**
     最普通的显示一则信息
     
     - parameter msg:	信息
     */
    static func showMessage(msg: String) {
        JLToast.makeText(msg).show()
    }

    /**
     联网失败显示的Toast
     */
    static func showNetworkFail() {
        JLToast.makeText("网络连接失败...").show()
    }
}
