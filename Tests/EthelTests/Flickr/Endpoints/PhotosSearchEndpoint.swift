//
//  PhotosSearchEndpoint.swift
//  
//
//  Created by Pavel Skaldin on 10/25/22.
//  Copyright © 2022 Pavel Skaldin. All rights reserved.
//

import Foundation
import Ethel


class PhotosSearchEndpoint: PagingEndpoint {
    typealias Element = Photo
    typealias EndpointCursor = PagingCursor
    
    struct Query {
        var text: String?
        
        @TransportBuilder
        func prepare() -> TransportBuilding {
            if let text = text {
                AddQuery(name: "text", value: text)
            }
        }
    }

    var page: Int = 1

    var pageSize: Int = 100

    var method: String { "flickr.photos.search" }

    var client: Client

    var path: Path?

    var query: Query?

    required init(on aClient: Client) {
        client = aClient
    }

    @TransportBuilder
    func prepare() -> TransportBuilding {
        preparePaging()
        if let query = query {
            query.prepare()
        }
    }
}

extension PhotosEndpoint {
    var search: PhotosSearchEndpoint { self / PhotosSearchEndpoint.self }

    func search(query: PhotosSearchEndpoint.Query) -> PhotosSearchEndpoint {
        let endpoint = self / PhotosSearchEndpoint.self
        endpoint.query = query
        return endpoint
    }
}
