//
//  File.swift
//  
//
//  Created by Pavel Skaldin on 1/24/20.
//

import Foundation
import PromiseKit

struct LimitError : Error {}

protocol EndpointIterator : IteratorProtocol {
    var hasMore: Bool { get }
}

protocol SequenceEndpoint : Sequence {
    associatedtype Iterator = EndpointIterator
    func makeIterator() -> Iterator
    func next(with: Iterator) -> Promise<[Element]>
    
    func forEach(limit: Int, body: (Element) throws -> Void) rethrows
    func forEach(until: (Element)->Bool, body: (Element) throws -> Void) rethrows
}

extension SequenceEndpoint {
    func forEach(limit: Int, body: (Element) throws -> Void) rethrows {
        var count = 0
        try forEach(until: { (each) -> Bool in
            count += 1
            return count >= limit
        }, body: body)
    }
    
    func forEach(until: (Element)->Bool, body: (Element) throws -> Void) rethrows {
        do {
            try forEach { (each) in
                try body(each)
                if until(each) {
                    throw(LimitError())
                }
            }
        } catch {
            if let _ = error as? LimitError {
                return
            }
            throw error
        }
    }
    
}
