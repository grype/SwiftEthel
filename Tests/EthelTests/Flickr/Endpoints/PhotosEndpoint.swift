//
//  PhotosEndpoint.swift
//  
//
//  Created by Pavel Skaldin on 10/25/22.
//  Copyright © 2022 Pavel Skaldin. All rights reserved.
//

import Foundation
import Ethel

class PhotosEndpoint: FlickrEndpoint {
    var client: Client
    var id: String?
    var path: Path?
    var method: String { "flickr.photos" }

    required init(on aClient: Client) {
        client = aClient
    }

    @TransportBuilder
    func prepare() -> TransportBuilding {
        if let id = id {
            AddQuery(name: "photo_id", value: id)
        }
    }

    var sizes: [Size] {
        get async throws {
            let response: Response = try await execute {
                Get()
                AddQuery(name: "method", value: "\(self.method).getSizes")
            }
            return response.sizes?.sizes ?? []
        }
    }
}

extension Flickr {
    func photo(with anId: String) -> PhotosEndpoint {
        let endpoint = self / PhotosEndpoint.self
        endpoint.id = anId
        return endpoint
    }

    var photos: PhotosEndpoint { self / PhotosEndpoint.self }
}
