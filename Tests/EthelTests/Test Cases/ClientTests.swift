//
//  File.swift
//  
//
//  Created by Pavel Skaldin on 2/11/20.
//

import Foundation
import XCTest
@testable import Ethel

class ClientTests : XCTestCase {
    
    var client: Client!
    var urlString = "http://example.com/api/"
    
    override func setUp() {
        super.setUp()
        client = TestClient(urlString, sessionConfiguration: URLSessionConfiguration.background(withIdentifier: "test-session"))
    }
    
    func testInit() {
        XCTAssertEqual(client.baseUrl, URL(string: urlString)!)
        XCTAssertNotNil(client.session)
    }
    
    func testRelativeEndpointComposition() {
        let endpoint = client / RelativeEndpoint.self
        let transport = client.createTransport()
        client.configure(on: transport)
        endpoint.configure(on: transport)
        XCTAssertEqual(transport.request!.url, client.baseUrl!.resolving(endpoint.path))
    }
}
