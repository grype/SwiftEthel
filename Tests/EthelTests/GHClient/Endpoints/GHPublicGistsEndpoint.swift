//
//  File.swift
//  
//
//  Created by Pavel Skaldin on 1/25/20.
//

import Foundation
import PromiseKit
@testable import Ethel

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
    
    subscript(index: Int) -> GHGist? {
        var iterator = makeIterator()
        iterator.pageSize = 1
        iterator.page = index + 1
        return iterator.next()
    }
    
    subscript(range: Range<Int>) -> [GHGist] {
        var iterator = makeIterator()
        iterator.page = Int(floor(Double(range.lowerBound / iterator.pageSize))) + 1
        var result = [GHGist]()
        while iterator.hasMore, result.count < range.count {
            guard let found = try? next(with: iterator).wait() else { break }

            let startOffset = (iterator.page - 1) * iterator.pageSize
            let endOffset = startOffset + iterator.pageSize - 1

            let low = Swift.max(range.lowerBound - startOffset, 0)
            let high = iterator.pageSize - Swift.max(endOffset - (range.lowerBound + range.count - 1), 0)

            result.append(contentsOf: found[low..<high])
            iterator.page += 1
        }
        return result
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
