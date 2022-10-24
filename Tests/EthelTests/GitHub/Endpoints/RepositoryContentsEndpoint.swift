//
//  GHRepositoryContentsEndpoint.swift
//  Ethel
//
//  Created by Pavel Skaldin on 1/4/22.
//  Copyright © 2022 Pavel Skaldin. All rights reserved.
//

import Ethel
import Foundation

class RepositoryContentsEndpoint: GitHubEndpoint, RepositoryBasedEndpoint {
    var owner: String?
    var repository: String?
    override var path: Path? { "/repos/\(owner!)/\(repository!)/contents" }

    func get(at aPath: Path) async throws -> OneOrMany<FileDescription> {
        try await execute {
            Get(aPath)
            DecodeJSON<OneOrMany<FileDescription>>()
        }
    }

    subscript(path: Path) -> OneOrMany<FileDescription> {
        get async throws { try await get(at: path) }
    }
}

extension RepositoryEndpoint {
    var contents: RepositoryContentsEndpoint { self / RepositoryContentsEndpoint.self }
}
