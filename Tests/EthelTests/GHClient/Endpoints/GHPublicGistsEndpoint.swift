//
//  File.swift
//  
//
//  Created by Pavel Skaldin on 1/25/20.
//

import Foundation
import PromiseKit
@testable import Ethel

class GHPublicGistsEndpoint : GHPaginatedEndpoint<GHGist> {
    
    override var path: Path {
        return Path("/gists/public")
    }
    
    var since: Date?
    
    override func configure(on aTransport: Transport) {
        super.configure(on: aTransport)
        if let since = since {
            aTransport.add(queryItem: URLQueryItem(name: "since", value: dateFormatter.string(from: since)))
        }
    }
    
    func list() -> Promise<[GHGist]> {
        return getJSON()
    }

}
