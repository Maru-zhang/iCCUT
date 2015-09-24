//
//  CCMediaSelectView.swift
//  iCCUT
//
//  Created by Maru on 15/9/21.
//  Copyright © 2015年 Alloc. All rights reserved.
//

import UIKit

class CCMediaSelectView: UIScrollView {

    // Property
    /** 有限视角内的button数量 */
    let buttonCount = 4
    /** 按钮的宽 */
    let buttonWidth: CGFloat = 70.0
    /** 按钮的当前索引 */
    var selectedIndex = 0
    /** 得到当前的Margin */
    var buttonMargin: CGFloat {
        return (SCREEN_BOUNDS.width - buttonWidth * CGFloat(buttonCount)) / CGFloat(buttonCount)
    }
    /** 数据源 */
    var dataArray: NSArray? {
        didSet {
            setupView()
        }
    }
    /** 按钮数组 */
    lazy var buttonArray: NSMutableArray = NSMutableArray()
    
    
    
    // Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    // Private Method
    private func setupView() {
        
        createButtons()
        
        adjustButtonFrame()
        
        defaultSetting()
        
        backgroundColor = UIColor(red: 245.0/255.0, green: 245.0/255.0, blue: 245.0/255.0, alpha: 1)
    }
    
    private func createButtons() {
        
        if dataArray?.count != 0 {
            
            let count = dataArray?.count
            
            for var i = 0;i < count;i++ {
                
                let name: NSString = (dataArray?.objectAtIndex(i))! as! NSString
                
                let btn = UIButton()
                
                btn.tag = i
                
                btn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
                btn.setTitleColor(NAV_COLOR, forState: UIControlState.Selected)
                
                btn.setTitle(name as String, forState: UIControlState.Normal)
                
                btn.addTarget(self, action: Selector("selectButtonClick:"), forControlEvents: UIControlEvents.TouchUpInside)
                
                buttonArray.addObject(btn)
                
            }
        }
    }
    
    private func defaultSetting() {
        
        let defaultButton = buttonArray[selectedIndex] as! UIButton
        
        defaultButton.selected = true
        
        //默认不显示水平滚动指示器
        showsHorizontalScrollIndicator = false
        //取消弹簧属性
        bounces = false
        
    }
    
    private func adjustButtonFrame() {
        
        let count = Int((dataArray?.count)!)
        
        let totalWidth: CGFloat = buttonMargin * CGFloat(count) + buttonWidth * CGFloat(count)
        
        contentSize = CGSizeMake(totalWidth, frame.size.height)
        
        for index in 0...count - 1 {
            
            let btn: UIButton = buttonArray[index] as! UIButton

            btn.frame = CGRectMake(buttonWidth * CGFloat(index) + buttonMargin * CGFloat(index + 1), 0, buttonWidth, self.frame.size.height)
            
            addSubview(btn)
        }
        
    }
    
    // Select Action
    func selectButtonClick(sender: UIButton) {
        
        //取出原先的button
        let preButton = buttonArray[selectedIndex] as! UIButton
        //设置为不选中
        preButton.selected = false
        //传入的button选中
        sender.selected = true
        //根据tag设置新的index
        selectedIndex = sender.tag

    }
    
    
}
