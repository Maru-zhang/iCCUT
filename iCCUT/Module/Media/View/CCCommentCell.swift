//
//  CCCommentCell.swift
//  iCCUT
//
//  Created by Maru on 16/5/6.
//  Copyright © 2016年 Alloc. All rights reserved.
//

import UIKit

class CCCommentCell: UITableViewCell {

    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var commentTime: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var goodCount: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        selectionStyle = .None
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    
}
