//
//  File.swift
//
//
//  Created by Pavel Skaldin on 1/8/20.
//

import Beacon
@testable import Ethel
import Nimble
import PromiseKit
import XCTest

/**
 These are examples that actually generate requests and are not meant to be run as a unit test, as the requsts are lilekly to timeout at some point.
 */

class GHClientExamples: XCTestCase {
    var client = GHClient.default
    var queue: DispatchQueue!
    let logger: ConsoleLogger = .init(name: "Examples")
    
    enum Timeouts: Double {
        case short = 3
        case long = 10
    }
    
    override func setUp() {
        super.setUp()
        queue = DispatchQueue.global(qos: .background)
        logger.start()
    }
    
    override func tearDown() {
        super.tearDown()
        logger.stop()
    }
    
    // MARK: - Basic endpoint execution
    
    func testListPublicGists() {
        let publicGists = client.gists.public
        publicGists.since = Date().addingTimeInterval(-86400)
        var result = [GHGist]()
        waitUntil { done in
            _ = publicGists.fetch().done { gists in
                result.append(contentsOf: gists)
            }.ensure {
                done()
            }
        }
        expect(result.isEmpty).to(beFalse())
    }
    
    // MARK: - Per-method URL modifications
    
    func testGistById() {
        var result: GHGist?
        waitUntil { done in
            firstly {
                self.client.gists.fetch()
            }.then { gists -> Promise<GHGist> in
                self.client.gist(id: gists[0].id!).get()
            }.done { gist in
                result = gist
            }.ensure {
                done()
            }.catch { error in
                print("Error: \(error)")
            }
        }
        expect(result).toNot(beNil())
    }
    
    // MARK: - Enumeration

    func testForEach() {
        let limit = 15
        var all: [GHGist] = .init()
        waitUntil { done in
            self.client.queue.async {
                self.client.gists.public.forEach(limit: limit) { gist in
                    all.append(gist)
                }
                done()
            }
        }
        expect(all.count) == limit
    }

    func testFilter() {
        let limit = 5
        var all = [GHGist]()
        
        waitUntil { done in
            self.client.queue.async {
                let found = self.client.gists.public.filter(limit: limit) { _ -> Bool in
                    Bool.random()
                }
                all.append(contentsOf: found)
                done()
            }
        }
        expect(all.count) == limit
    }

    func testFirst() {
        var found: GHGist?
        
        waitUntil { done in
            self.client.queue.async {
                found = self.client.gists.public.first { gist -> Bool in
                    gist.files?.contains(where: { each -> Bool in
                        each.value.language != nil
                    }) ?? false
                }
                done()
            }
        }
        
        expect(found).toNot(beNil())
        expect(found!.files).toNot(beNil())
        expect(found!.files).to(containElementSatisfying { each in
            each.value.language != nil
        })
    }

    func testSort() {
        var result = [GHGist]()
        waitUntil { done in
            self.client.queue.async {
                let sorted = self.client.gists.public.sorted(limit: 10) { a, b -> Bool in
                    a.created! > b.created!
                }
                result.append(contentsOf: sorted)
                done()
            }
        }
        expect(result.isEmpty).to(beFalse())
        let resultTimes = result.map { $0.created! }
        expect(resultTimes) == resultTimes.sorted(by: { a, b -> Bool in
            a > b
        })
    }

    func testCompactMap() {
        var result = [String]()
        waitUntil { done in
            self.client.queue.async {
                let mapped = self.client.gists.public.compactMap(limit: 10) { gist -> String? in
                    gist.gistDescription
                }
                result.append(contentsOf: mapped)
                done()
            }
        }
        
        expect(result.isEmpty).to(beFalse())
        let descriptions = result.compactMap { $0 }
        expect(descriptions.count) == result.count
    }

    func testReduce() {
        var result: String?
        var check: String?
        let limit = 3
        waitUntil { done in
            self.client.queue.async {
                result = self.client.gists.public.reduce(limit: limit, initialResult: "") { run, gist -> String in
                    run.appending(gist.id!)
                }
                check = self.client.gists.public[0 ..< limit].reduce(into: "") { run, gist in
                    run?.append(gist.id!)
                }
                done()
            }
        }
        
        expect(result).toNot(beNil())
        expect(check).toNot(beNil())
        expect(result) == check
    }

    func testPrefixMaxLength() {
        var result: [GHGist]?
        let limit = Int(client.gists.public.makeCursor().pageSize / 2)

        waitUntil { done in
            self.client.queue.async {
                result = self.client.gists.public.prefix(limit)
                done()
            }
        }
        expect(result).toNot(beNil())
        expect(result!.count) == limit
    }

    func testPrefixMaxLengthMulitpleRequests() {
        var result: [GHGist]?
        let limit = Int(Double(client.gists.public.makeCursor().pageSize) * 2.5)
        waitUntil { done in
            self.client.queue.async {
                result = self.client.gists.public.prefix(limit)
                done()
            }
        }
        
        expect(result).toNot(beNil())
        expect(result!.count) == limit
    }

    func testPrefixWhile() {
        var results: [GHGist]?
        var count = 0
        let limit = Int(Double(client.gists.public.makeCursor().pageSize) * 2.5)
        waitUntil { done in
            self.client.queue.async {
                results = self.client.gists.public.prefix { _ -> Bool in
                    count += 1
                    return count <= limit
                }
                done()
            }
        }
        expect(results).toNot(beNil())
        expect(results!.count) == limit
    }
    
    func testListingRepositoryDirectory() {
        let client = client
        var result: OneOrMany<GHFileDescription>?
        waitUntil { done in
            DispatchQueue.global(qos: .background).async {
                result = client.repository("SwiftEthel", owner: "grype").contents["README.md"]
                done()
            }
        }
        expect(result).toNot(beNil())
        if case let .one(aFile) = result {
            expect(aFile.path).to(equal("README.md"))
        } else {
            expect(result).to(beNil())
        }
    }

//    // MARK: - Subscripting
//
//    func testSubscript() {
//        var gist: GHGist?
//        var first = [GHGist]()
//        let index = 3
//        let expect = expectation(description: "Subscript by index")
//        queue.async {
//            gist = self.client.gists.public[index]
//            if let found = try? self.client.gists.public.fetch().wait() {
//                first.append(contentsOf: found)
//            }
//            expect.fulfill()
//        }
//        wait(for: [expect], timeout: Timeouts.short.rawValue)
//        assert(gist != nil, "Expected to find a gist")
//        assert(!first.isEmpty, "Expected a listing of public gists")
//        assert(gist!.id == first[index].id)
//    }
//
//    func testRanging() {
//        var result = [GHGist]()
//        var first = [GHGist]()
//        let range = 2..<5
//        let expect = expectation(description: "Subscript by range")
//        queue.async {
//            result = self.client.gists.public[range]
//            if let found = try? self.client.gists.public.fetch().wait() {
//                first.append(contentsOf: found)
//            }
//            expect.fulfill()
//        }
//        wait(for: [expect], timeout: Timeouts.short.rawValue)
//        assert(result.count == range.count, "Unexpected number of results")
//
//        let resultIds = result.map { $0.id! }
//        let firstIds = first[range].map { $0.id! }
//        assert(firstIds == resultIds)
//    }
}
