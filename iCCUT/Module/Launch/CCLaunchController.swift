//
//  CCLaunchController.swift
//  iCCUT
//
//  Created by Maru on 15/9/23.
//  Copyright © 2015年 Alloc. All rights reserved.
//

import UIKit
import Cartography

class CCLaunchController: UIViewController {
    
    let image_logo = UIImageView(image: UIImage(named: "Logo_half"))
    let image_bg = UIImageView(image: UIImage(named: "LanuchBG"))
    
    override func viewDidLoad() {
        
        setupView()
    }
    
    override func viewWillLayoutSubviews() {
        
        super.viewWillLayoutSubviews()
        
        constrain(image_bg,image_logo) { (image_bg, image_logo) -> () in
            
            image_bg.top == (image_bg.superview?.top)!
            image_bg.left == (image_bg.superview?.left)!
            image_bg.right == (image_bg.superview?.right)!
            image_bg.bottom == (image_bg.superview?.bottom)!
            
            image_logo.width == 56
            image_logo.height == 56
            image_logo.bottom == (image_logo.superview?.bottom)! + 50
            image_logo.center == (image_logo.superview?.center)!
        }
    }
    
    private func setupView() {
        

        view.addSubview(image_bg)
        view.addSubview(image_logo)
        

    }
    
}
