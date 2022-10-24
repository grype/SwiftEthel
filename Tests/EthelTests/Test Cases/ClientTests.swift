//
//  ClientTests.swift
//  Ethel
//
//  Created by Pavel Skaldin on 2/11/20.
//  Copyright © 2020 Pavel Skaldin. All rights reserved.
//

import Cuckoo
@testable import Ethel
import Foundation
import Nimble
import XCTest

class ClientTests: ClientTestCase {
    // MARK: - Init

    func testInit() {
        expect(self.client.baseUrl) == URL(string: urlString)
        expect(self.client.session).toNot(beNil())
    }
    
    // MARK: - Endpoints
    
    func testDerivedEndpointCarriesClient() {
        let endpoint = client / AbsoluteEndpoint.self
        expect(endpoint.client) === client
    }
    
    func testDerivedPluggableEndpointCarriesClass() {
        let endpoint = client / "plugged"
        expect(endpoint.client) === client
    }
    
    func testDerivesAbsolutePath() async {
        let endpoint = client / AbsoluteEndpoint.self
        stubOutRequests()
        _ = try? await execute(endpoint: endpoint)
        expect(self.transport.request?.url) == client.baseUrl.rootURL?.resolving(endpoint.path!)
    }
    
    func testDerivesRelativePath() async {
        let endpoint = client / RelativeEndpoint.self
        stubOutRequests()
        _ = try? await execute(endpoint: endpoint)
        expect(self.transport.request?.url) == client.baseUrl.resolving(endpoint.path!)
    }
    
    func testDerivesAbsolutePluggedPath() async {
        let endpoint = client / "/absolute"
        stubOutRequests()
        _ = try? await execute(endpoint: endpoint)
        expect(self.transport.request?.url) == client.baseUrl.rootURL?.resolving("/absolute")
    }
    
    func testDerivesRelativePluggedPath() async {
        let endpoint = client / "relative"
        stubOutRequests()
        _ = try? await execute(endpoint: endpoint)
        expect(self.transport.request?.url) == client.baseUrl.resolving("relative")
    }
    
    // MARK: - Execution
    
    func testCreatesRequestContext() async {
        let endpoint = client / "somewhere1"
        stubOutRequests()
        _ = try? await execute(endpoint: endpoint) { _ in
            let context = Context.current
            expect(context).toNot(beNil())
        }
    }
    
    func testContextHasTransport() async {
        let endpoint = client / "somewhere2"
        stubOutRequests()
        _ = try? await execute(endpoint: endpoint) { _ in
            expect(Context.current?.transport).toNot(beNil())
        }
    }
    
    func testContextExistsOnlyDuringExecution() async {
        let endpoint = client / "somewhere3"
        expect(Context.current).to(beNil())
        stubOutRequests()
        _ = try? await execute(endpoint: endpoint) { _ in
            expect(Context.current).toNot(beNil())
        }
        expect(Context.current).to(beNil())
    }
    
    func testUnexpectedResponseType() async throws {
        stubOutRequests()
        do {
            _ = try await execute(endpoint: client / "omg")
        }
        catch {
            expect(error).toNot(beNil())
        }
    }
}

class Uncodable: Codable {
    var uncodable: Uncodable?
}
