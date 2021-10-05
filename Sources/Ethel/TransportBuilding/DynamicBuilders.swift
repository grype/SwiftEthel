//
//  File.swift
//  
//
//  Created by Pavel Skaldin on 10/4/21.
//

import Foundation

/**
 Evaluates a block, passing it a transport object as the sole argument.
 */
struct Eval : TransportBuilding {
    var block: (Transport)->Void
    init(_ aBlock: @escaping (Transport)->Void) {
        block = aBlock
    }
    func apply(to aTransport: Transport) {
        block(aTransport)
    }
}
