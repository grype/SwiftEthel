//
//  Client.swift
//  Ethel
//
//  Created by Pavel Skaldin on 7/18/19.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

import Foundation
import PromiseKit

public typealias ExecutionBlock = (Transport) -> Void

public protocol Client {
    
    var baseUrl: URL { get }
    
    var session: URLSession { get }
    
    func configure(on aTransport: Transport)
    
    func execute<T>(_ endpoint: Endpoint, with anExecBlock: ExecutionBlock?) -> Promise<T>
    
}

extension Client {
    
    public func createTransport() -> Transport {
        return Transport(session)
    }
    
    public func configure(on aTransport: Transport) {
        aTransport.request = URLRequest(url: baseUrl)
    }
    
    public func execute<T>(_ endpoint: Endpoint, with anExecBlock: ExecutionBlock? = nil) -> Promise<T> {
        let transport = createTransport()
        configure(on: transport)
        endpoint.configure(on: transport)
        if let execBlock = anExecBlock {
            execBlock(transport)
        }
        return Promise<T> { seal in
            transport.execute { (transport) in
                seal.resolve(transport.contents as? T, transport.responseError)
            }
        }
    }
}

func /<T: Endpoint>(left: Client, right: T.Type) -> T {
    return right.init(on: left)
}
