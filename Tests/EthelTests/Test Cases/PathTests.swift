//
//  File.swift
//  
//
//  Created by Pavel Skaldin on 2/1/20.
//

import Foundation
import XCTest
@testable import Ethel

class PathTests : XCTestCase {
    
    var url: URL!
    
    override func setUp() {
        super.setUp()
        url = URL(string: "https://example.com/some/path")!
    }
    
    func testRemoveAllPathComponents() {
        url.removeAllPathComponents()
        assert(url == URL(string: "https://example.com/")!, "Unexpected URL after removing all path components")
    }
    
    func testURLResolveAbsolutePath() {
        url.resolve(Path("/absolute"))
        assert(url == URL(string: "https://example.com/absolute")!, "Unexpected URL resolve of absolute path")
    }
    
    func testURLResolveRelativePath() {
        url.resolve(Path("relative"))
        assert(url == URL(string: "https://example.com/some/path/relative"), "Unexpected URL resolve of relative path")
    }
    
}
