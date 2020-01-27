//
//  File.swift
//  
//
//  Created by Pavel Skaldin on 1/27/20.
//

import Foundation
import XCTest
import PromiseKit
@testable import Ethel

class PluggableEndpointTests : XCTestCase {
    
    var client: TestClient!
    let baseURL = URL(string: "https://example.com")!
    
    override func setUp() {
        super.setUp()
        client = TestClient(url: baseURL, sessionConfiguration: URLSessionConfiguration.default)
    }
    
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
    
    func testGet() {
        let endpoint = client / "hello"
        var transport: Transport!
        let promise: Promise<Any> = endpoint.get { (http) in
            transport = http
        }
        assert(promise.isPending, "Expecting a pending promise")
        assert(transport.request?.url != nil, "Expected there to be a request with URL")
        assert(transport.request!.url! == baseURL.appendingPathComponent("hello"))
    }
}
