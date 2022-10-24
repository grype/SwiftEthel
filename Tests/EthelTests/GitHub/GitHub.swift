//
//  GitHub.swift
//  Ethel
//
//  Created by Pavel Skaldin on 1/25/20.
//  Copyright © 2020 Pavel Skaldin. All rights reserved.
//

@testable import Ethel
import Foundation

/**
 I am an example implementation of GitHub API client with support for gists.

 I basically provide two things: 1) common Transport configuration and 2) access to the top tier endpoints (e.g. /gists)
 */
public class GitHub: Client {
    public static var `default` = GitHub("https://api.github.com/")

    /// Configure all requests with common headers
    @TransportBuilder
    override open func prepare() -> TransportBuilding {
        super.prepare()
        SetHeader(name: "Accept", value: "application/vnd.github.v3+json")
    }

    // MARK: - Endpoints

    var gists: GistsEndpoint { self / GistsEndpoint.self }
    
    func gist(id: String) async throws -> Gist {
        let endpoint = self / GistEndpoint.self
        endpoint.id = id
        return try await endpoint.execute{
            Get()
            DecodeJSON<Gist>()
        }
    }

    /// Returns `GHGistEndpoint` endpoint configured with this client
    func gist(id: String) -> GistEndpoint {
        let endpoint = self / GistEndpoint.self
        endpoint.id = id
        return endpoint
    }
}
