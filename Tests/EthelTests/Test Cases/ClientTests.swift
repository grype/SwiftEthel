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

class ClientTests: XCTestCase {
    var client: MockClient!
    var transport: MockTransport!
    var urlString = "http://example.com/api/"

    override func setUp() {
        super.setUp()
        client = MockClient(urlString, sessionConfiguration: URLSessionConfiguration.background(withIdentifier: "test-session")).withEnabledSuperclassSpy()
        transport = MockTransport(client.session).withEnabledSuperclassSpy()
        stub(client) { stub in
            when(stub.createTransport()).thenReturn(transport)
        }
    }
    
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
            self.execute(endpoint: endpoint) { _ in
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
        expect(self.transport.request?.url) == client.baseUrl.rootURL?.resolving("relative")
    }
    
    // MARK: - Execution
    
    func testCreatesRequestContext() {
        let endpoint = client / "somewhere"
        var context: Context?
        pauseTasks()
        waitUntil { [self] done in
            execute(endpoint: endpoint) { _ in
                context = client.queue.getSpecific(key: CurrentContextKey)
                done()
            }
        }
        expect(context).toNot(beNil())
    }
    
    func testContextHasTransport() {
        let endpoint = client / "somewhere"
        var context: Context?
        pauseTasks()
        waitUntil { [self] done in
            execute(endpoint: endpoint) { _ in
                context = client.queue.getSpecific(key: CurrentContextKey)
                done()
            }
        }
        expect(context?.transport).toNot(beNil())
    }
    
    func testContextExistsOnlyDuringExecution() {
        let endpoint = client / "somewhere"
        pauseTasks()
        waitUntil { [self] done in
            execute(endpoint: endpoint) { _ in
                done()
            }
        }
        expect(self.client.queue.getSpecific(key: CurrentContextKey)).to(beNil())
    }
    
    // MARK: - Utilities
    
    fileprivate func pauseTasks() {
        stub(transport) { stub in
            when(stub.startTask()).thenDoNothing()
        }
    }
    
    private func execute(endpoint: Endpoint, with aBlock: @escaping (Transport) -> Void) {
        let _: Promise<Void> = endpoint.execute {
            Eval(aBlock)
        }
    }
}
