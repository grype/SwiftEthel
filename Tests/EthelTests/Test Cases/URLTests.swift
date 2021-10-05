//
//  File.swift
//
//
//  Created by Pavel Skaldin on 10/4/21.
//

@testable import Ethel
import Foundation
import Nimble
import XCTest

class URLTests : XCTestCase {
    
    private var url: URL!
    
    override func setUp() {
        super.setUp()
        url = URL(string: "http://example.com/test")!
    }
    
    func testDerivingFromRelativePath() {
        expect(self.url / "relative") == URL(string: "http://example.com/test/relative")
    }
    
    func testDerivingFromAbsolutePath() {
        expect(self.url / "/absolute") == URL(string: "http://example.com/absolute")
    }
}
