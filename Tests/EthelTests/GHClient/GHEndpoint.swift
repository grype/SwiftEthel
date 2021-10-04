//
//  File.swift
//
//
//  Created by Pavel Skaldin on 1/25/20.
//

@testable import Ethel
import Foundation
import PromiseKit

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
}
