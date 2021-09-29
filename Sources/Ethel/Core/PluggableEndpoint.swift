//
//  PluggableEndpoint.swift
//  Ethel
//
//  Created by Pavel Skaldin on 7/20/19.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

import Foundation

open class PluggableEndpoint: Endpoint {
    override open var path: Path {
        get {
            return pluggablePath
        }
        set {
            pluggablePath = newValue
        }
    }

    open var pluggablePath: Path

    public required init(on aClient: Client) {
        pluggablePath = Path()
        super.init(on: aClient)
    }
}

public func / <T: Endpoint>(left: T, right: String) -> PluggableEndpoint {
    let endpoint = PluggableEndpoint(on: left.client)
    let oldPath = left.path
    let newPath = oldPath / right
    endpoint.path = newPath
    return endpoint
}

public func / <T: Endpoint>(left: T, right: Path) -> PluggableEndpoint {
    let endpoint = PluggableEndpoint(on: left.client)
    endpoint.path = left.path / right
    return endpoint
}

public func/ <T: Client>(left: T, right: String) -> PluggableEndpoint {
    let endpoint = PluggableEndpoint(on: left)
    endpoint.path = Path() / right
    return endpoint
}

public func/ <T: Client>(left: T, right: Path) -> PluggableEndpoint {
    let endpoint = PluggableEndpoint(on: left)
    endpoint.path = Path() / right
    return endpoint
}
