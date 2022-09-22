//
//  CursoredIterator.swift
//  Ethel
//
//  Created by Pavel Skaldin on 2/10/20.
//  Copyright © 2020 Pavel Skaldin. All rights reserved.
//

import Beacon
import Foundation

/**
 I am specialized implementation of `EndpointIterator` that uses
 `Cursor` for tracking enumeration of results from a `SequenceEndpoint`.
 
 I simply hide all of the machinery used for setting up an `EndpointIterator`
 and enumerating over collections of results fetched within a single request.
 
 I am used by `CursoredEndpoint`, which makes it easy to extend endpoints with
 enumerating behavior.
 */
public class CursoredIterator<U: SequenceEndpoint, V: Cursor>: EndpointIterator {
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
    
    open func next() async throws -> Element? {
        if needsFetch {
            try await fetch()
            currentOffset = 0
        }
        
        guard let elements = elements, !elements.isEmpty, currentOffset < elements.count else { return nil }
        
        let result = elements[currentOffset]
        currentOffset += 1
        return result
    }
    
    open func fetch() async throws {
        elements = try await endpoint.next(with: self as! U.Iterator)
    }
}

// MARK: - CursoredEndpoint

/**
 I extend `SequenceEndpoint` to simplify the implementation,
 hiding the iterator machinery and using a simple `Cursor` object.
 */
public protocol CursoredEndpoint: SequenceEndpoint {
    associatedtype EndpointCursor: Cursor
    func makeCursor() -> EndpointCursor
    func next(with: EndpointCursor) async throws -> [Element]
}

public extension CursoredEndpoint {
    func makeIterator() -> CursoredIterator<Self, EndpointCursor> {
        return CursoredIterator(endpoint: self, cursor: makeCursor())
    }
    
    func next(with anIterator: Iterator) async throws -> [Element] {
        let cursoredIterator = anIterator as! CursoredIterator<Self, EndpointCursor>
        return try await next(with: cursoredIterator.cursor)
    }
}
