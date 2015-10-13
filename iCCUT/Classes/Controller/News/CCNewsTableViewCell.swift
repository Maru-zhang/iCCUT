//
//  CCNewsTableViewCell.swift
//  iCCUT
//
//  Created by Maru on 15/10/13.
//  Copyright © 2015年 Alloc. All rights reserved.
//

import UIKit

class CCNewsTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var time: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
