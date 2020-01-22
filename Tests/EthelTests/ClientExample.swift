//
//  File.swift
//  
//
//  Created by Pavel Skaldin on 1/8/20.
//

import XCTest
import PromiseKit
@testable import Ethel

// MARK:- Models

struct GHGist : Codable, CustomStringConvertible {
    var url: URL
    var isPublic: Bool
    var created: Date
    var updated: Date?
    var gistDescription: String?
    
    enum CodingKeys: String, CodingKey {
        case url
        case isPublic = "public"
        case gistDescription = "description"
        case created = "created_at"
        case updated = "updated_at"
    }
    
    init(url aUrl: URL, public aPublic: Bool, created aCreatedDate: Date = Date()) {
        url = aUrl
        isPublic = aPublic
        created = aCreatedDate
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        url = try container.decode(URL.self, forKey: .url)
        isPublic = try container.decode(Bool.self, forKey: .isPublic)
        created = ISO8601DateFormatter().date(from: try container.decode(String.self, forKey: .created))!
        updated = ISO8601DateFormatter().date(from: try container.decode(String.self, forKey: .updated))
        gistDescription = try container.decode(String.self, forKey: .gistDescription)
    }
    
    var description: String {
        return "GHGist <\(url)>"
    }
}

// MARK:- Configuration

struct GHClientConfiguration {
    var url: URL
    var authToken: String?
    
    static var `default` = GHClientConfiguration(url: URL(string: "https://api.github.com/")!, authToken: nil)
}

// MARK:- Client

class GHClient : Client {
    override var baseUrl: URL? { return configuration.url }
    
    static var `default` = GHClient(configuration: GHClientConfiguration.default)
    
    var configuration: GHClientConfiguration
    
    var dateFormatter = ISO8601DateFormatter()
    
    init(configuration aConfig: GHClientConfiguration) {
        configuration = aConfig
        super.init(url: aConfig.url, sessionConfiguration: URLSessionConfiguration.background(withIdentifier: "GHClient"))
    }
    
    // MARK: Endpoints
    
    var gists : GHGistsEndpoint {
        return self / GHGistsEndpoint.self
    }
    
}

// MARK:- Endpoints

class GHEndpoint : Endpoint {
    class var path: Path {
        return Path()
    }
    
    var client: Client
    
    var dateFormatter: ISO8601DateFormatter {
        return (client as! GHClient).dateFormatter
    }
    
    required init(on aClient: Client) {
        client = aClient
    }
}

class GHPaginatedEndpoint : GHEndpoint {
    
}

class GHGistsEndpoint : GHEndpoint {
    
    override class var path: Path { GHEndpoint.path / "gists" }
    
    var `public` : GHPublicGistsEndpoint {
        return self / GHPublicGistsEndpoint.self
    }
    
    func `public`(since: Date? = nil) -> Promise<[GHGist]> {
        let ep = self.public
        ep.since = since
        return ep.list()
    }
}

class GHPublicGistsEndpoint : GHPaginatedEndpoint {
    override class var path : Path { GHGistsEndpoint.path / "public" }
    
    var since: Date?
    
    func configure(on aTransport: Transport) {
        if let since = since {
            aTransport.add(queryItem: URLQueryItem(name: "since", value: dateFormatter.string(from: since)))
        }
    }
    
    func list() -> Promise<[GHGist]> {
        return getJSON()
    }
}

// MARK:- Examples

class GHClientTests: XCTestCase {
    
    var client = GHClient.default
    
    func testListPublicGists() {
        let publicGists = client.gists.public
        publicGists.since = Date().addingTimeInterval(-86400)
        let expect = expectation(description: "Listing public gists")
        let _ = publicGists.list().done { (gists) in
            print(String(describing: gists))
            expect.fulfill()
        }
        wait(for: [expect], timeout: 10)
    }
    
    func testListPublicGistsShortcut() {
        let expect = expectation(description: "Listing public gists")
        let _ = client.gists.public(since: Date().addingTimeInterval(-86400)).done { (gists) in
            print(String(describing: gists))
            expect.fulfill()
        }
        wait(for: [expect], timeout: 10)
    }
    
//    func testIteratePublicGists() {
//        let iterator = client.gists.public.iterator
//        while iterator.hasMore {
//            iterator.next {
//                let gist = $0
//            }
//        }
//    }
//
//    func testRangingPublicGists() {
//        client.gists.public.iterator.first(10).then {
//            let gists = $0
//        }
//        client.fists.public.iterator[10..<20].then {
//            let gists = $0
//        }
//    }
//
//    func testPaginatingPublicGists() {
//        client.gists.public.iterator.from(0, to: 100, by: 20).then {
//
//        }
//    }
}
