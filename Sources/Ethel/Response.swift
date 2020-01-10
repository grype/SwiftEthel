//
//  File.swift
//  
//
//  Created by Pavel Skaldin on 1/9/20.
//

import Foundation

public struct Response {
    /// Actual URLResponse
    var urlResponse: URLResponse?
    /// Optional URL where response data is stored
    var url: URL?
    /// Optional Data from the response
    var data: Data?
    /// Response error
    var error: Error?
}
