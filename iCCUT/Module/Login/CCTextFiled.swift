//
//  CCTextFiled.swift
//  iCCUT
//
//  Created by Maru on 15/9/26.
//  Copyright © 2015年 Alloc. All rights reserved.
//

import UIKit

class CCTextFiled: UITextField {

    override func awakeFromNib() {
        textColor = UIColor.whiteColor()
        font = UIFont(name: "System", size: 20)
    }
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectMake(bounds.width * 0.15 , 0, bounds.width * 0.8, bounds.height)
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectMake(bounds.width * 0.15 , 0, bounds.width * 0.8, bounds.height)
    }
    
    override func placeholderRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectMake(bounds.width * 0.15 , 0, bounds.width * 0.8, bounds.height)
    }

}
