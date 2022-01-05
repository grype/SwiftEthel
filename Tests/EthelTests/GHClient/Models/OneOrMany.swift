//
//  OneOrMany.swift
//  
//
//  Created by Pavel Skaldin on 1/5/22.
//

import Foundation

enum OneOrMany<Wrapped: Codable>: Codable {
    case one(Wrapped)
    case many([Wrapped])
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
