//
//  File.swift
//
//
//  Created by Pavel Skaldin on 10/25/22.
//

import Beacon
import Foundation
import XCTest
import Nimble
import Cuckoo
@testable import Ethel

class FlickExamples: XCTestCase {
    var flickr: Flickr!
    var downloadPath: String!
    var apiKey: String = ""

    override func setUpWithError() throws {
        try super.setUpWithError()
        flickr = Flickr(apiKey: apiKey)
        downloadPath = "/tmp/flickr-downloads"
        try ensureDestination(downloadPath)
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        flickr = nil
        try FileManager.default.removeItem(atPath: downloadPath)
    }
    
    // MARK: - Downloading
    
    var downloadedFiles: [String] {
        (try? FileManager.default.contentsOfDirectory(atPath: downloadPath)) ?? []
    }

    func download(random: Int, to aPath: String) async throws {
        try await flickr.interestingness.compactMap { [self] aPhoto in
            try await flickr.photo(with: aPhoto.id).sizes.first(where: accept(size:))?.source
        }
        .prefix(random * 2)
        .reduce(into: []) { $0.append($1) }
        .shuffled()
        .prefix(random)
        .forEach { url in
            try download(url: url, to: aPath)
        }
    }

    func download(max: Int, to aPath: String) async throws {
        try await flickr.interestingness.compactMap { [self] aPhoto in
            try await flickr.photo(with: aPhoto.id).sizes.first(where: accept(size:))?.source
        }
        .prefix(max)
        .reduce(into: []) { $0.append($1) }
        .forEach { aUrl in
            try download(url: aUrl, to: aPath)
        }
    }

    func download(query: String, max: Int, to aPath: String) async throws {
        try await flickr.photos.search(query: .init(text: query)).compactMap { [self] aPhoto in
            try await flickr.photo(with: aPhoto.id).sizes.first(where: accept(size:))?.source
        }
        .prefix(max)
        .reduce(into: []) { $0.append($1) }
        .forEach { aUrl in
            try download(url: aUrl, to: aPath)
        }
    }

    // MARK: - Utilities

    func accept(size: Size) -> Bool {
        guard let screen = NSScreen.main else { return true }
        let screenArea = screen.frame.width * screen.frame.height
        return CGFloat(size.area) >= (screenArea * 0.8)
    }

    func ensureDestination(_ aPath: String) throws {
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: aPath) {
            try fileManager.createDirectory(at: URL(fileURLWithPath: aPath), withIntermediateDirectories: true)
        }
    }

    func download(url: URL, to aPath: String) throws {
        let data = try Data(contentsOf: url)
        let destination = URL(fileURLWithPath: "\(aPath)/\(url.lastPathComponent)")
        emit("\(url) -> \(destination)")
        try data.write(to: destination)
    }

    // MARK: - Tests

    func testDownloadRandom() async throws {
        let max = 5
        try await download(random: 5, to: downloadPath)
        expect(self.downloadedFiles.count) == max
    }
    
    func testDownloadMaxCount() async throws {
        let max = 5
        try await download(max: max, to: downloadPath)
        expect(self.downloadedFiles.count) == max
    }
    
    func testSearchAndDownload() async throws {
        let max = 5
        try await download(query: "gomez addams", max: max, to: downloadPath)
        expect(self.downloadedFiles.count) == max
    }
    
}
