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

class GHGist : Codable, CustomStringConvertible {
    var url: URL
    var isPublic: Bool
    var created: Date
    var updated: Date?
    var gistDescription: String?
    
    init(url aUrl: URL, public aPublic: Bool, created aCreatedDate: Date = Date()) {
        url = aUrl
        isPublic = aPublic
        created = aCreatedDate
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
    var baseUrl: URL {
        return configuration.url
    }
    
    var session: URLSession = URLSession(configuration: URLSessionConfiguration.background(withIdentifier: "GHClient"))
    
    static var `default` = GHClient(configuration: GHClientConfiguration.default)
    
    var configuration: GHClientConfiguration
    
    var dateFormatter = ISO8601DateFormatter()
    
    var gists : GHGistsEndpoint {
        return self / GHGistsEndpoint.self
    }
    
    init(configuration aConfig: GHClientConfiguration) {
        configuration = aConfig
    }
}

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

// MARK:- Endpoints

class GHGistsEndpoint : GHEndpoint {
    
    override class var path: Path { GHEndpoint.path / "gists" }
    
    var `public` : GHPublicGistsEndpoint {
        return self / GHPublicGistsEndpoint.self
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
        let url = (client.baseUrl / path)!
        let request = URLRequest(url: url)
        
        // TODO: try using publisher as a means of executing requests and mapping responses
        // You'd call Client.execute() with a block, the client will call the block with configured DataTaskPublisher,
        // the endpoint method will then do all the mapping and decoding?!
        let result = client.session.dataTaskPublisher(for: request).map { $0.data }.decode(type: GHGist.self, decoder: JSONDecoder())
        
        return execute { http in
            http.request?.httpMethod = "GET"
        }
    }
}

// MARK:- Examples

class GHClientTests: XCTestCase {
    
    var client = GHClient.default
    
    func testListPublicGists() {
        let publicGists = client.gists.public
        publicGists.since = Date().addingTimeInterval(-86400)
        let _ = publicGists.list().done { (gists) in
            print(String(describing: gists))
        }
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
