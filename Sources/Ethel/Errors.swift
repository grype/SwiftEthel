//
//  File.swift
//  
//
//  Created by Pavel Skaldin on 1/9/20.
//

import Foundation

public struct RequestError : Error {
    public var request: URLRequest!
    public init(_ aRequest: URLRequest) {
        request = aRequest
    }
}
