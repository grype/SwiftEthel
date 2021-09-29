//
//  File.swift
//
//
//  Created by Pavel Skaldin on 1/24/20.
//

import Foundation
import PromiseKit

struct LimitError: Error {}

/**
 I describe an iterator over a `SequenceEndpoint`.
 
 I extend `IteratorProtocol` with an additional variable `hasMore`,
 which should indicate whether there are any more results to fetch.
 */
public protocol EndpointIterator: IteratorProtocol {
    var hasMore: Bool { get }
}

/**
 I describe an interface for endpoints that feed sequential data.
 
 Such endpoints typically provide a paginated interface to the underlying data.
 I am making it possible to treat that data as a regular collection.
 
 I augment `Sequence` protocol with variants of enumerating functions that
 provide limittingn control over the enumeration. For example, `forEach(limit:body:)` and
 `forEach(until:body:)`.
 
 I produce a specialized `EndpointIterator` that handles enumeration and calls my implementor's
 `next(with:)` function, expecting a collection of results. The reason for expecting a collection of results
 is to simplify the definition of that method, given that paginated endpoints often return a collection
 even if one result is returned in that collection. Secondly, it would minimize the number of network
 requests. For that reason, it is up to the implementor of `EndpointIterator` to enumerate over the results
 as appropriate.
 
 In most cases, enumeration can be done via a simpler interface, using `CursorEndpoint`, which mimics
 this mechanism, using simple instances of `Cursor`, as opposed to iterators.
 */
public protocol SequenceEndpoint: Sequence {
    associatedtype Iterator = EndpointIterator
    
    func makeIterator() -> Iterator
    func next(with: Iterator) -> Promise<[Element]>
    
    func forEach(limit: Int, body: (Element) throws -> Void) rethrows
    func forEach(until: (Element) -> Bool, body: (Element) throws -> Void) rethrows
    
    func filter(limit: Int, isIncluded: (Element) throws -> Bool) rethrows -> [Element]
    func filter(until: (Element) -> Bool, isIncluded: (Element) throws -> Bool) rethrows -> [Element]
    
    func sorted(limit: Int, by block: (Element, Element) throws -> Bool) rethrows -> [Element]
    func sorted(until: (Element) -> Bool, by block: (Element, Element) throws -> Bool) rethrows -> [Element]
    
    func compactMap<ElementOfResult>(limit: Int, transform: (Element) throws -> ElementOfResult?) rethrows -> [ElementOfResult]
    func compactMap<ElementOfResult>(until: (Element) -> Bool, transform: (Element) throws -> ElementOfResult?) rethrows -> [ElementOfResult]
    
    func flatMap<SegmentOfResult>(limit: Int, transform: (Element) throws -> SegmentOfResult) rethrows -> [SegmentOfResult.Element] where SegmentOfResult: Sequence
    func flatMap<SegmentOfResult>(until: (Element) -> Bool, transform: (Element) throws -> SegmentOfResult) rethrows -> [SegmentOfResult.Element] where SegmentOfResult: Sequence
    
    func reduce<Result>(limit: Int, initialResult: Result, _ nextPartialResult: (Result, Element) throws -> Result) rethrows -> Result
    func reduce<Result>(until: (Element) -> Bool, initialResult: Result, _ nextPartialResult: (Result, Element) throws -> Result) rethrows -> Result
}

public extension SequenceEndpoint {
    func forEach(limit: Int, body: (Element) throws -> Void) rethrows {
        var count = 0
        try forEach(until: { _ -> Bool in
            count += 1
            return count >= limit
        }, body: body)
    }
    
    func forEach(until: (Element) -> Bool, body: (Element) throws -> Void) rethrows {
        do {
            try forEach { each in
                try body(each)
                if until(each) {
                    throw (LimitError())
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
        return try filter(until: { _ -> Bool in
            count += 1
            return count >= limit
        }, isIncluded: isIncluded)
    }
    
    func filter(until: (Element) -> Bool, isIncluded: (Element) throws -> Bool) rethrows -> [Element] {
        var results = [Element]()
        do {
            _ = try filter { each -> Bool in
                guard try isIncluded(each) else { return false }
                results.append(each)
                if until(each) {
                    throw (LimitError())
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
        return try sorted(until: { _ -> Bool in
            count += 1
            return count >= limit
        }, by: block)
    }
    
    func sorted(until: (Element) -> Bool, by block: (Element, Element) throws -> Bool) rethrows -> [Element] {
        var result = [Element]()
        forEach(until: until) { each in
            result.append(each)
        }
        return try result.sorted(by: block)
    }
    
    func compactMap<ElementOfResult>(limit: Int, transform: (Element) throws -> ElementOfResult?) rethrows -> [ElementOfResult] {
        var count = 0
        return try compactMap(until: { _ -> Bool in
            count += 1
            return count >= limit
        }, transform: transform)
    }
    
    func compactMap<ElementOfResult>(until: (Element) -> Bool, transform: (Element) throws -> ElementOfResult?) rethrows -> [ElementOfResult] {
        var result = [Element]()
        forEach(until: until) { each in
            result.append(each)
        }
        return try result.compactMap(transform)
    }
    
    func flatMap<SegmentOfResult>(limit: Int, transform: (Element) throws -> SegmentOfResult) rethrows -> [SegmentOfResult.Element] where SegmentOfResult: Sequence {
        var count = 0
        return try flatMap(until: { _ -> Bool in
            count += 1
            return count >= limit
        }, transform: transform)
    }
    
    func flatMap<SegmentOfResult>(until: (Element) -> Bool, transform: (Element) throws -> SegmentOfResult) rethrows -> [SegmentOfResult.Element] where SegmentOfResult: Sequence {
        var result = [Element]()
        forEach(until: until) { each in
            result.append(each)
        }
        return try result.flatMap(transform)
    }
    
    func reduce<Result>(limit: Int, initialResult: Result, _ nextPartialResult: (Result, Element) throws -> Result) rethrows -> Result {
        var count = 0
        return try reduce(until: { _ -> Bool in
            count += 1
            return count >= limit
        }, initialResult: initialResult, nextPartialResult)
    }
    
    func reduce<Result>(until: (Element) -> Bool, initialResult: Result, _ nextPartialResult: (Result, Element) throws -> Result) rethrows -> Result {
        var result: Result = initialResult
        do {
            result = try reduce(initialResult) { aResult, element -> Result in
                result = try nextPartialResult(aResult, element)
                if until(element) {
                    throw (LimitError())
                }
                return result
            }
        } catch {
            if let _ = error as? LimitError {
                return result
            }
            throw error
        }
        return result
    }
    
    func reduce<Result>(until: (Element) -> Bool, into initialResult: __owned Result, _ updateAccumulatingResult: (inout Result, Element) throws -> Void) rethrows -> Result {
        var result = initialResult
        do {
            result = try reduce(into: initialResult) { run, element in
                try updateAccumulatingResult(&run, element)
                result = run
                if until(element) {
                    throw (LimitError())
                }
            }
        } catch {
            if let _ = error as? LimitError {
                return result
            }
            throw error
        }
        return result
    }
    
    func prefix(_ maxLength: Int) -> [Element] {
        var result = [Element]()
        forEach(limit: maxLength) { each in
            result.append(each)
        }
        return result
    }
}
