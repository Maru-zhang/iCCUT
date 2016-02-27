//
//  CCSortViewCell.swift
//  iCCUT
//
//  Created by Maru on 15/10/30.
//  Copyright © 2015年 Alloc. All rights reserved.
//

import UIKit

class CCSortViewCell: UICollectionViewCell {
    
    
    // MARK: - Property
    let textLableL: UILabel = UILabel()

    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Method
    private func setupView() {
        alpha = 0.7
        backgroundColor = UIColor.clearColor()
        
        textLableL.frame = CGRectMake(0, 0, bounds.width, bounds.height)
        textLableL.font = UIFont(name: "Helvetica", size: 10)
        textLableL.textColor = UIColor.whiteColor()
        textLableL.numberOfLines = 0
        textLableL.lineBreakMode = .ByClipping
        textLableL.textAlignment = .Center
        addSubview(textLableL)
    }
}
