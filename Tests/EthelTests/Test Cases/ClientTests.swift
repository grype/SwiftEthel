//
//  File.swift
//
//
//  Created by Pavel Skaldin on 2/11/20.
//

@testable import Ethel
import Foundation
import Nimble
import PromiseKit
import XCTest

class ClientTests: XCTestCase {
    var client: Client!
    var urlString = "http://example.com/api/"

    override func setUp() {
        super.setUp()
        client = TestClient(urlString, sessionConfiguration: URLSessionConfiguration.background(withIdentifier: "test-session"))
    }

    func testInit() {
        expect(self.client.baseUrl) == URL(string: urlString)
        expect(self.client.session).toNot(beNil())
    }
}
