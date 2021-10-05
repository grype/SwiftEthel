//
//  File.swift
//
//
//  Created by Pavel Skaldin on 10/4/21.
//

import Foundation

/**
 Configured transport with block-based content reader
 */
public struct Read<T>: TransportBuilding {
    private(set) var block: ((Data) throws -> T?)?
    init(_ aBlock: @escaping (Data) throws -> T?) {
        block = aBlock
    }

    public func apply(to aTransport: Transport) {
        aTransport.contentReader = block
    }
}


/**
 Configured transport with block-based content writer
 */
public struct Write: TransportBuilding {
    private(set) var block: (Any) throws -> Data?
    init(_ aBlock: @escaping (Any) throws -> Data?) {
        block = aBlock
    }

    public func apply(to aTransport: Transport) {
        aTransport.contentWriter = block
    }
}
