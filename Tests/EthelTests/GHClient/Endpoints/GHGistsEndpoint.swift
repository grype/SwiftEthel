//
//  GHGistsEndpoint.swift
//  Ethel
//
//  Created by Pavel Skaldin on 1/25/20.
//  Copyright © 2020 Pavel Skaldin. All rights reserved.
//

@testable import Ethel
import Foundation

class GHGistsEndpoint: GHPaginatedEndpoint<GHGist>, GHDatedEndpoint {
    override var path: Path? { "/gists" }

    var since: Date?

    var `public`: GHPublicGistsEndpoint { self / GHPublicGistsEndpoint.self }

    @TransportBuilder override func prepare() -> TransportBuilding {
        super.prepare()
        if let since = since {
            AddQuery(name: "since", value: dateFormatter.string(from: since))
        }
    }
}
