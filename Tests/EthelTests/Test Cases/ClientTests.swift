//
//  File.swift
//
//
//  Created by Pavel Skaldin on 2/11/20.
//

import Cuckoo
@testable import Ethel
import Foundation
import Nimble
import PromiseKit
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
    
    func testDerivesAbsolutePath() {
        let endpoint = client / AbsoluteEndpoint.self
        pauseTasks()
        waitUntil { done in
            self.execute(endpoint: endpoint) { _ in
                done()
            }
        }
        expect(self.transport.request?.url) == client.baseUrl.rootURL?.resolving(endpoint.path!)
    }
    
    func testDerivesRelativePath() {
        let endpoint = client / RelativeEndpoint.self
        pauseTasks()
        waitUntil { done in
            self.execute(endpoint: endpoint) { _ in
                done()
            }
        }
        expect(self.transport.request?.url) == client.baseUrl.resolving(endpoint.path!)
    }
    
    func testDerivesAbsolutePluggedPath() {
        let endpoint = client / "/absolute"
        pauseTasks()
        waitUntil { done in
            self.execute(endpoint: endpoint) { aTransport in
                done()
            }
        }
        expect(self.transport.request?.url) == client.baseUrl.rootURL?.resolving("/absolute")
    }
    
    func testDerivesRelativePluggedPath() {
        let endpoint = client / "relative"
        pauseTasks()
        waitUntil { done in
            self.execute(endpoint: endpoint) { _ in
                done()
            }
        }
        expect(self.transport.request?.url) == client.baseUrl.resolving("relative")
    }
    
    // MARK: - Execution
    
    func testCreatesRequestContext() {
        let endpoint = client / "somewhere1"
        pauseTasks()
        waitUntil { [self] done in
            execute(endpoint: endpoint) { _ in
                expect(client.queue.getSpecific(key: CurrentContextKey)).toNot(beNil())
                done()
            }
        }
    }
    
    func testContextHasTransport() {
        let endpoint = client / "somewhere2"
        pauseTasks()
        waitUntil { [self] done in
            execute(endpoint: endpoint) { _ in
                let context = client.queue.getSpecific(key: CurrentContextKey)
                expect(context?.transport).toNot(beNil())
                done()
            }
        }
    }
    
    func testContextExistsOnlyDuringExecution() {
        let endpoint = client / "somewhere3"
        expect(self.client.queue.getSpecific(key: CurrentContextKey)).to(beNil())
        pauseTasks()
        resolveRequest(in: 0.25)
        waitUntil { [self] done in
            _ = execute(endpoint: endpoint) { _ in
                expect(self.client.queue.getSpecific(key: CurrentContextKey)).toNot(beNil())
            }.ensure {
                expect(self.client.queue.getSpecific(key: CurrentContextKey)).to(beNil())
                done()
            }
        }
        expect(self.client.queue.getSpecific(key: CurrentContextKey)).to(beNil())
    }
}
