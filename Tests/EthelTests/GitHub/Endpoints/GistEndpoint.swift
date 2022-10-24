//
//  GistEndpoint.swift
//  Ethel
//
//  Created by Pavel Skaldin on 10/3/21.
//  Copyright © 2021 Pavel Skaldin. All rights reserved.
//

@testable import Ethel
import Foundation

class GistEndpoint: GitHubEndpoint {
    override var path: Path? { "/gists/\(String(describing: id))" }

    var id: String?

    func delete() async throws -> Any? {
        try await execute {
            Delete()
        }
    }
}
