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

    func next(with aCursor: GHPageCursor) -> Promise<[Element]> {
        page = aCursor.page
        pageSize = aCursor.pageSize
        return execute {
            Get()
            DecodeJSON<[Element]>()
        }.get { gists in
            aCursor.page += 1
            aCursor.hasMore = gists.count >= self.pageSize
        }
    }
}
