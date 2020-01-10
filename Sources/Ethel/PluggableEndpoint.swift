//
//  PluggableEndpoint.swift
//  Ethel
//
//  Created by Pavel Skaldin on 7/20/19.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

import Foundation

class PluggableEndpoint : Endpoint {
    static var path: Path = Path()
    
    var client: Client
    
    var path: Path?
    
    required init(on aClient: Client) {
        client = aClient
    }
    
}
