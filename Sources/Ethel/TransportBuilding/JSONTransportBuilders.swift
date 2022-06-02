//
//  File.swift
//
//
//  Created by Pavel Skaldin on 10/1/21.
//

import AnyCodable
import Beacon
import Foundation

// MARK: - Defaults

private var _defaultDecoder: JSONDecoder = .init()
private var _defaultEncoder: JSONEncoder = .init()

// MARK: - DecodeJSON

/**
 Sets up transport with a content reader that materializes JSON data into instance of associated type.

 By default I use `defaultDecoder` for decoding JSON. You can either change the default value or pass your own `JSONDecoder` during
 initialization.
 */
public struct DecodeJSON<T: Decodable>: TransportBuilding {
    public typealias InitBlock = (T) -> Void

    public static var defaultDecoder: JSONDecoder {
        get { _defaultDecoder }
        set { _defaultDecoder = newValue }
    }

    public private(set) var decoder: JSONDecoder

    public private(set) var initBlock: InitBlock?

    /// Use `defaultDecoder` to override the default argument
    public init(decoder aDecoder: JSONDecoder = defaultDecoder, init aBlock: InitBlock? = nil) {
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

// MARK: - EncodeJSON

/**
 Sets up transport with a content writer that serializes objects into JSON.

 By default I use `defaultEncoder` for encoding JSON. You can either change the default value or pass your own `JSONEncoder` during
 initialization.
 */
public struct EncodeJSON: TransportBuilding {
    /// Instance of JSONEncoder to use by default
    public static var defaultEncoder: JSONEncoder {
        get { _defaultEncoder }
        set { _defaultEncoder = newValue }
    }

    public private(set) var encoder: JSONEncoder

    /// Use `defaultEncoder` to override the default argument
    public init(encoder anEncoder: JSONEncoder = defaultEncoder) {
        encoder = anEncoder
    }

    public func apply(to aTransport: Transport) {
        aTransport.contentWriter = { content throws -> Data? in
            do {
                return try encoder.encode(AnyEncodable(content))
            }
            catch {
                emit(error: error)
                throw error
            }
        }
    }
}
