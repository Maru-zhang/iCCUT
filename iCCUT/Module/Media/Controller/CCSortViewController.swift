//
//  CCSortViewController.swift
//  iCCUT
//
//  Created by Maru on 16/3/25.
//  Copyright © 2016年 Alloc. All rights reserved.
//

import UIKit

protocol CCSortViewProtocol: NSObjectProtocol {
    func sortView(indexPath: NSIndexPath)
}

class CCSortViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout {

    // MARK: - Property
    var data: NSArray?
    /** 边距 */
    private let edgeInset: UIEdgeInsets = UIEdgeInsetsMake(20, 20, 20, 20)
    /** 最小行间隔 */
    private let minimumLineSpacing: CGFloat = 20.0
    /** Cell的大小 */
    private let itemSize: CGSize = CGSizeMake(80, 40)
    /** 代理 */
    weak var sortDelegate: CCSortViewProtocol?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        
        setupView()
        
        setupSetting()
        
    }
    
    
    // MARK: - Private Method
    private func setupView() {
                
        collectionView?.backgroundColor = UIColor.whiteColor()
        
    }
    
    private func setupSetting() {
        
        //注册一个类
        collectionView?.registerClass(CCSortViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(CCSortViewCell))
    }
    
    
    
    // MARK: - CollectionView DataSource
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard (data != nil) else {
            return 0
        }
        return (data?.count)!
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(NSStringFromClass(CCSortViewCell), forIndexPath: indexPath) as! CCSortViewCell
        
        cell.backgroundColor = NAV_COLOR;
        cell.layer.cornerRadius = 5;
        cell.textLableL.text = data![indexPath.row] as? String
        
        return cell
    }
    

    // MARK: - CollectionView Delegate
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return edgeInset
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return minimumLineSpacing
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return itemSize
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        guard let _ = sortDelegate else {
            return
        }
        sortDelegate?.sortView(indexPath)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}
