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
    
    
    func configureCell(indexPath: NSIndexPath, dataSource: NSArray) {
        
        bgImage.image = UIImage(named: "channel_button_\(indexPath.row)")
        imageTitle.text = dataSource[indexPath.row] as? String
        
    }

}
