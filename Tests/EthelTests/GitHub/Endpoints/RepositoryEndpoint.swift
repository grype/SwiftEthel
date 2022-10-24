//
//  RepositoryEndpoint.swift
//  Ethel
//
//  Created by Pavel Skaldin on 1/5/22.
//  Copyright © 2022 Pavel Skaldin. All rights reserved.
//

import Ethel
import Foundation

class RepositoryEndpoint: GitHubEndpoint, RepositoryBasedEndpoint {
    var owner: String?
    var repository: String?
    override var path: Path? { "/repos/\(owner!)/\(repository!)" }

    override func configureDerivedEndpoint(_ anEndpoint: Endpoint) {
        guard var repoEndpoint = anEndpoint as? RepositoryBasedEndpoint else { return }
        repoEndpoint.repository = repository
        repoEndpoint.owner = owner
    }

    func downloadArchive(to aUrl: URL) async throws -> Any? {
        try await execute {
            Get("zipball")
            Download(to: aUrl)
        }
    }
}

extension GitHub {
    func repository(_ name: String, owner: String) -> RepositoryEndpoint {
        let ep = self / RepositoryEndpoint.self
        ep.owner = owner
        ep.repository = name
        return ep
    }
}
