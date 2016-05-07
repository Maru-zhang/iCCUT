//
//  CCDownloadCell.swift
//  iCCUT
//
//  Created by Maru on 15/9/24.
//  Copyright © 2015年 Alloc. All rights reserved.
//

import UIKit

enum CCDownloadCellStatus {
    case Loading
    case Pause
    case Finish
}

class CCDownloadCell: UITableViewCell {

    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var videoName: UILabel!
    @IBOutlet weak var progressLable: UILabel!
    @IBOutlet weak var downloadMsg: UILabel!
    @IBOutlet weak var downloadImg: UIImageView!

    // Life Cycyle

    override func awakeFromNib() {
        
        super.awakeFromNib()
    }
    
    // MARK: - Public Method
    func configureCellWithModel(model: CCVideoDownModel) {
//        self.progressBar.progress = model.precent
//        self.progressLable.text = "\(Int(model.precent * 100))%"
//        self.videoName.text = model.name as String
        self.videoName.adjustsFontSizeToFitWidth = true
    }
    
    func setStatus(status: CCDownloadCellStatus) {
        
        switch status {
        
        case .Loading:
            downloadMsg.text = "正在下载..."
            downloadImg.image = UIImage(named: "download_begin")
            break
        case .Pause:
            downloadMsg.text = "暂停"
            downloadImg.image = UIImage(named: "download_pause")
            break
        case .Finish:
            downloadMsg.text = "已完成"
            downloadImg.image = UIImage(named: "download_begin")
            break
        }
    }
}
