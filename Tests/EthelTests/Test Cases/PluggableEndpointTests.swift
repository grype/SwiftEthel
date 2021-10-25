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

    func testGet() {
        let endpoint = client / "hello"
        var transport: Transport?
        pauseTasks()
        resolveRequest(in: 0.2)
        waitUntil { done in
            let _: Promise<Void> = endpoint.get {
                Get()
                Eval { aTransport in
                    transport = aTransport
                }
            }.ensure {
                done()
            }
        }
        expect(transport?.request?.url).toNot(beNil())
        expect(transport?.request?.url) == client.baseUrl.appendingPathComponent("hello")
    }
}
