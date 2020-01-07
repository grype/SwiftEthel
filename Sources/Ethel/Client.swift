//
//  Client.swift
//  Ethel
//
//  Created by Pavel Skaldin on 7/18/19.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

import Foundation
import PromiseKit

struct RequestError : Error {
    var request: URLRequest!
    init(_ aRequest: URLRequest) {
        request = aRequest
    }
}

public class Client : Named {
    
    public typealias ExecutionBlock = (URLSession) -> Void
    
    public private(set) var baseUrl : URL!
    
    public lazy var session: URLSession = {
        URLSession(configuration: URLSessionConfiguration.background(withIdentifier: typeName))
    }()
    
    // MARK:- Initializing
    
    public init(_ aBaseUrl: URL) {
        baseUrl = aBaseUrl
    }
    
    // MARK:- Executing
    
    public func execute(_ endpoint: Endpoint, with anExecBlock: ExecutionBlock? = nil) -> Promise<URLSession> {
        endpoint.configure(on: session)
    }
    
}

func /(left: Client, right: Endpoint.Type) -> Endpoint {
    return right.init(left)
}
