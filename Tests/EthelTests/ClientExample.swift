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
    var id: String?
    var url: URL?
    var isPublic: Bool?
    var created: Date?
    var updated: Date?
    var gistDescription: String?
    
    enum CodingKeys: String, CodingKey {
        case id, url
        case isPublic = "public"
        case gistDescription = "description"
        case created = "created_at"
        case updated = "updated_at"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        url = try container.decode(URL.self, forKey: .url)
        isPublic = try container.decode(Bool.self, forKey: .isPublic)
        created = ISO8601DateFormatter().date(from: try container.decode(String.self, forKey: .created))
        updated = ISO8601DateFormatter().date(from: try container.decode(String.self, forKey: .updated))
        gistDescription = try container.decode(String.self, forKey: .gistDescription)
    }
    
    var description: String {
        return "GHGist <\(id!)>"
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
    
    func gist(withId id: String) -> Promise<GHGist> {
        return getJSON(decoder: nil) { (transport) in
            transport.request?.url?.appendPathComponent(id)
        }
    }
}

struct GHIterator<U: SequenceEndpoint> : EndpointIterator {
    
    typealias Element = U.Element
    
    var endpoint: U
    
    var hasMore: Bool = true
    
    var page: Int = 1
    
    var pageSize: Int = 5
    
    private var currentOffset: Int = 0
    
    private var elements: [Element]?
    
    init(_ anEndpoint: U) {
        endpoint = anEndpoint
    }
    
    private var needsFetch: Bool {
        guard hasMore else { return false }
        return elements == nil || currentOffset >= elements!.count
    }
    
    mutating func next() -> Element? {
        guard hasMore else { return nil }
        if needsFetch {
            fetch()
        }
        
        guard let elements = elements, elements.count > currentOffset else {
            return nil
        }
        let result = elements[currentOffset]
        currentOffset += 1
        return result
    }
    
    private mutating func fetch() {
        currentOffset = 0
        do {
            elements = try endpoint.next(with: self as! U.Iterator).wait()
            hasMore = (elements?.count ?? 0) == pageSize
            page += 1
        } catch {
            print("Error: \(error)")
        }
    }
}

class GHPublicGistsEndpoint : GHEndpoint {
    
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

extension GHPublicGistsEndpoint : SequenceEndpoint {
    
    typealias Iterator = GHIterator<GHPublicGistsEndpoint>
    typealias Element = GHGist
    
    func makeIterator() -> Iterator {
        return GHIterator(self)
    }
    
    func next(with iterator: Iterator) -> Promise<[GHGist]> {
        return getJSON() { (transport) in
            transport.add(queryItem: URLQueryItem(name: "page", value: "\(iterator.page)"))
            transport.add(queryItem: URLQueryItem(name: "per_page", value: "\(iterator.pageSize)"))
        }
    }
  
}

// MARK:- Examples

class GHClientTests: XCTestCase {
    
    var client = GHClient.default
    
    override func setUp() {
        super.setUp()
        client.loggingEnabled = true
    }
    
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
    
    func testGistById() {
        let expect = expectation(description: "Getting gist by id")
        let _ = firstly {
            self.client.gists.public()
        }.then { (gists) -> Promise<GHGist> in
            self.client.gists.gist(withId: gists[0].id!)
        }.done { (gist) in
            print(String(describing: gist))
            expect.fulfill()
        }
        wait(for: [expect], timeout: 10)
    }
    
//    func testRanging() {
//        firstly {
//            client.gists.public[0..<10]
//        }.done { (gists) in
//            print(String(describing: gists))
//        }
//    }
    
    func testForEach() {
        let expect = expectation(description: "forEach")
        let limit = 15
        var all = [GHGist]()
        DispatchQueue.global(qos: .background).async {
            self.client.gists.public.forEach(limit: limit) { (gist) in
                all.append(gist)
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 10)
        assert(all.count == limit, "Expected \(limit) gists, but found \(all.count)!")
    }
    
//    func testFilter() {
//        firstly {
//            client.gists.public.filter { (gist) in
//                return Bool.random()
//            }
//        }.done { (gists) in
//            print(String(describing: gists))
//        }
//    }
    
//    func testIteratePublicGists() {
//        let iterator = client.gists.public.iterator
//        while iterator.hasMore {
//            iterator.next {
//                let gist = $0
//            }
//        }
//    }

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
