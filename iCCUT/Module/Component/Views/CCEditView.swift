//
//  CCEditView.swift
//  iCCUT
//
//  Created by Maru on 16/5/7.
//  Copyright © 2016年 Alloc. All rights reserved.
//

import UIKit

class CCEditView: UIView,UITextFieldDelegate {

    var commentBlock: ((textFiled: UITextField) -> Void)?
    private var icon: UIImageView!
    private var textField: UITextField!
    private let margin: CGFloat = 10.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        textField = UITextField()
        icon = UIImageView(image: UIImage(named: "media_comment"))
        icon.frame = CGRectMake(margin / 2, margin, frame.height - margin * 2, frame.height - margin * 2)
        textField.borderStyle = .RoundedRect
        textField.placeholder = "我来说几句"
        textField.delegate = self
        textField.frame = CGRectMake(frame.height - margin, margin / 2, frame.width - frame.height, frame.height - margin)
        textField.returnKeyType = .Send
        backgroundColor = UIColor.whiteColor()
        addSubview(textField)
        addSubview(icon)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        super.drawRect(rect)
    }
    
    
    // MARK: - TextField Delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if let block = commentBlock {
            block(textFiled: textField)
        }
        return true
    }
 

}
