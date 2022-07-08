//
//  File.swift
//  
//
//  Created by Pavel Skaldin on 7/6/22.
//

@testable import Ethel
import Foundation
import Nimble
import PromiseKit
import XCTest

class RequestTransportBuilderTests: ClientTestCase {
    var query: URLQueryItem!
    var secondaryQuery: URLQueryItem!
    
    override func setUp() {
        super.setUp()
        query = URLQueryItem(name: "aQuery", value: "aValue")
        secondaryQuery = URLQueryItem(name: "aSecondaryQuery", value: "aSecondaryValue")
        client.prepare().apply(to: transport)
    }
    
    func testRequest() {
        let url = URL(string: "http://example.com/i-changed-this")!
        let builder = Request(url)
        builder.apply(to: transport)
        expect(self.transport.request?.url).to(equal(url))
    }
    
    func testAddQuery() {
        let builder = AddQuery(query)
        builder.apply(to: transport)
        expect(self.transport.request?.url?.query).to(equal("\(query.name)=\(query.value!)"))
    }
    
    func testAddAllQueries() {
        let builder = AddAllQueries([query, secondaryQuery])
        builder.apply(to: transport)
        expect(self.transport.request?.url?.query).to(equal("\(query.name)=\(query.value!)&\(secondaryQuery.name)=\(secondaryQuery.value!)"))
    }
}
