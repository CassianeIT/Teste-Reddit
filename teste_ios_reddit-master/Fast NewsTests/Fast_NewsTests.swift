//
//  Fast_NewsTests.swift
//  Fast NewsTests
//
//  Created by Lucas Moreton on 16/09/19.
//  Copyright © 2019 Lucas Moreton. All rights reserved.
//

import XCTest
@testable import Fast_News

class Fast_NewsTests: XCTestCase {

    var feed: FeedView!
    
    override func setUp() {
        feed = FeedView()
    }

    override func tearDown() {
        feed = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }


    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
