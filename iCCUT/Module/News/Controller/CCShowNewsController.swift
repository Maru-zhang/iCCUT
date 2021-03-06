//
//  CCShowNewsController.swift
//  iCCUT
//
//  Created by Maru on 15/10/13.
//  Copyright © 2015年 Alloc. All rights reserved.
//

import UIKit
import Cartography
import Alamofire

class CCShowNewsController: UIViewController {

    
    var contentURL: NSURL?
    var webView: UIWebView = UIWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //配置视图
        setupView()
        
        //配置设置
        setupSetting()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        constrain(webView, view) { (view1, view2) -> () in
            
            view1.top      ==   view2.top
            view1.left     ==   view2.left
            view1.right    ==   view2.right
            view1.bottom   ==   view2.bottom
            
        }

    }
    

    /* Private Methpd */
    func setupView() {
        title = "资讯"
        view.addSubview(webView)
    }

    func setupSetting() {
        

        
        //生成请求，并加载
        let request = NSURLRequest(URL: contentURL!)
        webView.loadRequest(request)
        //设置constrains
        webView.translatesAutoresizingMaskIntoConstraints = false
        //设置伸缩
        webView.scalesPageToFit = true
    }

}
