//
//  Client.swift
//  Ethel
//
//  Created by Pavel Skaldin on 7/18/19.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

import Foundation
import PromiseKit

public typealias ExecutionBlock = (Request) -> Void

public protocol Client {
    
    var baseUrl: URL { get }
    
    var session: URLSession { get }
    
    func configure(on aBuilder: Request)
    
    func createRequest() -> Request
    
    func execute<T>(_ endpoint: Endpoint, with anExecBlock: ExecutionBlock?) -> Promise<T>
    
}

extension Client {
    
    func createRequest() -> Request {
        return Request(baseUrl, session: session)
    }
    
    public func configure(on aBuilder: Request) {
        
    }
    
    public func execute<T>(_ endpoint: Endpoint, with anExecBlock: ExecutionBlock? = nil) -> Promise<T> {
        let request = createRequest()
        configure(on: request)
        endpoint.configure(on: request)
        if let execBlock = anExecBlock {
            execBlock(request)
        }
        return Promise<T> { seal in
            request.execute { (response) in
                seal.resolve(response as? T, response.error)
            }
        }
    }
}

func /<T: Endpoint>(left: Client, right: T.Type) -> T {
    return right.init(on: left)
}
