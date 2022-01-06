//
//  Base64Builders.swift
//
//
//  Created by Pavel Skaldin on 1/5/22.
//

import Foundation

/**
 Configures transport with a `contentWriter` that encodes contents into base64-encoded `Data`.
 */
public struct EncodeBase64: TransportBuilding {
    var options: Data.Base64EncodingOptions?

    public init(_ anOptionSet: Data.Base64EncodingOptions? = nil) {
        options = anOptionSet
    }

    public func apply(to aTransport: Transport) {
        aTransport.contentWriter = { content throws -> Data? in
            var data: Data?
            if let string = content as? String {
                data = string.data(using: .utf8)
            }
            else if let contentData = content as? Data {
                data = contentData
            }
            return data?.base64EncodedData(options: options ?? [])
        }
    }
}

/**
 Configures transport with a `contentReader` that decodes base64-encoded content.
 */
public struct DecodeBase64: TransportBuilding {
    var options: Data.Base64DecodingOptions?

    public init(_ anOptionSet: Data.Base64DecodingOptions? = nil) {
        options = anOptionSet
    }

    public func apply(to aTransport: Transport) {
        aTransport.contentReader = { data throws -> Data? in
            Data(base64Encoded: data, options: options ?? [])
        }
    }
}
