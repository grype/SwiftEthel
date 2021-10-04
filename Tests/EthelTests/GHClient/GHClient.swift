//
//  File.swift
//
//
//  Created by Pavel Skaldin on 1/25/20.
//

@testable import Ethel
import Foundation
import PromiseKit

/**
 I am an example implementation of GitHub API client with support for gists.

 I basically provide two things: 1) common Transport configuration and 2) access to the top tier endpoints (e.g. /gists)
 */
class GHClient: Client {
    static var `default` = GHClient("https://api.github.com/")

    /// Configure all requests with common headers
    @TransportBuilder override func prepare() -> TransportBuilding {
        super.prepare()
        Header(name: "Accept", value: "application/vnd.github.v3+json")
    }

    // MARK: - Endpoints

    /// Returns `GHGistsEndpoint` configured with this client
    var gists: GHGistsEndpoint { self / GHGistsEndpoint.self }

    /// Returns `GHGistEndpoint` endpoint configured with this client
    func gist(id: String) -> GHGistEndpoint {
        let endpoint = self / GHGistEndpoint.self
        endpoint.id = id
        return endpoint
    }
}
