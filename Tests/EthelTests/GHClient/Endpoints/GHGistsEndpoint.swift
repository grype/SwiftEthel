//
//  File.swift
//
//
//  Created by Pavel Skaldin on 1/25/20.
//

@testable import Ethel
import Foundation
import PromiseKit

class GHGistsEndpoint: GHEndpoint {
    override var path: Path? { "/gists" }

    var `public`: GHPublicGistsEndpoint { self / GHPublicGistsEndpoint.self }
    
    func gist(with id: String) -> Promise<GHGist> {
        return execute {
            Get("\(id)")
        }
    }
}
