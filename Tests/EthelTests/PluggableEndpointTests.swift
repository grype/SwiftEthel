//
//  File.swift
//  
//
//  Created by Pavel Skaldin on 1/27/20.
//

import Foundation
import XCTest
@testable import Ethel

class PluggableEndpointTests : XCTestCase {
    
    var client = TestClient()
    
    func testEndpointFromClient() {
        let endpoint = client / "hello"
        assert(type(of: endpoint) == PluggableEndpoint.self, "Derived endpoint is of wrong type")
        assert(endpoint.path == Path("/hello"), "Invalid path on derived pluggable endpoint")
    }
    
    func testEndpointFromEndpoint() {
        let endpoint = (client / "hello") / "world"
        assert(type(of: endpoint) == PluggableEndpoint.self, "Derived endpoint is of wrong type")
        assert(endpoint.path == Path("/hello/world"), "Invalid path on derived pluggable endpoint")
    }
}
