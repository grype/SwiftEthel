//
//  Beacon+Extensions.swift
//  Ethel
//
//  Created by Pavel Skaldin on 9/28/21.
//  Copyright © 2021 Pavel Skaldin. All rights reserved.
//

import Beacon
import Foundation

var EthelBeacon = Beacon.shared

extension Beacon {
    public class var ethel: Beacon {
        get { EthelBeacon }
        set { EthelBeacon = newValue }
    }
}
