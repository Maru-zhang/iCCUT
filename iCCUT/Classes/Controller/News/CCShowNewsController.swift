//
//  CCShowNewsController.swift
//  iCCUT
//
//  Created by Maru on 15/10/13.
//  Copyright © 2015年 Alloc. All rights reserved.
//

import UIKit

class CCShowNewsController: UIViewController {

    
    var contentURL: NSURL?

    @IBOutlet weak var displayView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSetting()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        

    }
    

    /* Private Methpd */
    func setupSetting() {
        
        //生成请求，并加载
        let request = NSURLRequest(URL: contentURL!)
        displayView.loadRequest(request)
        //设置constrains
        displayView.translatesAutoresizingMaskIntoConstraints = false
    }

}
