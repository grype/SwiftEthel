//
//  GHIterator.swift
//  Ethel
//
//  Created by Pavel Skaldin on 1/25/20.
//  Copyright © 2020 Pavel Skaldin. All rights reserved.
//

@testable import Ethel
import Foundation

extension GitHubEndpoint {
    struct Iterator<U: SequenceEndpoint>: EndpointIterator {
        // MARK: - Iterator

        typealias Element = U.Element
        
        var endpoint: U
        
        // MARK: - Properties
        
        var hasMore: Bool = true
        
        var page: Int = 1
        
        var pageSize: Int = 5
        
        private var currentOffset: Int = 0
        
        private var elements: [Element]?
        
        // MARK: - Init
        
        init(_ anEndpoint: U) {
            endpoint = anEndpoint
        }
        
        // MARK: - Iterating
        
        private var needsFetch: Bool {
            guard hasMore else { return false }
            return elements == nil || currentOffset >= elements!.count
        }
        
        mutating func next() async throws -> Element? {
            guard hasMore else { return nil }
            if needsFetch {
                try await fetch()
            }
            
            guard let elements = elements, elements.count > currentOffset else {
                return nil
            }
            let result = elements[currentOffset]
            currentOffset += 1
            return result
        }
        
        private mutating func fetch() async throws {
            currentOffset = 0
            elements = try await endpoint.next(with: self as! U.AsyncIterator)
            hasMore = (elements?.count ?? 0) == pageSize
            page += 1
        }
    }
}
