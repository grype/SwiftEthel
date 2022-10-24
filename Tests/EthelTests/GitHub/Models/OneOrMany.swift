//
//  OneOrMany.swift
//  Ethel
//
//  Created by Pavel Skaldin on 1/5/22.
//  Copyright © 2022 Pavel Skaldin. All rights reserved.
//

import Foundation

/**
 I capture a one-or-many association.
 
 I can be either `one` or `many`. I exist primarily to capture variable API responses,
 where the response may encode or or many values.
 */
enum OneOrMany<Wrapped: Codable>: Codable {
    case one(Wrapped)
    case many([Wrapped])

    // MARK: - Initialization

    public init(_ one: Wrapped) {
        self = .one(one)
    }

    public init(_ many: [Wrapped]) {
        self = .many(many)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case let .one(aValue):
            try container.encode(aValue)
        case let .many(arrayOfValues):
            try container.encode(arrayOfValues)
        }
    }

    init(from decoder: Decoder) throws {
        if let container = try? decoder.singleValueContainer() {
            self = try .one(container.decode(Wrapped.self))
        }
        else {
            var container = try decoder.unkeyedContainer()
            self = try .many(container.decode([Wrapped].self))
        }
    }
}
