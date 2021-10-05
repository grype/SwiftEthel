//
//  File.swift
//  
//
//  Created by Pavel Skaldin on 10/1/21.
//

import Foundation
import Beacon

/**
 Sets up transport with a content reader that attempts to materialize JSON data into instance of associated type.
 */
public struct DecodeJSON<T: Decodable>: TransportBuilding {
    public func apply(to aTransport: Transport) {
        aTransport.contentReader = { data throws -> T? in
            var result: T?
            do {
                result = try JSONDecoder().decode(T.self, from: data)
            }
            catch {
                emit(error: error)
            }
            return result
        }
    }
}
