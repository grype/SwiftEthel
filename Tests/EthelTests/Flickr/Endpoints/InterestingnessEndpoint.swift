//
//  InterestingnessEndpoint.swift
//  
//
//  Created by Pavel Skaldin on 10/25/22.
//  Copyright © 2022 Pavel Skaldin. All rights reserved.
//

import Foundation
import Ethel

class InterestingnessEndpoint: PagingEndpoint {
    typealias Element = Photo
    typealias EndpointCursor = PagingCursor

    var page: Int = 1

    var pageSize: Int = 100

    var method: String { "flickr.interestingness.getList" }

    var client: Client

    var path: Path?

    required init(on aClient: Client) {
        client = aClient
    }

    @TransportBuilder
    func prepare() -> TransportBuilding {
        preparePaging()
    }
}

extension Flickr {
    var interestingness: InterestingnessEndpoint { self / InterestingnessEndpoint.self }
}
