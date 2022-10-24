//
//  GHClient.swift
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
public class GHClient: Client {
    static var `default` = GHClient("https://api.github.com/")

    /// Configure all requests with common headers
    @TransportBuilder
    override open func prepare() -> TransportBuilding {
        super.prepare()
        SetHeader(name: "Accept", value: "application/vnd.github.v3+json")
    }

    // MARK: - Endpoints

    /// Returns `GHGistsEndpoint` configured with this client
    var gists: GHGistsEndpoint { self / GHGistsEndpoint.self }
    
    func gist(id: String) async throws -> GHGist {
        let endpoint = self / GHGistEndpoint.self
        endpoint.id = id
        return try await endpoint.execute{
            Get()
            DecodeJSON<GHGist>()
        }
    }

    /// Returns `GHGistEndpoint` endpoint configured with this client
    func gist(id: String) -> GHGistEndpoint {
        let endpoint = self / GHGistEndpoint.self
        endpoint.id = id
        return endpoint
    }
}
