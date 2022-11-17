//
//  Flickr.swift
//  
//
//  Created by Pavel Skaldin on 10/25/22.
//  Copyright © 2022 Pavel Skaldin. All rights reserved.
//

import Foundation
import Ethel

class Flickr: Client {
    static var defaultURL: URL = .init(string: "https://www.flickr.com/services/rest")!

    var apiKey: String

    var format: String { "json" }

    init(apiKey: String, url: URL = Flickr.defaultURL, sessionConfiguration: URLSessionConfiguration? = nil) {
        self.apiKey = apiKey
        super.init(url, sessionConfiguration: sessionConfiguration)
    }

    @TransportBuilder
    override func prepare() -> TransportBuilding {
        super.prepare()
        AddQuery(name: "api_key", value: apiKey)
        AddQuery(name: "format", value: format)
        if let endpoint = Context.current?.endpoint as? FlickrEndpoint {
            AddQuery(name: "method", value: endpoint.method)
        }
        DecodeFlickrResponse()
    }
}
