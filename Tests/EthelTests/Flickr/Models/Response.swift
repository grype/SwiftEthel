//
//  Response.swift
//  
//
//  Created by Pavel Skaldin on 10/25/22.
//  Copyright © 2022 Pavel Skaldin. All rights reserved.
//

import Foundation

struct Response: Decodable {
    enum Stat: String, Codable, Error {
        case ok, fail
    }

    enum CodingKeys: String, CodingKey {
        case stat, photos, sizes
    }

    var stat: Stat?
    var photos: PaginatedValue?
    var sizes: SizeValue?
}
