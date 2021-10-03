//
//  File.swift
//
//
//  Created by Pavel Skaldin on 10/1/21.
//

import Foundation

public var CurrentContext = DispatchSpecificKey<Context>()

public struct Context {
    var endpoint: Endpoint
    var transport: Transport
}
