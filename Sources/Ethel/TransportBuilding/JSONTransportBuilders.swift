//
//  File.swift
//
//
//  Created by Pavel Skaldin on 10/1/21.
//

import Beacon
import Foundation
import AnyCodable

/**
 Sets up transport with a content reader that materializes JSON data into instance of associated type.
 */
public struct DecodeJSON<T: Decodable>: TransportBuilding {
    public typealias InitBlock = (T) -> Void

    public private(set) var decoder: JSONDecoder
    
    public private(set) var initBlock: InitBlock?

    public init(decoder aDecoder: JSONDecoder = JSONDecoder(), init aBlock: InitBlock? = nil) {
        decoder = aDecoder
        initBlock = aBlock
    }

    public func apply(to aTransport: Transport) {
        aTransport.contentReader = { data throws -> T? in
            var result: T?
            do {
                result = try decoder.decode(T.self, from: data)
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

/**
 Sets up transport with a content writer that serializes objects into JSON.
 */
public struct EncodeJSON: TransportBuilding {
    public private(set) var encoder: JSONEncoder
    
    public init(encoder anEncoder: JSONEncoder = JSONEncoder()) {
        encoder = anEncoder
    }
    
    public func apply(to aTransport: Transport) {
        aTransport.contentWriter = { (content) throws -> Data? in
            var data: Data?
            guard let encodableContent = content as? Encodable else { return data }
            let value = AnyEncodable(encodableContent)
            do {
                data = try JSONEncoder().encode(value)
            }
            catch {
                emit(error: error)
                throw error
            }
            return data
        }
    }
}
