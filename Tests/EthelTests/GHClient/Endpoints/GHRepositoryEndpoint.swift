//
//  GHRepositoryEndpoint.swift
//  Ethel
//
//  Created by Pavel Skaldin on 1/5/22.
//  Copyright © 2022 Pavel Skaldin. All rights reserved.
//

import Ethel
import Foundation

class GHRepositoryEndpoint: GHEndpoint, GHRepositoryBasedEndpoint {
    var owner: String?
    var repository: String?
    override var path: Path? { "/repos/\(owner!)/\(repository!)" }

    override func configureDerivedEndpoint(_ anEndpoint: Endpoint) {
        guard var repoEndpoint = anEndpoint as? GHRepositoryBasedEndpoint else { return }
        repoEndpoint.repository = repository
        repoEndpoint.owner = owner
    }

    func downloadArchive(to aUrl: URL) async throws {
        try await execute {
            Get("zipball")
            Download(to: aUrl)
        } as Void
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
