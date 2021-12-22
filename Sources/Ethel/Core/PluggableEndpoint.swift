//
//  PluggableEndpoint.swift
//  Ethel
//
//  Created by Pavel Skaldin on 7/20/19.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

import Foundation
import PromiseKit

open class PluggableEndpoint: Endpoint {
    public var client: Client
    
    public var path: Path?
    
    public required init(on aClient: Client) {
        client = aClient
    }
    
    open func get<T>(@TransportBuilder _ block: @escaping ()->TransportBuilding) -> Promise<T> {
        execute {
            Get()
            block()
        }
    }
    
    open func delete<T>(@TransportBuilder _ block: @escaping ()->TransportBuilding) -> Promise<T> {
        execute {
            Delete()
            block()
        }
    }
    
    open func post<T>(@TransportBuilder _ block: @escaping ()->TransportBuilding) -> Promise<T> {
        execute {
            Post()
            block()
        }
    }
    
    open func patch<T>(@TransportBuilder _ block: @escaping ()->TransportBuilding) -> Promise<T> {
        execute {
            Patch()
            block()
        }
    }
    
    open func put<T>(@TransportBuilder _ block: @escaping ()->TransportBuilding) -> Promise<T> {
        execute {
            Put()
            block()
        }
    }
    
    open func head<T>(@TransportBuilder _ block: @escaping ()->TransportBuilding) -> Promise<T> {
        execute {
            Head()
            block()
        }
    }
    
    open func options<T>(@TransportBuilder _ block: @escaping ()->TransportBuilding) -> Promise<T> {
        execute {
            Options()
            block()
        }
    }
    
}

public func / <T: Endpoint>(left: T, right: String) -> PluggableEndpoint {
    let endpoint = PluggableEndpoint(on: left.client)
    endpoint.path = left.path?.path(resolving: right)
    left.configureDerivedEndpoint(endpoint)
    return endpoint
}

public func / <T: Endpoint>(left: T, right: Path) -> PluggableEndpoint {
    let endpoint = PluggableEndpoint(on: left.client)
    endpoint.path = left.path?.path(resolving: right)
    left.configureDerivedEndpoint(endpoint)
    return endpoint
}

public func/ <T: Client>(left: T, right: String) -> PluggableEndpoint {
    let endpoint = PluggableEndpoint(on: left)
    endpoint.path = Path(right)
    return endpoint
}

public func/ <T: Client>(left: T, right: Path) -> PluggableEndpoint {
    let endpoint = PluggableEndpoint(on: left)
    endpoint.path = right
    return endpoint
}
