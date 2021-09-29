//
//  File.swift
//
//
//  Created by Pavel Skaldin on 1/25/20.
//

import Foundation
import PromiseKit

public extension Endpoint {
    var jsonDecoder: JSONDecoder {
        return JSONDecoder()
    }
    
    func getJSON<T: Decodable>(decoder: JSONDecoder? = nil, block: TransportBlock? = nil) -> Promise<T> {
        return client.getJSON(self, decoder: decoder ?? jsonDecoder, with: block)
    }
    
    func deleteJSON<T: Decodable>(decoder: JSONDecoder? = nil, block: TransportBlock? = nil) -> Promise<T> {
        return client.deleteJSON(self, decoder: decoder ?? jsonDecoder, with: block)
    }
    
    func putJSON<T: Decodable>(decoder: JSONDecoder? = nil, block: TransportBlock? = nil) -> Promise<T> {
        return client.putJSON(self, decoder: decoder ?? jsonDecoder, with: block)
    }
    
    func postJSON<T: Decodable>(decoder: JSONDecoder? = nil, block: TransportBlock? = nil) -> Promise<T> {
        return client.postJSON(self, decoder: decoder ?? jsonDecoder, with: block)
    }
    
    func patchJSON<T: Decodable>(decoder: JSONDecoder? = nil, block: TransportBlock? = nil) -> Promise<T> {
        return client.patchJSON(self, decoder: decoder ?? jsonDecoder, with: block)
    }
    
    func optionsJSON<T: Decodable>(decoder: JSONDecoder? = nil, block: TransportBlock? = nil) -> Promise<T> {
        return client.optionsJSON(self, decoder: decoder ?? jsonDecoder, with: block)
    }
    
    func headJSON<T: Decodable>(decoder: JSONDecoder? = nil, block: TransportBlock? = nil) -> Promise<T> {
        return client.headJSON(self, decoder: decoder ?? jsonDecoder, with: block)
    }
}
