//
//  File.swift
//
//
//  Created by Pavel Skaldin on 1/25/20.
//

@testable import Ethel
import Foundation
import PromiseKit

class GHGistsEndpoint: GHPaginatedEndpoint<GHGist> {
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
