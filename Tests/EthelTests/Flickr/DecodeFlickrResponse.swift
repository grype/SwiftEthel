//
//  DecodeFlickrResponse.swift
//
//
//  Created by Pavel Skaldin on 10/25/22.
//  Copyright © 2022 Pavel Skaldin. All rights reserved.
//

import Beacon
import Ethel
import Foundation

struct DecodeFlickrResponse: TransportBuilding {
    typealias InitBlock = (Response) -> Void

    private(set) var decoder: JSONDecoder

    private(set) var initBlock: InitBlock?

    /// Use `defaultDecoder` to override the default argument
    init(decoder aDecoder: JSONDecoder = .init(), init aBlock: InitBlock? = nil) {
        decoder = aDecoder
        initBlock = aBlock
    }

    func apply(to aTransport: Transport) {
        aTransport.contentReader = { data throws -> Response? in
            let prefix = "jsonFlickrApi(".data(using: .utf8)!
            var json = data
            if data.prefix(prefix.count) == prefix {
                json = data.subdata(in: prefix.count ..< (data.count - 1))
            }
            var result: Response?
            do {
                result = try decoder.decode(Response.self, from: json)
                initBlock?(result!)
            }
            catch {
                emit(error: error)
                throw error
            }
            return result
        }
    }
}
