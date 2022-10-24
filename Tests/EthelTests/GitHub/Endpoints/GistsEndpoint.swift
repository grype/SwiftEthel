//
//  GistsEndpoint.swift
//  Ethel
//
//  Created by Pavel Skaldin on 1/25/20.
//  Copyright © 2020 Pavel Skaldin. All rights reserved.
//

@testable import Ethel
import Foundation

class GistsEndpoint: PaginatedEndpoint<Gist>, DatedEndpoint {
    override var path: Path? { "/gists" }

    var since: Date?

    var `public`: PublicGistsEndpoint { self / PublicGistsEndpoint.self }

    @TransportBuilder override func prepare() -> TransportBuilding {
        super.prepare()
        if let since = since {
            AddQuery(name: "since", value: dateFormatter.string(from: since))
        }
    }
}
