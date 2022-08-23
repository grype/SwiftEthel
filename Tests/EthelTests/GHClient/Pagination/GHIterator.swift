//
//  GHIterator.swift
//  Ethel
//
//  Created by Pavel Skaldin on 1/25/20.
//  Copyright © 2020 Pavel Skaldin. All rights reserved.
//

@testable import Ethel
import Foundation

struct GHIterator<U: SequenceEndpoint>: EndpointIterator {
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
    
    mutating func next() -> Element? {
        guard hasMore else { return nil }
        if needsFetch {
            fetch()
        }
        
        guard let elements = elements, elements.count > currentOffset else {
            return nil
        }
        let result = elements[currentOffset]
        currentOffset += 1
        return result
    }
    
    private mutating func fetch() {
        currentOffset = 0
        do {
            elements = try endpoint.next(with: self as! U.Iterator).wait()
            hasMore = (elements?.count ?? 0) == pageSize
            page += 1
        } catch {
            print("Error: \(error)")
        }
    }
}
