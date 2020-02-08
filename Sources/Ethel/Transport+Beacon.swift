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
    
    open override var signalName: String {
        return "🚛"
    }
}

extension Transport : Signaling {
    public var beaconSignal: Signal {
        return TransportSignal(self)
    }
}
