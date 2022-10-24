//
//  PaginatedEndpoint.swift
//  Ethel
//
//  Created by Pavel Skaldin on 2/10/20.
//  Copyright © 2020 Pavel Skaldin. All rights reserved.
//

@testable import Ethel
import Foundation

/**
 I specialize the base `GHEndpoint` class with support for pagination.
 */
class PaginatedEndpoint<T: Decodable>: GitHubEndpoint {
    typealias Element = T
    
    var page: Int = 1
    
    var pageSize: Int = 5
    
    @TransportBuilder
    func prepare() -> TransportBuilding {
        AddQuery(name: "page", value: "\(page)")
        AddQuery(name: "per_page", value: "\(pageSize)")
    }
    
    var pageContents: [Element] {
        get async throws {
            try await execute {
                Get()
                DecodeJSON<[Element]>()
            }
        }
    }
}
