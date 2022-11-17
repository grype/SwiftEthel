//
//  PaginatedValue.swift
//  
//
//  Created by Pavel Skaldin on 10/25/22.
//  Copyright © 2022 Pavel Skaldin. All rights reserved.
//

import Foundation

struct PaginatedValue: Decodable {
    var page: Int
    var pageSize: Int
    var total: Int
    var pages: Int

    var photos: [Photo]?

    enum CodingKeys: String, CodingKey {
        case page, pageSize = "perpage", total, pages
        case photos = "photo"
    }
}
