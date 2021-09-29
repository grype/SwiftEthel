//
//  File.swift
//
//
//  Created by Pavel Skaldin on 1/25/20.
//

import Foundation
import PromiseKit

public extension Client {
    func executeJSON<T: Decodable>(method: String, endpoint: Endpoint, decoder: JSONDecoder = JSONDecoder(), with block: TransportBlock? = nil) -> Promise<T> {
        return execute(endpoint) { transport in
            transport.request?.httpMethod = method
            transport.contentReader = { data throws -> T? in
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
            block?(transport)
        }
    }
    
    func getJSON<T: Decodable>(_ endpoint: Endpoint, decoder: JSONDecoder = JSONDecoder(), with block: TransportBlock? = nil) -> Promise<T> {
        return executeJSON(method: "GET", endpoint: endpoint, decoder: decoder, with: block)
    }
    
    func putJSON<T: Decodable>(_ endpoint: Endpoint, decoder: JSONDecoder = JSONDecoder(), with block: TransportBlock? = nil) -> Promise<T> {
        return executeJSON(method: "PUT", endpoint: endpoint, decoder: decoder, with: block)
    }
    
    func postJSON<T: Decodable>(_ endpoint: Endpoint, decoder: JSONDecoder = JSONDecoder(), with block: TransportBlock? = nil) -> Promise<T> {
        return executeJSON(method: "POST", endpoint: endpoint, decoder: decoder, with: block)
    }
    
    func patchJSON<T: Decodable>(_ endpoint: Endpoint, decoder: JSONDecoder = JSONDecoder(), with block: TransportBlock? = nil) -> Promise<T> {
        return executeJSON(method: "PATCH", endpoint: endpoint, decoder: decoder, with: block)
    }
    
    func optionsJSON<T: Decodable>(_ endpoint: Endpoint, decoder: JSONDecoder = JSONDecoder(), with block: TransportBlock? = nil) -> Promise<T> {
        return executeJSON(method: "OPTIONS", endpoint: endpoint, decoder: decoder, with: block)
    }
    
    func headJSON<T: Decodable>(_ endpoint: Endpoint, decoder: JSONDecoder = JSONDecoder(), with block: TransportBlock? = nil) -> Promise<T> {
        return executeJSON(method: "HEAD", endpoint: endpoint, decoder: decoder, with: block)
    }
    
    func deleteJSON<T: Decodable>(_ endpoint: Endpoint, decoder: JSONDecoder = JSONDecoder(), with block: TransportBlock? = nil) -> Promise<T> {
        return executeJSON(method: "DELETE", endpoint: endpoint, decoder: decoder, with: block)
    }
}
