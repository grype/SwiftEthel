//
//  SwiftEthelTests.swift
//  SwiftEthelTests
//
//  Created by Pavel Skaldin on 7/18/19.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

import XCTest
//import Nimble
@testable import Ethel

class TestClient : Client {
}

class ClientTests: XCTestCase {
    
    private var client: Client!

    override func setUp() {
        client = TestClient(url: URL(string: "http://localhost:8080/"), sessionConfiguration: URLSessionConfiguration.default)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInit() {
    }

//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
