//
//  File.swift
//
//
//  Created by Pavel Skaldin on 10/1/21.
//

import Foundation

public var CurrentContextKey = DispatchSpecificKey<Context>()

public class Context {
    public private(set) var endpoint: Endpoint

    public private(set) var transport: Transport

    public var userInfo: [AnyHashable: Any]?

    public init(endpoint anEndpoint: Endpoint, transport aTransport: Transport, userInfo aUserInfo: [AnyHashable : Any]? = nil) {
        endpoint = anEndpoint
        transport = aTransport
        userInfo = aUserInfo
    }
}
