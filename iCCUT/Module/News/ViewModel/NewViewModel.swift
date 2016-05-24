
//
//  NewViewModel.swift
//  iCCUT
//
//  Created by Maru on 16/3/24.
//  Copyright © 2016年 Alloc. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class NewsViewModel: TableModelType {
    
    /// 数据源
    var dataSource: [NewsModel] = []
    /// 页数
    var pageNum = 0
    /// 头视图高度
    let headerHeight: CGFloat = 190
    /// 成功处理
    var successHandler: (() -> Void)?
    /// 失败处理
    var errorHandler: (() -> Void)?
    

    typealias CellType = CCNewsTableViewCell
    
    /**
     获取新闻数据
     
     - parameter success:	成功操作闭包
     - parameter failure:	失败操作闭包
     - parameter reset:	区分下拉/上拉操作
     */
    func fetchData(reset: Bool) {
        
        Alamofire.request(.POST, API_Route.News,parameters:["index": pageNum],encoding: .URLEncodedInURL)
            .responseJSON { (response) -> Void in
                
                if reset {
                    self.pageNum = 0
                    self.dataSource.removeAll()
                }
                
                switch response.result {
                    
                    case .Success:
                        
                        let json = JSON(response.result.value!)
                        
                        for (_,itemJson) in json["data"] {
                            // 遍历添加数据
                            var newsModel: NewsModel = NewsModel()
                            newsModel.title = itemJson["title"].stringValue
                            newsModel.url = itemJson["url"].stringValue
                            newsModel.time = itemJson["datetime"].stringValue
                            self.dataSource.append(newsModel)
                            
                        }
                        
                        // 刷新
                        self.pageNum += 1
                        
                        self.successHandler!()
                        
                        break
                    case .Failure:
                        self.errorHandler!()
                        break
                }
        }

    }
    
    /**
     更新Cell
     
     - parameter cell:	需要更新的Cell
     - parameter index:	Cell的位置
     */
    func updating(cell: CellType, index: NSIndexPath) {
        cell.title.text = dataSource[index.row].title!
        cell.time.text = dataSource[index.row].time!
    }
    
    

    /**
     根据需要返回动态的Cell高度
     
     - parameter index:	cell的位置
     
     - returns: cell的高度
     */
    func cellForHeight(index: NSIndexPath) -> CGFloat {
        return 60
    }
    
}
