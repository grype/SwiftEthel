//
//  TransportSignal.swift
//  Ethel
//
//  Created by Pavel Skaldin on 1/28/20.
//  Copyright © 2020 Pavel Skaldin. All rights reserved.
//

import Beacon
import Foundation

open class TransportSignal: WrapperSignal {
    var transport: Transport { value as! Transport }

    override open var signalName: String { "🚛" }

    public init(_ aTransport: Transport) {
        super.init(aTransport)
    }

    override public var description: String {
        return "\(super.description) \(transport.description)"
    }
}

extension Transport: Signaling {
    public var beaconSignal: Signal {
        return TransportSignal(self)
    }
}
