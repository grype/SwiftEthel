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

    func stubOutRequests() {
        stub(transport) { stub in
            when(stub.performRequest()).thenDoNothing()
        }
    }

    @discardableResult
    func execute(endpoint: Endpoint, with aBlock: ((Transport) -> Void)? = nil) async throws -> Any? {
        try await endpoint.execute {
            if let aBlock = aBlock {
                Eval(aBlock)
            }
        }
    }
}
