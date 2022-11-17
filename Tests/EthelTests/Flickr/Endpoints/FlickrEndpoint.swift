//
//  FlickrEndpoint.swift
//  
//
//  Created by Pavel Skaldin on 10/25/22.
//

import Foundation
import Ethel

protocol FlickrEndpoint: Endpoint {
    var method: String { get }
}
