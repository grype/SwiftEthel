//
//  GHRepositoryEndpoint.swift
//
//
//  Created by Pavel Skaldin on 1/5/22.
//

import Ethel
import Foundation

class GHRepositoryEndpoint: GHEndpoint, GHRepositoryBasedEndpoint {
    var owner: String?
    var repository: String?

    override func configureDerivedEndpoint(_ anEndpoint: Endpoint) {
        guard var repoEndpoint = anEndpoint as? GHRepositoryBasedEndpoint else { return }
        repoEndpoint.repository = repository
        repoEndpoint.owner = owner
    }
}

extension GHClient {
    func repository(_ name: String, owner: String) -> GHRepositoryEndpoint {
        let ep = self / GHRepositoryEndpoint.self
        ep.owner = owner
        ep.repository = name
        return ep
    }
}
