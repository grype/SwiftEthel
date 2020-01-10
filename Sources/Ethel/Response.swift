//
//  File.swift
//  
//
//  Created by Pavel Skaldin on 1/9/20.
//

import Foundation

public struct Response<T> {
    /// Actual URLResponse
    var urlResponse: URLResponse?
    /// Optional URL where response data is stored
    var url: URL?
    /// Optional contents of the response
    var contents: T?
    /// Response error
    var error: Error?
}
