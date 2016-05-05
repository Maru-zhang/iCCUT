//
//  UIStoryboard+Extension.swift
//  iCCUT
//
//  Created by Maru on 16/3/28.
//  Copyright © 2016年 Alloc. All rights reserved.
//

import Foundation


extension UIStoryboard {
    
    static func mainBoard(identifier: String) -> UIViewController! {
        return UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier(identifier)
    }
}