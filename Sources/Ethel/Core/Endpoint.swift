//
//  Endpoint.swift
//  Ethel
//
//  Created by Pavel Skaldin on 7/20/19.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

import Beacon
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

    func execute<T>(@TransportBuilder _ block: @escaping () -> TransportBuilding) -> Promise<T> {
        if willLog(type: EndpointSignal.self, on: [Beacon.ethel]) {
            EndpointSignal(self).emit(on: [Beacon.ethel], userInfo: beaconUserInfo)
        }
        return client.execute(self, with: block)
    }

    var beaconUserInfo: [AnyHashable: Any] {
        var userInfo = [AnyHashable: Any]()
        Mirror(reflecting: self).children.forEach { aChild in
            guard let label = aChild.label else { return }
            userInfo[label] = aChild.value
        }
        return userInfo
    }
}

public func / <T: Endpoint, U: Endpoint>(left: T, right: U.Type) -> U {
    return right.init(on: left.client)
}
