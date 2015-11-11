//
//  CCListViewCell.swift
//  iCCUT
//
//  Created by Maru on 15/10/29.
//  Copyright © 2015年 Alloc. All rights reserved.
//

import UIKit

class CCListViewCell: UICollectionViewCell {

    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var imageTitle: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func configureCell(indexPath: NSIndexPath) {
        
        bgImage.image = UIImage(named: "channel_button_\(indexPath.row)")
        
        var title: String?
        
        switch indexPath.row {
        case 0:
            title = "纪录片"
        case 1:
            title = "影视"
        case 2:
            title = "动漫"
        case 3:
            title = "学习"
        default: break
        }
        
        imageTitle.text = title!
        
    }

}
