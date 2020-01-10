//
//  Endpoint.swift
//  Ethel
//
//  Created by Pavel Skaldin on 7/20/19.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

import Foundation
import PromiseKit

public protocol Endpoint {
    init(on aClient: Client)
    static var path: Path { get }
    var client: Client { get set }
    func configure(on aRequest: Request)
    func execute<T>(_ block: Client.ExecutionBlock?) -> Promise<T>
}

extension Endpoint {
    var path: Path {
        return type(of: self).path
    }
    
    func configure(on aRequest: Request) {
        aRequest.urlRequest.url?.resolve(path)
    }
    
    func execute<T>(_ block: Client.ExecutionBlock? = nil) -> Promise<T> {
        return client.execute(self, with: block).compactMap { $0.data as? T
        }
    }
}

public func /<T: Endpoint, U: Endpoint>(left: T, right: U.Type) -> U {
    return right.init(on: left.client)
}
