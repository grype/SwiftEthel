//
//  File.swift
//  
//
//  Created by Pavel Skaldin on 2/10/20.
//

import Foundation
import PromiseKit
import Beacon

// MARK:- Cursor

/**
 I describe a cursor for iterating over a `SequenceEndpoint`.
 
 My implementor is expected to respond to `hasMore` with a false value
 when there are no more results left to fetch.
 */
public protocol Cursor {
    var hasMore: Bool { get }
}


// MARK:- CursoredIterator

/**
 I am specialized implementation of `EndpointIterator` that uses
 `Cursor` for tracking enumeration of results from a `SequenceEndpoint`.
 
 I simply hide all of the machinery used for setting up an `EndpointIterator`
 and enumerating over collections of results fetched within a single request.
 
 I am used by `CursoredEndpoint`, which makes it easy to extend endpoints with
 enumerating behavior.
 */
public class CursoredIterator<U: SequenceEndpoint, V: Cursor> : EndpointIterator {
    public typealias Element = U.Element
    
    open var endpoint: U
    
    open var cursor: V
    
    open var hasMore: Bool { cursor.hasMore }
    
    open var currentOffset: Int = 0
    
    open var elements: [Element]?
    
    // MARK: Init
    
    init(endpoint anEndpoint: U, cursor aCursor: V) {
        endpoint = anEndpoint
        cursor = aCursor
    }
    
    // MARK: Testing
    
    open var needsFetch: Bool {
        guard hasMore else { return false }
        return elements == nil || currentOffset >= elements!.count
    }
    
    // MARK: Enumerating
    
    open func next() -> Element? {
        guard hasMore else { return nil }
        
        if needsFetch {
            fetch()
            currentOffset = 0
        }
        
        guard let elements = elements, !elements.isEmpty else { return nil }
        
        let result = elements[currentOffset]
        currentOffset += 1
        return result
    }
    
    open func fetch() {
        do {
            elements = try endpoint.next(with: self as! U.Iterator).wait()
        } catch {
            elements = nil
            emit(error: error)
        }
    }
}


// MARK:- CursoredEndpoint

/**
 I extend `SequenceEndpoint` to simplify the implementation,
 hiding the iterator machinery and using a simple `Cursor` object.
 */
public protocol CursoredEndpoint : SequenceEndpoint {
    associatedtype EndpointCursor: Cursor
    func makeCursor() -> EndpointCursor
    func next(with: EndpointCursor) -> Promise<[Element]>
}

extension CursoredEndpoint {
    public func makeIterator() -> CursoredIterator<Self, EndpointCursor> {
        return CursoredIterator(endpoint: self, cursor: makeCursor())
    }
    
    public func next(with anIterator: Iterator) -> Promise<[Element]> {
        let cursoredIterator = anIterator as! CursoredIterator<Self,EndpointCursor>
        return next(with: cursoredIterator.cursor)
    }
    
}
