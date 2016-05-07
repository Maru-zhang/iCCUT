//
//  CCEditViewController.swift
//  iCCUT
//
//  Created by Maru on 16/5/6.
//  Copyright © 2016年 Alloc. All rights reserved.
//

import UIKit

class CCEditViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        textView.becomeFirstResponder()
        
    }

    // MARK: - Action
    @IBAction func closeAction(sender: AnyObject) {
        
        dismissViewControllerAnimated(false, completion: nil)
    }
    @IBAction func submitAction(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

}
