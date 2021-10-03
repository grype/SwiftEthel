//
//  File.swift
//  
//
//  Created by Pavel Skaldin on 10/2/21.
//

import Foundation

/**
 I describe a cursor for iterating over a `SequenceEndpoint`.
 
 My implementor is expected to respond to `hasMore` with a false value
 when there are no more results left to fetch.
 */
public protocol Cursor {
    var hasMore: Bool { get }
}
