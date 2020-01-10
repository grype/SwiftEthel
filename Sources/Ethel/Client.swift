//
//  Client.swift
//  Ethel
//
//  Created by Pavel Skaldin on 7/18/19.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

import Foundation
import PromiseKit

public class Client {
    
    public typealias ExecutionBlock = (Request) -> Void
    
    public private(set) var baseUrl : URL!
    
    public lazy var session: URLSession = {
        URLSession(configuration: URLSessionConfiguration.background(withIdentifier: String(describing: type(of: self))))
    }()
    
    // MARK:- Initializing
    
    public init(_ aBaseUrl: URL) {
        baseUrl = aBaseUrl
    }
    
    // MARK:- Configuring
    
    public func configure(on aBuilder: Request) {
        
    }
    
    // MARK:- Executing
    
    func createRequest() -> Request {
        return Request(baseUrl, session: session)
    }
    
    public func execute(_ endpoint: Endpoint, with anExecBlock: ExecutionBlock? = nil) -> Promise<Response> {
        let request = createRequest()
        configure(on: request)
        endpoint.configure(on: request)
        if let execBlock = anExecBlock {
            execBlock(request)
        }
        return Promise<Response> { seal in
            request.execute { (response) in
                seal.resolve(response, response.error)
            }
        }
    }
    
}

func /<T: Endpoint>(left: Client, right: T.Type) -> T {
    return right.init(on: left)
}
