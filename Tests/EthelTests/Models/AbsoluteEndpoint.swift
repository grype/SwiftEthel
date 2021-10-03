//
//  File.swift
//
//
//  Created by Pavel Skaldin on 2/11/20.
//

@testable import Ethel
import Foundation

class AbsoluteEndpoint: Endpoint {
    var client: Client
    
    var path: Path? { "/absolute" }
    
    required init(on aClient: Client) {
        client = aClient
    }
}
