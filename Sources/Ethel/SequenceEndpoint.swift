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
    func forEach(until: (Element) -> Bool, body: (Element) throws -> Void) rethrows
    
    func filter(limit: Int, isIncluded: (Element) throws -> Bool) rethrows -> [Element]
    func filter(until: (Element) -> Bool, isIncluded: (Element) throws -> Bool) rethrows -> [Element]
    
    func sorted(limit: Int, by block: (Element, Element) throws -> Bool) rethrows -> [Element]
    func sorted(until: (Element) -> Bool, by block: (Element, Element) throws -> Bool) rethrows -> [Element]
}

extension SequenceEndpoint {
    
    func forEach(limit: Int, body: (Element) throws -> Void) rethrows {
        var count = 0
        try forEach(until: { (each) -> Bool in
            count += 1
            return count >= limit
        }, body: body)
    }
    
    func forEach(until: (Element) -> Bool, body: (Element) throws -> Void) rethrows {
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
    
    func filter(limit: Int, isIncluded: (Element) throws -> Bool) rethrows -> [Element] {
        var count = 0
        return try filter(until: { (each) -> Bool in
            count += 1
            return count >= limit
        }, isIncluded: isIncluded)
    }
    
    func filter(until: (Element) -> Bool, isIncluded: (Element) throws -> Bool) rethrows -> [Element] {
        var results = [Element]()
        do {
            let _ = try filter { (each) -> Bool in
                guard try isIncluded(each) else { return false }
                results.append(each)
                if until(each) {
                    throw(LimitError())
                }
                return true
            }
        } catch {
            if let _ = error as? LimitError {
                return results
            }
            throw error
        }
        return results
    }
    
    func sorted(limit: Int, by block: (Element, Element) throws -> Bool) rethrows -> [Element] {
        var count = 0
        return try sorted(until: { (each) -> Bool in
            count += 1
            return count >= limit
        }, by: block)
    }
    
    func sorted(until: (Element) -> Bool, by block: (Element, Element) throws -> Bool) rethrows -> [Element] {
        var result = [Element]()
        forEach(until: until) { (each) in
            result.append(each)
        }
        return try result.sorted(by: block)
    }
        
}
