//
//  URLRequest+Query.swift
//  Ethel
//
//  Created by Pavel Skaldin on 10/1/21.
//  Copyright © 2021 Pavel Skaldin. All rights reserved.
//

import Foundation

public extension URLRequest {
    mutating func add(queryItem: URLQueryItem) {
        add(queryItems: [queryItem])
    }
    
    mutating func remove(queryItem: URLQueryItem) {
        remove(queryItems: [queryItem])
    }
    
    mutating func add(queryItems: [URLQueryItem]) {
        url = url?.adding(queryItems: queryItems)
    }
    
    mutating func remove(queryItems: [URLQueryItem]) {
        url = url?.removing(queryItems: queryItems)
    }
    
    mutating func removeAllQueryItems() {
        url = url?.removingAllQueryItems()
    }
}
