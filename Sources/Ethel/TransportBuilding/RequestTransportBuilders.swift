//
//  File.swift
//  
//
//  Created by Pavel Skaldin on 10/1/21.
//

import Foundation

// MARK: -

public protocol TransportRouting : TransportBuilding {
    var method: String { get }
    var path: Path? { get }
}

public extension TransportRouting {
    func apply(to aTransport: Transport) {
        aTransport.request?.httpMethod = method
        if let path = path {
            let newUrl = aTransport.request?.url?.resolving(path)
            aTransport.request?.url = newUrl
        }
    }
}

public protocol TransportQuerying : TransportBuilding {
    var query: URLQueryItem { get }
}

public extension TransportQuerying {
    func apply(to aTransport: Transport) {
        aTransport.request?.add(queryItem: query)
    }
}

// MARK: -

public struct Request: TransportBuilding {
    var url: URL
    init(_ aUrl: URL) {
        url = aUrl
    }
    public func apply(to aTransport: Transport) {
        aTransport.request = URLRequest(url: url)
    }
}

public struct Get: TransportRouting {
    public var method: String { "GET" }
    public var path: Path?
    public init(_ aPath: Path? = nil) {
        path = aPath
    }
}

public struct Patch: TransportRouting {
    public var method: String { "PATCH" }
    public var path: Path?
    init(_ aPath: Path? = nil) {
        path = aPath
    }
}

public struct Put: TransportRouting {
    public var method: String { "PUT" }
    public var path: Path?
    init(_ aPath: Path? = nil) {
        path = aPath
    }
}

public struct Post: TransportRouting {
    public var method: String { "POST" }
    public var path: Path?
    init(_ aPath: Path? = nil) {
        path = aPath
    }
}

public struct Delete: TransportRouting {
    public var method: String { "DELETE" }
    public var path: Path?
    init(_ aPath: Path? = nil) {
        path = aPath
    }
}

public struct Options: TransportRouting {
    public var method: String { "OPTIONS" }
    public var path: Path?
    init(_ aPath: Path? = nil) {
        path = aPath
    }
}

public struct Head: TransportRouting {
    public var method: String { "HEAD" }
    public var path: Path?
    init(_ aPath: Path? = nil) {
        path = aPath
    }
}

// MARK: -

public struct AddQuery: TransportQuerying {
    public var query: URLQueryItem
    public init(_ aQuery: URLQueryItem) {
        query = aQuery
    }
    public init(name: String, value: String?) {
        self.init(URLQueryItem(name: name, value: value))
    }
}