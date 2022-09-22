//
//  GHEndpoint.swift
//  Ethel
//
//  Created by Pavel Skaldin on 1/25/20.
//  Copyright © 2020 Pavel Skaldin. All rights reserved.
//

@testable import Ethel
import Foundation

/**
 I am a base Endpoint on which all other endpoints build on.

 I store instance of the client on which I execute requests, default to root path, and provide common date formatter.
 */
class GHEndpoint: Endpoint {
    var client: Client
    var path: Path? { "/" }
    var dateFormatter = ISO8601DateFormatter()

    required init(on aClient: Client) {
        client = aClient
    }
    
    func configureDerivedEndpoint(_ anEndpoint: Endpoint) {
        // Intentionally blank
        // Since there's a default implementation defined in the protocol extension
        // any subclass of `GHEndpoint` that wishes to implement this method, relies on
        // this class to implement is in the first place, otherwise, Swift will call
        // the default implementation. Swift...
    }
}
