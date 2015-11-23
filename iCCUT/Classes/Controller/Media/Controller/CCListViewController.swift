//
//  CCListViewController.swift
//  iCCUT
//
//  Created by Maru on 15/10/29.
//  Copyright © 2015年 Alloc. All rights reserved.
//

import UIKit


class CCListViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout {
    
    
    /** 数据源 */
    let dataSource: NSMutableArray = ["纪录片","学习","动漫频道","影视"]
    /** 布局 */
    let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    /** 唯一标识 */
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
        
        //设置Tabbar文字
        tabBarController?.navigationItem.title = tabBarItem.title
        
        self.collectionView?.backgroundColor = UIColor.whiteColor()
        
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
        
        return cell
    }

    // MARK: UICollectionViewDelegate
    
    
    // MARK: - Storyboard segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let sortList = NSArray(contentsOfURL: NSBundle.mainBundle().URLForResource("MediaListName", withExtension: "plist")!)
        
        let indexPath = collectionView?.indexPathForCell(sender as! CCListViewCell)
        
        let vc = segue.destinationViewController as! CCMediaListController
        
        vc.leve1 = dataSource[(indexPath?.row)!] as? String
        
        vc.sortList = sortList![(indexPath?.row)!] as? NSArray;
        
    }
    
}
