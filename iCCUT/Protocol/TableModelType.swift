//
//  TableModelType.swift
//  iCCUT
//
//  Created by Maru on 16/3/24.
//  Copyright © 2016年 Alloc. All rights reserved.
//

import Foundation

protocol TableModelType {
    
    associatedtype CellType
    
    func updating(cell: CellType,index: NSIndexPath)
    func cellForHeight(index: NSIndexPath) -> CGFloat
}

extension TableModelType {
    
    func cellForHeight(index: NSIndexPath) -> CGFloat {
        return 44
    }
}