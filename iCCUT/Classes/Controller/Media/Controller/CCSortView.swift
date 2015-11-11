//
//  CCSortView.swift
//  iCCUT
//
//  Created by Maru on 15/10/29.
//  Copyright © 2015年 Alloc. All rights reserved.
//

import UIKit

class CCSortView: UICollectionView,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    // MARK: - Property
    var data: NSMutableArray?
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

    /** 缓存标识 */
    private let reuseIdentifier = "CCSortCell"
    
    
    
    // MARK: - Life Cycle
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: UICollectionViewFlowLayout())
        
        setupView()
        
        setupSetting()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Mrthod
    private func setupView() {
        backgroundColor = UIColor.whiteColor()
        
    }
    
    private func setupSetting() {
        
        
        delegate = self
        dataSource = self
        
        //注册一个类
        self.registerClass(CCSortViewCell.classForCoder(), forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    private func showView() {
        
    }
    
    private func dismissView() {
        
    }
    
    // MARK: - Override
    override func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        
        guard (newSuperview != nil) else {
            return
        }
        
        //如果是scorlView那么就禁止它的滚动
        if let superView = newSuperview as? UIScrollView {
            superView.scrollEnabled = false
        }
        
        let width = newSuperview?.bounds.width
        let height = newSuperview?.bounds.height
        let targetH = bounds.height
        frame = CGRectMake(0, 0, frame.width, 0)

        
        if isHaveMask {
            mkView.userInteractionEnabled = true
            mkView.backgroundColor = UIColor.blackColor()
            mkView.alpha = 0.2;
            mkView.frame = CGRectMake(0, bounds.height, width!,height!)
            newSuperview!.addSubview(mkView)
        }
        View.animateWithDuration(0.6, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0, options: UIViewAnimationOptions.LayoutSubviews, animations: { () -> Void in
            self.frame = CGRectMake(0, 0, self.frame.width, targetH)
            self.mkView.frame = CGRectMake(0, self.bounds.height, width!,height! - self.bounds.height)
            }) { (bool) -> Void in
        }
        
    }
    
    override func removeFromSuperview() {
        //如果是scorlView那么就允许它的滚动
        if let superView = superview as? UIScrollView {
            superView.scrollEnabled = true
        }
        mkView.removeFromSuperview()
        super.removeFromSuperview()
    }
    
    // MARK: - CollectionView DataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Int(20)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)
        
        print(cell)
        
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
}
