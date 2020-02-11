//
//  Endpoint.swift
//  Ethel
//
//  Created by Pavel Skaldin on 7/20/19.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

import Foundation
import PromiseKit

// MARK:- Endpoint

open class Endpoint {
    open var client: Client
    
    open var path: Path {
        return Path()
    }
    
    required public init(on aClient: Client) {
        client = aClient
    }
    
    open func configure(on aTransport: Transport) {
        aTransport.request?.url?.resolve(path)
    }
    
    open func execute<T>(_ block: TransportBlock? = nil) -> Promise<T> {
        return client.execute(self, with: block)
    }
    
    open func get<T>(_ block: TransportBlock? = nil) -> Promise<T> {
        return client.get(self, with: block)
    }
    
    open func delete<T>(_ block: TransportBlock? = nil) -> Promise<T> {
        return client.delete(self, with: block)
    }
    
    open func post<T>(_ block: TransportBlock? = nil) -> Promise<T> {
        return client.post(self, with: block)
    }
    
    open func patch<T>(_ block: TransportBlock? = nil) -> Promise<T> {
        return client.patch(self, with: block)
    }
    
    open func put<T>(_ block: TransportBlock? = nil) -> Promise<T> {
        return client.put(self, with: block)
    }
    
    open func head<T>(_ block: TransportBlock? = nil) -> Promise<T> {
        return client.head(self, with: block)
    }
    
    open func options<T>(_ block: TransportBlock? = nil) -> Promise<T> {
        return client.options(self, with: block)
    }
}

public func /<T: Endpoint, U: Endpoint>(left: T, right: U.Type) -> U {
    return right.init(on: left.client)
}
