//
//  SizeValue.swift
//  
//
//  Created by Pavel Skaldin on 10/25/22.
//  Copyright © 2022 Pavel Skaldin. All rights reserved.
//

import Foundation

struct SizeValue: Decodable {
    var sizes: [Size]
    enum CodingKeys: String, CodingKey {
        case sizes = "size"
    }
}
