//
//  iCCUTTests.swift
//  iCCUTTests
//
//  Created by Maru on 16/3/26.
//  Copyright © 2016年 Alloc. All rights reserved.
//

import XCTest
@testable import iCCUT

class iCCUTTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    

    func testNewsViewModel() {
        let testModel = NewsViewModel()
        testModel.successHandler = {
            XCTAssert(testModel.dataSource.count != 0,"获取数据为空!")
        }
        testModel.fetchData(true)
        testModel.fetchData(false)
        
    }

    
}
