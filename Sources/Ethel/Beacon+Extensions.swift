//
//  File.swift
//  
//
//  Created by Pavel Skaldin on 9/28/21.
//

import Foundation
import Beacon

var EthelBeacon = Beacon.shared

extension Beacon {
    open class var ethel: Beacon {
        get { EthelBeacon }
        set { EthelBeacon = newValue }
    }
}
