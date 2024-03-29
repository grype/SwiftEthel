//
//  PluggableEndpointTests.swift
//  Ethel
//
//  Created by Pavel Skaldin on 1/27/20.
//  Copyright © 2020 Pavel Skaldin. All rights reserved.
//

@testable import Ethel
import Foundation
import Nimble
import XCTest

class PluggableEndpointTests: ClientTestCase {
    func testEndpointFromClient() {
        let endpoint = client / "hello"
        expect(endpoint).to(beAnInstanceOf(PluggableEndpoint.self))
        expect(endpoint.path) == "hello"
    }

    func testEndpointFromEndpoint() {
        let endpoint = (client / "hello") / "world"
        expect(endpoint).to(beAnInstanceOf(PluggableEndpoint.self))
        expect(endpoint.path) == "hello/world"
    }

    func testGet() async throws {
        let endpoint = client / "hello"
        var transport: Transport?
        stubOutRequests()
        let _: Any? = try await endpoint.get {
            Eval { aTransport in
                transport = aTransport
            }
        }
        expect(transport?.request?.url).toNot(beNil())
        expect(transport?.request?.url) == client.baseUrl.appendingPathComponent("hello")
    }
}
