//
//  JSONCodingTests.swift
//  Ethel
//
//  Created by Pavel Skaldin on 10/19/21.
//  Copyright © 2021 Pavel Skaldin. All rights reserved.
//

import Cuckoo
@testable import Ethel
import Foundation
import Nimble
import PromiseKit
import XCTest

private struct Sample: Codable, Equatable {
    var date: Date?
    var int: Int?
    var string: String?
    var bool: Bool?
    var childSamples: [Sample]?
}

private class JSONEndpoint: Endpoint {
    var client: Client
    
    var path: Path? { "json" }
    
    required init(on aClient: Client) {
        client = aClient
    }
}

class JSONCodingTests: XCTestCase {
    fileprivate var decoder: JSONDecoder!
    fileprivate var encoder: JSONEncoder!
    fileprivate var sample: Sample!
    fileprivate var client: MockClient!
    fileprivate var transport: MockTransport!
    fileprivate var urlString = "http://example.com/api/"

    override func setUp() {
        super.setUp()
        
        client = MockClient(urlString, sessionConfiguration: URLSessionConfiguration.background(withIdentifier: "test-session")).withEnabledSuperclassSpy()
        transport = MockTransport(client.session).withEnabledSuperclassSpy()
        
        stub(transport) { stub in
            when(stub.startTask()).thenDoNothing()
        }
        
        stub(client) { stub in
            when(stub.createTransport()).thenReturn(transport)
        }
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'.'SSSZZZZZ"
        
        encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(formatter)
        encoder.keyEncodingStrategy = .convertToSnakeCase
        EncodeJSON.defaultEncoder = encoder
        
        decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(formatter)
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        DecodeJSON<Bool>.defaultDecoder = decoder
        
        // Recreate date from formatted string so that we can compare equality.
        // If we don't do that, the original date will likely be a split second off from the one created by the formatter
        let date = formatter.date(from: formatter.string(from: Date()))
        
        sample = Sample(date: date, int: 1, string: "Root", bool: true, childSamples: [
            Sample(string: "Child"),
            Sample(childSamples: [Sample(int: 2), Sample(int: 3)])
        ])
    }

    func testSettingDefaultJSONDecoder() {
        let jsonDecoder = DecodeJSON<Sample>()
        expect(jsonDecoder.decoder === self.decoder).to(beTrue())
    }
    
    func testDecodeJSON() {
        let json = try! encoder.encode(sample)
        let decoder = DecodeJSON<Sample>()
        // apply to transport to setup content reader
        decoder.apply(to: transport)
        let result = try! transport.contentReader?(json)
        expect(result).to(beAKindOf(Sample.self))
        expect(result as? Sample).to(equal(sample))
    }
    
    func testEncodeJSON() {
        let encoder = EncodeJSON()
        // apply to transport to setup content reader
        encoder.apply(to: transport)
        let data = try! transport.contentWriter!(sample!)!
        let result = try! decoder.decode(Sample.self, from: data)
        expect(result).to(beAKindOf(Sample.self))
        expect(result).to(equal(sample))
    }
    
    func testEncodingTypeErasedValues() {
        let encoder = EncodeJSON()
        // apply to transport to setup content reader
        encoder.apply(to: transport)
        let sample: [String: Any] = ["one": 1, "two": "Two", "three": [1, 2, 3]]
        let data = try! transport.contentWriter!(sample)!
        let result = try! JSONSerialization.jsonObject(with: data) as! [String: Any]
        expect(result["one"]).to(beAKindOf(Int.self))
        expect(result["one"] as? Int) == sample["one"] as? Int
        expect(result["two"]).to(beAKindOf(String.self))
        expect(result["two"] as? String) == sample["two"] as? String
        expect(result["three"]).to(beAKindOf([Int].self))
        expect((result["three"] as? [Int])?.count) == 3
        expect(result["three"] as? [Int]) == sample["three"] as? [Int]
    }
}
