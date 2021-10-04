//
//  File.swift
//  
//
//  Created by Pavel Skaldin on 10/1/21.
//

import Foundation
import Beacon

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
