//
//  Context.swift
//  Ethel
//
//  Created by Pavel Skaldin on 10/1/21.
//  Copyright © 2021 Pavel Skaldin. All rights reserved.
//

import Foundation

public class Context {
    @TaskLocal
    static var current: Context?

    static func with(_ aContext: Context?, do aBlock: () async throws ->Void) async throws {
        try await $current.withValue(aContext, operation: aBlock)
    }

    public private(set) var endpoint: Endpoint

    public private(set) var transport: Transport

    public var userInfo: [AnyHashable: Any]?

    public init(endpoint anEndpoint: Endpoint, transport aTransport: Transport, userInfo aUserInfo: [AnyHashable: Any]? = nil) {
        endpoint = anEndpoint
        transport = aTransport
        userInfo = aUserInfo
    }
}
