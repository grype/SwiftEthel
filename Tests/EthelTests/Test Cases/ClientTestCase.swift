//
//  ClientTestCase.swift
//  Ethel
//
//  Created by Pavel Skaldin on 10/24/21.
//  Copyright © 2021 Pavel Skaldin. All rights reserved.
//

import Cuckoo
@testable import Ethel
import Foundation
import PromiseKit
import XCTest

class ClientTestCase: XCTestCase {
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

    // MARK: - Utilities

    func pauseTasks() {
        stub(transport) { stub in
            when(stub.startTask()).thenDoNothing()
        }
    }

    func resolveRequest(in timeout: TimeInterval) {
        stub(client) { stub in
            when(stub.execute(transport: any(), completion: any())).then { _, completion in
                DispatchQueue.global().asyncAfter(deadline: .now() + timeout) {
                    completion()
                }
            }
        }
    }

    @discardableResult
    func execute(endpoint: Endpoint, with aBlock: @escaping (Transport) -> Void) -> Promise<Any?> {
        return endpoint.execute {
            Eval(aBlock)
        }
    }
}
