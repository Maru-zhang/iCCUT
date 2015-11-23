//
//  UpdateNews.swift
//  iCCUT
//
//  Created by Maru on 15/11/23.
//  Copyright © 2015年 Alloc. All rights reserved.
//

import Alamofire

class UpdateNews: NSObject {
    
    
    /// 网页的解析地址
    let pageURL: String = "http://news.ccut.edu.cn/sort.php/64/"

    
    
    
    
    // MARK: - Public Method
    /**
     根据传入的页码返回一个包含NewsModel的数组
     
     - parameter index: 页码
     
     - returns: NewsModel的数组
     */
    func getNewsArray(index: NSInteger) -> NSArray {
        return NSArray()
    }
    
    
    // MARK: - Private Method
    func parserPageContent(url: String) -> String {
        
        Alamofire.request(.GET, url).responseData { (response) -> Void in
            
        }
        
        return ""
    }

    
}
