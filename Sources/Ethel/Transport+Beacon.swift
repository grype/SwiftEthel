//
//  File.swift
//  
//
//  Created by Pavel Skaldin on 1/28/20.
//

import Foundation
import Beacon

open class TransportSignal : WrapperSignal {
    var transport: Transport {
        return value as! Transport
    }
    
    public override class var signalName: String {
        return "🚛 \(super.signalName)"
    }
    
    public init(_ aTransport: Transport) {
        super.init(aTransport)
    }
    
    public override var description: String {
        return "\(super.description) \(transport.description)"
    }
}

extension Transport : Signaling {
    public var beaconSignal: Signal {
        return TransportSignal(self)
    }
}
