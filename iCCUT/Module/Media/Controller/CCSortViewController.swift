//
//  CCSortViewController.swift
//  iCCUT
//
//  Created by Maru on 16/3/25.
//  Copyright © 2016年 Alloc. All rights reserved.
//

import UIKit

class CCSortViewController: UICollectionViewController {

    // MARK: - Property
    var data: NSArray?
    /** 边距 */
    var edgeInset: UIEdgeInsets = UIEdgeInsetsMake(20, 20, 20, 20)
    /** 最小行间隔 */
    var minimumLineSpacing: CGFloat = 20.0
    /** Cell的大小 */
    var itemSize: CGSize = CGSizeMake(80, 40)
    /** 是否需要遮挡视图 */
    var isHaveMask: Bool = true
    /** 遮挡视图 */
    var mkView: UIView = UIView()
    /** 代理 */
    weak var sortDelegate: CCSortViewProtocol?
}
