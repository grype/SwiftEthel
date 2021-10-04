//
//  Endpoint.swift
//  Ethel
//
//  Created by Pavel Skaldin on 7/20/19.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

import Foundation
import PromiseKit

// MARK: - Endpoint

public protocol Endpoint {
    var client: Client { get }
    var path: Path? { get }
    init(on aClient: Client)
    @TransportBuilder func prepare() -> TransportBuilding
}

public extension Endpoint {
    @TransportBuilder func prepare() -> TransportBuilding { Noop }

    func execute<T>(@TransportBuilder _ block: () -> TransportBuilding) -> Promise<T> {
        return client.execute(self, with: block)
    }
}

public func / <T: Endpoint, U: Endpoint>(left: T, right: U.Type) -> U {
    return right.init(on: left.client)
}
