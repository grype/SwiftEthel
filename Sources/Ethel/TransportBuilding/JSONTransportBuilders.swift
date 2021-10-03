//
//  File.swift
//  
//
//  Created by Pavel Skaldin on 10/1/21.
//

import Foundation

public struct DecodeJSON<T: Decodable>: TransportBuilding {
    public func apply(to aTransport: Transport) {
        aTransport.contentReader = { data throws -> T? in
            var result: T?
            do {
                result = try JSONDecoder().decode(T.self, from: data)
            }
            catch {
                print("Error decoding JSON data: \(error)")
                throw (error)
            }
            return result
        }
    }
}
