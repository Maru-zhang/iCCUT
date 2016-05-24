//
//  UIKit+Maru.swift
//  iCCUT
//
//  Created by Maru on 16/5/22.
//  Copyright © 2016年 Alloc. All rights reserved.
//

import Foundation

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: alpha)
    }
}

extension UIStoryboard {
    
    static func mainBoard(identifier: String) -> UIViewController! {
        return UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier(identifier)
    }
}