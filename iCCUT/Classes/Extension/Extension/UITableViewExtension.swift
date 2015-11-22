//
//  UITableViewExtension.swift
//  iCCUT
//
//  Created by Maru on 15/11/20.
//  Copyright © 2015年 Alloc. All rights reserved.
//

import Foundation

extension UITableView {
    /**
     当数据源为空时，显示的方式
     
     - parameter message: 提示内容
     - parameter count:   数据数组数量
     */
    func tableViewDisplay(emptyMessage message: String,count: NSInteger) {
        guard count == 0 else {
            backgroundView = nil
            separatorStyle = .SingleLine
            return
        }
        
        let lable = UILabel()
        lable.text = message
        lable.textColor = UIColor.lightGrayColor()
        lable.textAlignment = .Center
        backgroundView = lable
        separatorStyle = .None
        
    }
}