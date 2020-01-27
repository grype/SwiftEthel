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

public protocol Endpoint {
    init(on aClient: Client)
    static var path: Path { get }
    var path: Path { get }
    var client: Client { get set }
    func configure(on aTransport: Transport)
    func execute<T>(_ block: TransportBlock?) -> Promise<T>
}

// MARK:- Extensions

extension Endpoint {
    var path: Path {
        return type(of: self).path
    }
    
    public func configure(on aTransport: Transport) {
        aTransport.request?.url?.resolve(path)
    }
    
    public func execute<T>(_ block: TransportBlock? = nil) -> Promise<T> {
        return client.execute(self, with: block)
    }
    
    public func get<T>(_ block: TransportBlock? = nil) -> Promise<T> {
        return client.get(self, with: block)
    }
    
    public func delete<T>(_ block: TransportBlock? = nil) -> Promise<T> {
        return client.delete(self, with: block)
    }
    
    public func post<T>(_ block: TransportBlock? = nil) -> Promise<T> {
        return client.post(self, with: block)
    }
    
    public func patch<T>(_ block: TransportBlock? = nil) -> Promise<T> {
        return client.patch(self, with: block)
    }
    
    public func put<T>(_ block: TransportBlock? = nil) -> Promise<T> {
        return client.put(self, with: block)
    }
    
    public func head<T>(_ block: TransportBlock? = nil) -> Promise<T> {
        return client.head(self, with: block)
    }
    
    public func options<T>(_ block: TransportBlock? = nil) -> Promise<T> {
        return client.options(self, with: block)
    }
}

public func /<T: Endpoint, U: Endpoint>(left: T, right: U.Type) -> U {
    return right.init(on: left.client)
}
