//
//  File.swift
//  
//
//  Created by Pavel Skaldin on 1/9/20.
//

import Foundation

struct RequestError : Error {
    var request: URLRequest!
    init(_ aRequest: URLRequest) {
        request = aRequest
    }
}
