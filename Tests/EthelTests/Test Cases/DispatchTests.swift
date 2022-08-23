//
//  DispatchTests.swift
//  Ethel
//
//  Created by Pavel Skaldin on 10/26/21.
//  Copyright © 2021 Pavel Skaldin. All rights reserved.
//

@testable import Ethel
import Foundation
import Nimble
import XCTest

private var TestKey = DispatchSpecificKey<String>()

class DispatchTests: XCTestCase {
    func testDynamicQueueValueSetDuringBlockOnly() {
        let queue = DispatchQueue(label: "Testing")
        queue.setSpecific(key: TestKey, value: "hello") {
            expect(queue.getSpecific(key: TestKey)) == "hello"
        }
        expect(queue.getSpecific(key: TestKey)).to(beNil())
    }
}
