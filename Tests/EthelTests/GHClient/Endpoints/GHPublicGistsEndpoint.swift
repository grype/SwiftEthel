//
//  File.swift
//  
//
//  Created by Pavel Skaldin on 1/25/20.
//

import Foundation
import PromiseKit
@testable import Ethel

class GHPublicGistsEndpoint : GHEndpoint {
    
    override class var path : Path { GHGistsEndpoint.path / "public" }
    
    var since: Date?
    
    func configure(on aTransport: Transport) {
        if let since = since {
            aTransport.add(queryItem: URLQueryItem(name: "since", value: dateFormatter.string(from: since)))
        }
    }
    
    func list() -> Promise<[GHGist]> {
        return getJSON()
    }
}

extension GHPublicGistsEndpoint : SequenceEndpoint {
    
    typealias Iterator = GHIterator<GHPublicGistsEndpoint>
    typealias Element = GHGist
    
    func makeIterator() -> Iterator {
        return GHIterator(self)
    }
    
    func next(with iterator: Iterator) -> Promise<[GHGist]> {
        return getJSON() { (transport) in
            transport.add(queryItem: URLQueryItem(name: "page", value: "\(iterator.page)"))
            transport.add(queryItem: URLQueryItem(name: "per_page", value: "\(iterator.pageSize)"))
        }
    }
  
}
