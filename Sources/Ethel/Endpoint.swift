//
//  Endpoint.swift
//  Ethel
//
//  Created by Pavel Skaldin on 7/20/19.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

import Foundation

public protocol Endpoint {
    var endpointPath: Path { get }
    var client: Client { get set }
    func configure(on aSession: URLSession)
    init(_ aClient: Client)
}

extension Endpoint {
    init(_ aClient: Client) {
        client = aClient
    }
}
