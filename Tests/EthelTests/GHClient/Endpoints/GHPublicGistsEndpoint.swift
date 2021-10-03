//
//  File.swift
//
//
//  Created by Pavel Skaldin on 1/25/20.
//

@testable import Ethel
import Foundation
import PromiseKit

class GHPublicGistsEndpoint: GHPaginatedEndpoint<GHGist> {
    override var path: Path { "/gists/public" }

    var since: Date?

    @TransportBuilder override func prepare() -> TransportBuilding {
        super.prepare()
        if let since = since {
            AddQuery(name: "since", value: dateFormatter.string(from: since))
        }
    }

    func fetch() -> Promise<[GHGist]> {
        execute {
            Get()
            DecodeJSON<[GHGist]>()
        }
    }
}
