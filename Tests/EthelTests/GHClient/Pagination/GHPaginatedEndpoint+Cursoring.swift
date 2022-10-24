//
//  GHPaginatedEndpoint+Cursoring.swift
//  Ethel
//
//  Created by Pavel Skaldin on 10/2/21.
//  Copyright © 2021 Pavel Skaldin. All rights reserved.
//

@testable import Ethel
import Foundation

extension GHPaginatedEndpoint: CursoredEndpoint {
    typealias EndpointCursor = GHPageCursor

    func makeCursor() -> GHPageCursor {
        let cursor = GHPageCursor()
        cursor.page = page
        cursor.pageSize = pageSize
        return cursor
    }

    func next(with aCursor: GHPageCursor) async throws -> [Element] {
        page = aCursor.page
        pageSize = aCursor.pageSize
        let gists = try await execute {
            Get()
            DecodeJSON<[Element]>()
        } as [Element]
        aCursor.page += 1
        aCursor.hasMore = gists.count >= pageSize
        return gists
    }
}
