//
//  File.swift
//
//
//  Created by Pavel Skaldin on 1/25/20.
//

@testable import Ethel
import Foundation

struct GHIterator<U: SequenceEndpoint>: EndpointIterator {
    typealias Element = U.Element
    
    var endpoint: U
    
    var hasMore: Bool = true
    
    var page: Int = 1
    
    var pageSize: Int = 5
    
    private var currentOffset: Int = 0
    
    private var elements: [Element]?
    
    init(_ anEndpoint: U) {
        endpoint = anEndpoint
    }
    
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
