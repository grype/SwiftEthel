//
//  GHPaginatedEndpoint.swift
//  Ethel
//
//  Created by Pavel Skaldin on 2/10/20.
//  Copyright © 2020 Pavel Skaldin. All rights reserved.
//

@testable import Ethel
import Foundation
import PromiseKit

/**
 I specialize the base `GHEndpoint` class with support for pagination.
 */
class GHPaginatedEndpoint<T: Decodable>: GHEndpoint {
    typealias Element = T
    
    var page: Int = 1
    
    var pageSize: Int = 5
    
    @TransportBuilder func prepare() -> TransportBuilding {
        AddQuery(name: "page", value: "\(page)")
        AddQuery(name: "per_page", value: "\(pageSize)")
    }
    
    func fetch() -> Promise<[Element]> {
        execute {
            Get()
            DecodeJSON<[Element]>()
        }
    }
}
