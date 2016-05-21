//
//  NetworkTests.swift
//  iCCUT
//
//  Created by Maru on 16/5/21.
//  Copyright © 2016年 Alloc. All rights reserved.
//

import XCTest
@testable import iCCUT
import Alamofire
import SwiftyJSON

class NetworkTests: XCTestCase {

    
    
    func testLoginServiceSuccess() {
        
        let expectation = expectationWithDescription("...")
        
        Alamofire
            .request(.POST, "http:localhost:5050/api/login", parameters: ["email":"475435200@qq.com","password":"86880362"], encoding: .URLEncodedInURL, headers: nil)
            .responseJSON { (response) in
                
                XCTAssertNotNil(response.result.value)
                let json = JSON(response.result.value!)
                XCTAssertEqual(json["code"].stringValue, "200")
                XCTAssertEqual(json["msg"], "Login success.")
                XCTAssertNotNil(json["data"])
                expectation.fulfill()
                
        }
        
        waitForExpectationsWithTimeout(10) { (error) in
            debugPrint(error)
        }

    }
    
    func testLoginSeviceFail_wrongpassword() {
        let expectation = expectationWithDescription("...")
        
        Alamofire
            .request(.POST, "http:localhost:5050/api/login", parameters: ["email":"475435200@qq.com","password":"321321321"], encoding: .URLEncodedInURL, headers: nil)
            .responseJSON { (response) in
                
                XCTAssertNotNil(response.result.value)
                let json = JSON(response.result.value!)
                XCTAssertEqual(json["code"].stringValue, "-1")
                XCTAssertEqual(json["msg"], "Incorrect password.")
                XCTAssertNotNil(json["data"])
                expectation.fulfill()
                
        }
        
        waitForExpectationsWithTimeout(10) { (error) in
            debugPrint(error)
        }
    }
    
    func testLoginServiceFail_noexitemail() {
        let expectation = expectationWithDescription("...")
        
        Alamofire
            .request(.POST, "http:localhost:5050/api/login", parameters: ["email":"XXXXXXXXXXX","password":"321321321"], encoding: .URLEncodedInURL, headers: nil)
            .responseJSON { (response) in
                
                XCTAssertNotNil(response.result.value)
                let json = JSON(response.result.value!)
                XCTAssertEqual(json["code"].stringValue, "-1")
                XCTAssertEqual(json["msg"], "Not exit such account!")
                XCTAssertNotNil(json["data"])
                expectation.fulfill()
                
        }
        
        waitForExpectationsWithTimeout(10) { (error) in
            debugPrint(error)
        }
    }
}
