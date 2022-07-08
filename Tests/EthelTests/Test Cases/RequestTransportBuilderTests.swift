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
    
    // MARK: - Request
    
    func testRequest() {
        let url = URL(string: "http://example.com/i-changed-this")!
        let builder = Request(url)
        builder.apply(to: transport)
        expect(self.transport.request?.url).to(equal(url))
    }
    
    // MARK: - HTTP Method
    
    func testGetMethod() {
        let builder = Get()
        builder.apply(to: transport)
        expect(self.transport.request?.httpMethod) == "GET"
    }
    
    func testGetMethodWithURL() {
        let builder = Get("/to/hell")
        builder.apply(to: transport)
        expect(self.transport.request?.url?.path) == "/to/hell"
    }
    
    // MARK: - Query
    
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
    
    // MARK: - Header
    
    func testSetHeader() {
        let builder = SetHeader(name: "X-Test", value: "My Value")
        builder.apply(to: transport)
        expect(self.transport.request?.value(forHTTPHeaderField: "X-Test")) == "My Value"
    }
    
    func testAddHeader() {
        AddHeader(name: "X-Test", value: "1").apply(to: transport)
        AddHeader(name: "X-Test", value: "2").apply(to: transport)
        expect(self.transport.request?.value(forHTTPHeaderField: "X-Test")) == "1,2"
    }
    
    // MARK: - Content
    
    func testContent() {
        let data = "My Content".data(using: .utf8)
        Content(data).apply(to: transport)
        expect(self.transport.requestContents as! Data) == data
    }
}
