//
//  File.swift
//
//
//  Created by Pavel Skaldin on 2/10/20.
//

import Ethel
import Foundation
import PromiseKit

class GHPaginatedEndpoint<T: Decodable>: GHEndpoint {
    typealias Element = T
    
    var page: Int = 1
    
    var pageSize: Int = 5
    
    override func configure(on aTransport: Transport) {
        super.configure(on: aTransport)
        aTransport.add(queryItem: URLQueryItem(name: "page", value: "\(page)"))
        aTransport.add(queryItem: URLQueryItem(name: "per_page", value: "\(pageSize)"))
    }
    
    subscript(index: Int) -> Element? {
        let cursor = makeCursor()
        cursor.page = index + 1
        cursor.pageSize = 1
        guard let results = try? next(with: cursor).wait(), !results.isEmpty else {
            return nil
        }
        return results[0]
    }
    
    subscript(range: Range<Int>) -> [Element] {
        let cursor = makeCursor()
        cursor.page = Int(floor(Double(range.lowerBound / cursor.pageSize))) + 1
        var result = [Element]()
        while cursor.hasMore, result.count < range.count {
            let currentPage = cursor.page
            guard let found = try? next(with: cursor).wait() else { break }

            let startOffset = (currentPage - 1) * cursor.pageSize
            let endOffset = startOffset + cursor.pageSize - 1

            let low = Swift.max(range.lowerBound - startOffset, 0)
            let high = cursor.pageSize - Swift.max(endOffset - (range.lowerBound + range.count - 1), 0)

            result.append(contentsOf: found[low ..< high])
        }
        return result
    }
}

extension GHPaginatedEndpoint: CursoredEndpoint {
    typealias EndpointCursor = GHPageCursor
    
    func makeCursor() -> GHPageCursor {
        let cursor = GHPageCursor()
        cursor.page = page
        cursor.pageSize = pageSize
        return cursor
    }
    
    func next(with aCursor: GHPageCursor) -> Promise<[T]> {
        page = aCursor.page
        pageSize = aCursor.pageSize
        return getJSON().get { gists in
            aCursor.page += 1
            aCursor.hasMore = gists.count >= self.pageSize
        }
    }
}
