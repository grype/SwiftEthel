//
//  File.swift
//
//
//  Created by Pavel Skaldin on 1/27/20.
//

@testable import Ethel
import Foundation
import Nimble
import PromiseKit
import XCTest

class PluggableEndpointTests: XCTestCase {
    var client: TestClient!
    let baseURL = URL(string: "https://example.com")!
    
    override func setUp() {
        super.setUp()
        client = TestClient(baseURL, sessionConfiguration: .default)
    }
    
    func testEndpointFromClient() {
        let endpoint = client / "hello"
        expect(endpoint).to(beAnInstanceOf(PluggableEndpoint.self))
        expect(endpoint.path) == "/hello"
    }
    
    func testEndpointFromEndpoint() {
        let endpoint = (client / "hello") / "world"
        expect(endpoint).to(beAnInstanceOf(PluggableEndpoint.self))
        expect(endpoint.path) == "/hello/world"
    }
    
    func testGet() {
        let endpoint = client / "hello"
        let promise: Promise<Any> = endpoint.get {
            Get()
        }
        let transport: Transport = client.tasks.first!.value
        expect(promise.isPending).to(beTrue())
        expect(transport.request?.url).toNot(beNil())
        expect(transport.request!.url!) == baseURL.appendingPathComponent("hello")
    }
}
