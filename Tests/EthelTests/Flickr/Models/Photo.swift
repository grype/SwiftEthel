//
//  Photo.swift
//  
//
//  Created by Pavel Skaldin on 10/25/22.
//  Copyright © 2022 Pavel Skaldin. All rights reserved.
//

import Foundation

struct Photo: Codable {
    var id: String
    var owner: String
    enum CodingKeys: String, CodingKey {
        case id, owner
    }
}

