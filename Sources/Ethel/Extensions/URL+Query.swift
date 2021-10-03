//
//  File.swift
//
//
//  Created by Pavel Skaldin on 9/30/21.
//

import Foundation

public extension URL {
    func adding(queryItem: URLQueryItem) -> URL? {
        adding(queryItems: [queryItem])
    }
    
    func removing(queryItem: URLQueryItem) -> URL? {
        return removing(queryItems: [queryItem])
    }
    
    func adding(queryItems: [URLQueryItem]) -> URL? {
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: true) else { return nil }
        components.queryItems = (components.queryItems ?? []) + queryItems
        return components.url
    }
    
    func removing(queryItems itemsToRemove: [URLQueryItem]) -> URL? {
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: true),
                var queryItems = components.queryItems else { return nil }
        queryItems.removeAll { anItem -> Bool in
            itemsToRemove.contains(anItem)
        }
        components.queryItems = queryItems
        return components.url
    }
    
    func removingAllQueryItems() -> URL? {
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: true),
                var queryItems = components.queryItems else { return nil }
        queryItems.removeAll()
        components.queryItems = queryItems
        return components.url
    }
}
