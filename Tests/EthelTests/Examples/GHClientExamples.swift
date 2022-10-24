//
//  GHClientExamples.swift
//  Ethel
//
//  Created by Pavel Skaldin on 1/8/20.
//  Copyright © 2020 Pavel Skaldin. All rights reserved.
//

import Beacon
@testable import Ethel
import Nimble
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

    func testListPublicGists() async throws {
        let pastDate = Date().addingTimeInterval(-86400)
        let result = try await client.gists.public.since(pastDate).pageContents
        expect(result.isEmpty).to(beFalse())
    }

    // MARK: - Per-method URL modifications

    func testGistById() async throws {
        let gists = try await client.gists.pageContents
        let gist = try await client.gist(id: gists[0].id!)
        expect(gist).toNot(beNil())
    }

    // MARK: - Enumeration

    func testForEach() async throws {
        let limit = 5
        let all: [GHGist] = try await client.gists.public.prefix(limit).reduce(into: []) { partialResult, gist in
            partialResult.append(gist)
        }
        expect(all.count) == limit
    }

    func testFilter() async throws {
        let limit = 5
        let all: [GHGist] = try await client.gists.public.filter { _ -> Bool in true }.reduce(into: []) { partialResult, gist in
            partialResult.append(gist)
        }
        expect(all.count) == limit
    }

    func testFirst() async throws {
        let found: GHGist? = try await client.gists.public.first { gist -> Bool in
            gist.files?.contains(where: { each -> Bool in
                each.value.language != nil
            }) ?? false
        }

        expect(found).toNot(beNil())
        if let files = found?.files {
            expect(files).to(containElementSatisfying { each in
                each.value.language != nil
            })
        } else {
            expect(found?.files ?? nil).toNot(beNil())
        }
    }

    func testSort() async throws {
        let result: [GHGist] = try await client.gists.public
            .reduce(into: []) { $0.append($1) }
            .sorted { a, b -> Bool in
                a.created! > b.created!
            }
        expect(result.isEmpty).to(beFalse())
        let resultTimes = result.map { $0.created! }
        expect(resultTimes) == resultTimes.sorted(by: { a, b -> Bool in
            a > b
        })
    }

    func testCompactMap() async throws {
        var result: [String] = .init()
        for try await aString in client.gists.public.compactMap({ $0.gistDescription }).prefix(10) {
            result.append(aString)
        }
        expect(result.isEmpty).to(beFalse())
        let descriptions = result.compactMap { $0 }
        expect(descriptions.count) == result.count
    }

    func testReduce() async throws {
        let limit = 3
        let result: [GHGist] = try await client.gists.public.prefix(limit).reduce(into: []) { $0.append($1) }
        expect(result).toNot(beNil())
        expect(result.count) == limit
    }

    func testPrefixPartialMaxLength() async throws {
        let limit = Int(client.gists.public.makeCursor().pageSize / 2)
        let result: [GHGist] = try await client.gists.public.prefix(limit).reduce(into: []) { $0.append($1) }
        expect(result).toNot(beNil())
        expect(result.count) == limit
    }

    func testPrefixMaxLengthMulitpleRequests() async throws {
        let limit = Int(Double(client.gists.public.makeCursor().pageSize) * 2.5)
        let result: [GHGist] = try await client.gists.public.prefix(limit).reduce(into: []) { $0.append($1) }
        expect(result).toNot(beNil())
        expect(result.count) == limit
    }

    func testListingRepositoryDirectory() async throws {
        let client = client
        let result: OneOrMany<GHFileDescription> = try await client.repository("SwiftEthel", owner: "grype").contents["README.md"]
        expect(result).toNot(beNil())
        if case let .one(aFile) = result {
            expect(aFile.path).to(equal("README.md"))
        } else {
            expect(result).to(beNil())
        }
    }

    func testDownloadingFile() async throws {
        let location = URL(fileURLWithPath: NSHomeDirectory().appending("/Downloads/SwiftEthel-archive.zip"))
        _ = try await client.repository("SwiftEthel", owner: "grype").downloadArchive(to: location)
        let fileManager = FileManager.default
        expect(fileManager.fileExists(atPath: location.path)).to(beTrue())
        try? fileManager.removeItem(at: location)
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
