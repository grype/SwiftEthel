//
//  File.swift
//
//
//  Created by Pavel Skaldin on 10/2/21.
//

@testable import Ethel
import Foundation
import PromiseKit

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
        return execute {
            Get()
        }.get { gists in
            aCursor.page += 1
            aCursor.hasMore = gists.count >= self.pageSize
        }
    }
}
