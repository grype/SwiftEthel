//
//  SequenceEndpoint.swift
//  Ethel
//
//  Created by Pavel Skaldin on 1/24/20.
//  Copyright © 2020 Pavel Skaldin. All rights reserved.
//

import Foundation

struct LimitError: Error {}

/**
 I describe an iterator over a `SequenceEndpoint`.

 I extend `IteratorProtocol` with an additional variable `hasMore`,
 which should indicate whether there are any more results to fetch.
 */
public protocol EndpointIterator: AsyncIteratorProtocol {
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
public protocol SequenceEndpoint: AsyncSequence {
    associatedtype AsyncIterator = EndpointIterator
    func next(with: AsyncIterator) async throws -> [Element]
}
