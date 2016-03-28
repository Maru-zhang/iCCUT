//
//  CCListViewController.swift
//  iCCUT
//
//  Created by Maru on 15/10/29.
//  Copyright © 2015年 Alloc. All rights reserved.
//

import UIKit


class CCListViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout {
    
    
    /// 数据源
    let dataSource: NSMutableArray = ["纪录片","学习","动漫频道","影视"]
    /// Cell列数
    let cellColum = 2
    /// Cell和边框之间的距离
    let cellEdge: UIEdgeInsets = UIEdgeInsetsMake(20, 20, 20, 20)
    /// Cell之间的距离
    let cellSpacing: CGFloat = 20
    ///  唯一标识
    var cellLength: CGFloat {
        let length = (SCREEN_BOUNDS.size.width - (2 * cellEdge.left) - (CGFloat(cellColum - 1) * cellSpacing)) / 2
        return length
    }
    private let reuseIdentifier = "ListCell"
    

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Private Method
    private func setupView() {
        
        // 设置Tabbar文字
        tabBarController?.navigationItem.title = tabBarItem.title
        
        collectionView?.backgroundColor = UIColor.whiteColor()
        
        // 搜索item
        tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Search, target: self, action: #selector(searchButtonClick))
        
    }
    

    // MARK: - UICollectionViewDataSource
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CCListViewCell
        
        cell.configureCell(indexPath, dataSource: dataSource)
        
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        
        return cell
    }

    // MARK: UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return cellEdge
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSizeMake(cellLength, cellLength * 0.7)
    }
    
    
    // MARK: - Storyboard segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let sortList = NSArray(contentsOfURL: NSBundle.mainBundle().URLForResource("MediaListName", withExtension: "plist")!)
        
        let indexPath = collectionView?.indexPathForCell(sender as! CCListViewCell)
        
        let vc = segue.destinationViewController as! CCMediaListController
        
        vc.leve1 = dataSource[(indexPath?.row)!] as? String
        
        vc.sortList = sortList![(indexPath?.row)!] as? NSArray;
        
    }
    
    // MARK: - Action
    func searchButtonClick() {
        
        let searchVC = UIStoryboard(name: "Common", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("searchVC")
        
        navigationController?.pushViewController(searchVC, animated: true)
    }
    
}
