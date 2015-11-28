//
//  CCDownloadCell.swift
//  iCCUT
//
//  Created by Maru on 15/9/24.
//  Copyright © 2015年 Alloc. All rights reserved.
//

import UIKit

class CCDownloadCell: UITableViewCell {

    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var videoName: UILabel!
    @IBOutlet weak var progressLable: UILabel!

    // Life Cycyle

    override func awakeFromNib() {
        
        super.awakeFromNib()
    }
    
    // MARK: - Public Method
    func configureCellWithModel(model: CCVideoDownModel) {
        self.progressBar.progress = model.precent
        self.progressLable.text = "\(Int(model.precent * 100))%"
        self.videoName.text = model.name as String
        self.videoName.adjustsFontSizeToFitWidth = true
    }
}
