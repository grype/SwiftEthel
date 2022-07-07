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
    }
    
    func testAddQuery() {
        let builder = AddQuery(query)
        let transport = client.createTransport()
        builder.apply(to: transport)
        expect(transport.request?.url?.query).to(equal("\(query.name)=\(query.value!)"))
    }
    
    func testAddAllQueries() {
        let builder = AddAllQueries([query, secondaryQuery])
        let transport = client.createTransport()
        builder.apply(to: transport)
        expect(transport.request?.url?.query).to(equal("\(query.name)=\(query.value!)&\(secondaryQuery.name)=\(secondaryQuery.value!)"))
    }
}
