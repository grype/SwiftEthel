//
//  PathTests.swift
//  Ethel
//
//  Created by Pavel Skaldin on 2/1/20.
//  Copyright © 2020 Pavel Skaldin. All rights reserved.
//

@testable import Ethel
import Foundation
import Nimble
import XCTest

class PathTests: XCTestCase {
    var url: URL!
    
    override func setUp() {
        super.setUp()
        url = URL(string: "https://example.com/some/path")!
    }
    
    func testRemoveAllPathComponents() {
        url.removeAllPathComponents()
        expect(self.url).to(equal(URL(string: "https://example.com/")!))
    }
    
    func testAbsoluteStringLiteral() {
        let path: Path = "/foo/bar"
        expect(path.isAbsolute).to(beTrue())
    }
    
    func testRelativeStringLiteral() {
        let path: Path = "foo/bar"
        expect(path.isAbsolute).to(beFalse())
    }
    
    func testURLResolveAbsolutePath() {
        url.resolve("/absolute")
        expect(self.url).to(equal(URL(string: "https://example.com/absolute")!))
    }
    
    func testURLResolveRelativePath() {
        url.resolve("relative")
        expect(self.url).to(equal(URL(string: "https://example.com/some/path/relative")))
    }
}
