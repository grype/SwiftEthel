//
//  File.swift
//
//
//  Created by Pavel Skaldin on 10/1/21.
//

import Foundation

public protocol TransportBuilding {
    func apply(to aTransport: Transport)
}

@resultBuilder
public enum TransportBuilder {
    public static func buildEither(first component: TransportBuilding) -> TransportBuilding {
        return component
    }

    public static func buildEither(second component: TransportBuilding) -> TransportBuilding {
        return component
    }

    public static func buildOptional(_ component: TransportBuilding?) -> TransportBuilding {
        return component ?? Noop
    }

    public static func buildBlock(_ components: TransportBuilding...) -> TransportBuilding {
        return Group(components)
    }
    
    public static func buildArray(_ components: [TransportBuilding]) -> TransportBuilding {
        return Group(components)
    }
}

// MARK: -

public let Noop: Nahah = .init()

public struct Nahah: TransportBuilding {
    public func apply(to aTransport: Transport) {
        // nothing to do
    }
}

public struct Group: TransportBuilding {
    var elements: [TransportBuilding]

    init(_ newElements: [TransportBuilding]) {
        elements = newElements
    }

    public func apply(to aTransport: Transport) {
        elements.forEach { $0.apply(to: aTransport) }
    }
}
