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
        backgroundColor = UIColor.clearColor()
        
        textLableL.frame = CGRectMake(0, 0, bounds.width, bounds.height)
        textLableL.textAlignment = .Center
        textLableL.text = "Test"
        addSubview(textLableL)
    }
}
