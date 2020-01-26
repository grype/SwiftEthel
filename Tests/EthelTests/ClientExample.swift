//
//  File.swift
//  
//
//  Created by Pavel Skaldin on 1/8/20.
//

import XCTest
import PromiseKit
@testable import Ethel

class GHClientTests: XCTestCase {
    
    var client = GHClient.default
    var queue: DispatchQueue!
    
    enum Timeouts : Double {
        case short = 3
        case long = 10
    }
    
    override func setUp() {
        super.setUp()
        client.loggingEnabled = true
        queue = DispatchQueue.global(qos: .background)
    }
    
    func testListPublicGists() {
        let publicGists = client.gists.public
        publicGists.since = Date().addingTimeInterval(-86400)
        let expect = expectation(description: "Listing public gists")
        var result = [GHGist]()
        let _ = publicGists.list().done { (gists) in
            result.append(contentsOf: gists)
            expect.fulfill()
        }.catch { (error) in
            print("Error: \(error)")
            expect.fulfill()
        }
        wait(for: [expect], timeout: Timeouts.short.rawValue)
        assert(!result.isEmpty, "Expected to find at least one public gist")
    }
    
    func testGistById() {
        let expect = expectation(description: "Getting gist by id")
        let _ = firstly {
            self.client.gists.public.list()
        }.then { (gists) -> Promise<GHGist> in
            self.client.gists.gist(withId: gists[0].id!)
        }.done { (gist) in
            print(String(describing: gist))
            expect.fulfill()
        }.catch { (error) in
            print("Error: \(error)")
            expect.fulfill()
        }
        wait(for: [expect], timeout: Timeouts.short.rawValue)
    }
    
    func testForEach() {
        let expect = expectation(description: "forEach")
        let limit = 15
        var all = [GHGist]()
        queue.async {
            self.client.gists.public.forEach(limit: limit) { (gist) in
                all.append(gist)
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: Timeouts.long.rawValue)
        assert(all.count == limit, "Expected \(limit) gists, but found \(all.count)!")
    }
    
    func testFilter() {
        let expect = expectation(description: "filter")
        let limit = 5
        var all = [GHGist]()
        
        queue.async {
            let found = self.client.gists.public.filter(limit: limit) { (gist) -> Bool in
                return Bool.random()
            }
            all.append(contentsOf: found)
            expect.fulfill()
        }
        wait(for: [expect], timeout: Timeouts.long.rawValue)
        assert(all.count == limit, "Expected \(limit) gists, but found \(all.count)!")
    }
    
    func testFirst() {
        var found: GHGist?
        let language = "python"
        let expect = expectation(description: "first")
        queue.async {
            found = self.client.gists.public.first { (gist) -> Bool in
                gist.files?.contains(where: { (each) -> Bool in
                    each.value.language?.lowercased() == language
                }) ?? false
            }
            if found != nil {
                expect.fulfill()
            }
        }
        wait(for: [expect], timeout: Timeouts.short.rawValue)
        assert(found != nil, "Expected a result")
        assert(found!.files != nil, "Expected result to contain at least one file")
        assert(found!.files!.contains(where: { (each) -> Bool in
            each.value.language?.lowercased() == language
        }), "Expected at least one file w/o a language")
        print(String(describing: found?.files))
    }
    
    func testIterator() {
        var iterator = client.gists.public.makeIterator()
        var first: GHGist?
        var second: GHGist?
        
        let expect = expectation(description: "Iterator next")
        assert(iterator.hasMore, "New iterator should indicate there's more results")
        queue.async {
            first = iterator.next()
            second = iterator.next()
            expect.fulfill()
        }
        wait(for: [expect], timeout: Timeouts.short.rawValue)
        assert(first != nil, "Expected there to be at least one public gist")
        assert(second != nil, "Expected there to be at least another public gist")
        assert(first!.id != second!.id)
    }
        
//    func testRanging() {
//        firstly {
//            client.gists.public[0..<10]
//        }.done { (gists) in
//            print(String(describing: gists))
//        }
//    }
    
}
