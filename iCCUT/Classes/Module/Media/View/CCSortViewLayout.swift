//
//  CCSortViewLayout.swift
//  iCCUT
//
//  Created by Maru on 15/10/30.
//  Copyright © 2015年 Alloc. All rights reserved.
//

import UIKit

class CCSortViewLayout: UICollectionViewLayout {

    /** 列数 */
    var columnNumber: Int = 4
    /** CollectionView边距 */
    var edgeInset: UIEdgeInsets = UIEdgeInsetsMake(20, 20, 20, 20)
    /** Cell间距 */
    var cellSpacing: CGFloat = 20
    /** Cell的高度 */
    var cellHeight: CGFloat = 80
    /** cell的宽高 */
    var cellSize: CGSize {
        let width = ((collectionView?.bounds.width)! - (edgeInset.left * 2) - (cellSpacing * 3)) / 4
        return CGSizeMake(width, cellHeight)
    }
    
    
    // MARK: - Override
    
}
