//
//  CCMediaInfoCell.swift
//  iCCUT
//
//  Created by Maru on 16/5/6.
//  Copyright © 2016年 Alloc. All rights reserved.
//

import UIKit

class CCMediaInfoCell: UITableViewCell {

    @IBOutlet weak var mediaName: UILabel!
    @IBOutlet weak var download: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        download.setTitle("", forState: .Normal)
        download.setTitle("已下载", forState: .Selected)
    }

    
}
