//
//  DynamicBuilders.swift
//  Ethel
//
//  Created by Pavel Skaldin on 10/4/21.
//  Copyright © 2021 Pavel Skaldin. All rights reserved.
//

import Foundation

/**
 Evaluates a block, passing it a transport object as the sole argument.
 */
public struct Eval: TransportBuilding {
    public private(set) var block: (Transport)->Void

    public init(_ aBlock: @escaping (Transport)->Void) {
        block = aBlock
    }

    public func apply(to aTransport: Transport) {
        block(aTransport)
    }
}

/**
 Evaluates a block, passing it current execution context.
 */
public struct CurrentContext: TransportBuilding {
    public private(set) var block: (Context)->Void

    public init(block aBlock: @escaping (Context)->Void) {
        block = aBlock
    }

    public func apply(to aTransport: Transport) {
        guard let context = Context.current else { return }
        block(context)
    }
}
