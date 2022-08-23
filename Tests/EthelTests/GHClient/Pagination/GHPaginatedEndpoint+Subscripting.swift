//
//  GHPaginatedEndpoint+Subscripting.swift
//  Ethel
//
//  Created by Pavel Skaldin on 10/2/21.
//  Copyright © 2021 Pavel Skaldin. All rights reserved.
//

import Foundation

/**
 Subscripting support...
 */
extension GHPaginatedEndpoint {
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
