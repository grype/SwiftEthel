//
//  PagingEndpoint.swift
//  
//
//  Created by Pavel Skaldin on 10/25/22.
//  Copyright © 2022 Pavel Skaldin. All rights reserved.
//

import Foundation
import Ethel

protocol PagingEndpoint: AnyObject, FlickrEndpoint, CursoredEndpoint {
    var page: Int { get set }
    var pageSize: Int { get set }
}

extension PagingEndpoint where Element: Decodable {
    @TransportBuilder
    func preparePaging() -> TransportBuilding {
        AddQuery(name: "page", value: "\(page)")
        AddQuery(name: "per_page", value: "\(pageSize)")
    }

    var pageContents: Response {
        get async throws {
            try await execute {
                Get()
            }
        }
    }
}

extension PagingEndpoint where Element == Photo {
    func next(with aCursor: PagingCursor) async throws -> [Element] {
        aCursor.configure(on: self)
        let response: Response = try await pageContents
        guard response.stat != .fail else {
            throw response.stat!
        }
        aCursor.advance()
        aCursor.hasMore = response.photos!.page < response.photos!.pages
        return response.photos?.photos ?? []
    }
}

extension CursoredEndpoint where Self: PagingEndpoint, Element: Decodable {
    func makeCursor() -> PagingCursor { .init() }
}
