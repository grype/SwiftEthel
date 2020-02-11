//
//  File.swift
//  
//
//  Created by Pavel Skaldin on 1/25/20.
//

import Foundation
import PromiseKit
@testable import Ethel

class GHGistsEndpoint : GHEndpoint {
    
    override var path: Path {
        return Path("/gists")
    }
    
    var `public` : GHPublicGistsEndpoint {
        return self / GHPublicGistsEndpoint.self
    }
    
    func gist(withId id: String) -> Promise<GHGist> {
        return getJSON(decoder: nil) { (transport) in
            transport.request?.url?.appendPathComponent(id)
        }
    }
}
