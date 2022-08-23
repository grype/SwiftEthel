//
//  EndpointSignal.swift
//  Ethel
//
//  Created by Pavel Skaldin on 10/5/21.
//  Copyright © 2021 Pavel Skaldin. All rights reserved.
//

import Beacon
import Foundation
import AnyCodable

public class EndpointSignal: WrapperSignal {
    var endpoint: Endpoint {
        return value as! Endpoint
    }

    public override var signalName: String {
        return "💬 \(String(describing: type(of: endpoint)))"
    }

    public override var description: String {
        var result = super.description
        guard let codableDict = userInfo?.compactMapValues({ each -> AnyEncodable? in
            guard let codable = each as? Encodable else { return nil }
            return AnyEncodable(codable)
        }) else { return result }
        codableDict.forEach { each in
            result.append(contentsOf: "\n\t\(each.key): \(String(describing: each.value.value))")
        }
        return result
    }

    init(_ anEndpoint: Endpoint) {
        super.init(anEndpoint)
        userInfo = endpoint.beaconUserInfo
    }
}
