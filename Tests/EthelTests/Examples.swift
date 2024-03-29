//
//  File.swift
//  
//
//  Created by Pavel Skaldin on 1/8/20.
//

import XCTest
import PromiseKit
@testable import Ethel

class Examples: XCTestCase {
    
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
    
    // MARK:- Basic endpoint execution
    
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
    
    // MARK:- Per-method URL modifications
    
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
    
    // MARK:- Enumeration
    
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
        let expect = expectation(description: "first")
        queue.async {
            found = self.client.gists.public.first { (gist) -> Bool in
                gist.files?.contains(where: { (each) -> Bool in
                    each.value.language != nil
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
            each.value.language != nil
        }), "Expected at least one file w/o a language")
        print(String(describing: found?.files))
    }
    
    func testSort() {
        let expect = expectation(description: "Sorting")
        var result = [GHGist]()
        queue.async {
            let sorted = self.client.gists.public.sorted(limit: 10) { (a, b) -> Bool in
                a.created! > b.created!
            }
            result.append(contentsOf: sorted)
            expect.fulfill()
        }
        wait(for: [expect], timeout: Timeouts.short.rawValue)
        assert(!result.isEmpty, "Expected non-empty result")
        let resultTimes = result.map { $0.created! }
        assert(resultTimes == resultTimes.sorted(by: { (a, b) -> Bool in
            a > b
        }), "Result is not sorted")
    }
    
    func testCompactMap() {
        let expect = expectation(description: "Compact map")
        var result = [String]()
        queue.async {
            let mapped = self.client.gists.public.compactMap(limit: 10) { (gist) -> String? in
                return gist.gistDescription
            }
            result.append(contentsOf: mapped)
            expect.fulfill()
        }
        wait(for: [expect], timeout: Timeouts.long.rawValue)
        assert(!result.isEmpty, "Expected non-empty result")
        let descriptions = result.compactMap { return $0 }
        assert(descriptions.count == result.count, "Unexpected results from compactMap")
    }
    
    func testReduce() {
        var result: String?
        var check: String?
        let limit = 3
        let expect = expectation(description: "Reduce")
        queue.async {
            result = self.client.gists.public.reduce(limit: limit, initialResult: "", { (run, gist) -> String in
                return run.appending(gist.id!)
            })
            check = self.client.gists.public[0..<limit].reduce(into: "", { (run, gist) in
                run?.append(gist.id!)
            })
            expect.fulfill()
        }
        wait(for: [expect], timeout: Timeouts.short.rawValue)
        assert(result != nil, "Expected a non-nil result of reduce")
        assert(check != nil, "Expected a non-nil check value")
        assert(result == check, "Expected result of reduce to equal the check value")
    }
    
    func testPrefixMaxLength() {
        var result: [GHGist]?
        let limit = Int(client.gists.public.makeCursor().pageSize / 2)
        let expect = expectation(description: "Prefix with max length")
        queue.async {
            result = self.client.gists.public.prefix(limit)
            expect.fulfill()
        }
        wait(for: [expect], timeout: Timeouts.short.rawValue)
        assert(result != nil, "Expected some results")
        assert(result!.count == limit, "Unexpected number of results via prefix(maxLength)")
    }
    
    func testPrefixMaxLengthMulitpleRequests() {
        var result: [GHGist]?
        let limit = Int(Double(client.gists.public.makeCursor().pageSize) * 2.5)
        let expect = expectation(description: "Prefix with max length")
        queue.async {
            result = self.client.gists.public.prefix(limit)
            expect.fulfill()
        }
        wait(for: [expect], timeout: Timeouts.short.rawValue)
        assert(result != nil, "Expected some results")
        assert(result!.count == limit, "Unexpected number of results via prefix(maxLength)")
    }
    
    func testPrefixWhile() {
        var results: [GHGist]?
        let expect = expectation(description: "Prefix while")
        var count = 0
        let limit = Int(Double(client.gists.public.makeCursor().pageSize) * 2.5)
        queue.async {
            results = self.client.gists.public.prefix { (gist) -> Bool in
                count += 1
                return count <= limit
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: Timeouts.short.rawValue)
        assert(results != nil, "Expected some results")
        assert(results!.count == limit, "Expected \(limit) results, but got \(results!.count)")
    }
    
    // MARK:- Subscripting
    
    func testSubscript() {
        var gist: GHGist?
        var first = [GHGist]()
        let index = 3
        let expect = expectation(description: "Subscript by index")
        queue.async {
            gist = self.client.gists.public[index]
            if let found = try? self.client.gists.public.list().wait() {
                first.append(contentsOf: found)
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: Timeouts.short.rawValue)
        assert(gist != nil, "Expected to find a gist")
        assert(!first.isEmpty, "Expected a listing of public gists")
        assert(gist!.id == first[index].id)
    }
        
    func testRanging() {
        var result = [GHGist]()
        var first = [GHGist]()
        let range = 2..<5
        let expect = expectation(description: "Subscript by range")
        queue.async {
            result = self.client.gists.public[range]
            if let found = try? self.client.gists.public.list().wait() {
                first.append(contentsOf: found)
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: Timeouts.short.rawValue)
        assert(result.count == range.count, "Unexpected number of results")
        
        let resultIds = result.map { $0.id! }
        let firstIds = first[range].map { $0.id! }
        assert(firstIds == resultIds)
    }
    
}
