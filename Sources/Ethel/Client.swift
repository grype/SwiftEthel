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

public class Client : NSObject, URLSessionDataDelegate {
    
    private(set) var baseUrl: URL?
    
    var session: URLSession!
    
    private var tasks = [URLSessionTask : Transport]()
    
    init(url anUrl: URL? = nil, sessionConfiguration: URLSessionConfiguration? = nil) {
        super.init()
        let sessionConfig = sessionConfiguration ?? URLSessionConfiguration.default
        baseUrl = anUrl
        session = URLSession(configuration: sessionConfig, delegate: self, delegateQueue: nil)
    }
    
    public func createTransport() -> Transport {
        return Transport(session)
    }
    
    public func configure(on aTransport: Transport) {
        if let baseUrl = baseUrl {
            aTransport.request = URLRequest(url: baseUrl)
        }
    }
    
    public func execute<T>(_ endpoint: Endpoint, with anExecBlock: ExecutionBlock? = nil) -> Promise<T> {
        let transport = createTransport()
        configure(on: transport)
        endpoint.configure(on: transport)
        if let execBlock = anExecBlock {
            execBlock(transport)
        }
        return Promise<T> { seal in
            let task = transport.execute { (transport, task) in
                seal.resolve(transport.contents as? T, transport.responseError)
                if let task = task {
                    self.tasks.removeValue(forKey: task)
                }
            }
            self.tasks[task] = transport
        }
    }
    
    public func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        self.tasks.forEach { (task, transport) in
            transport.urlSession(session, didBecomeInvalidWithError: error)
        }
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        self.tasks.forEach { (task, transport) in
            transport.urlSession(session, task: task, didCompleteWithError: error)
        }
    }
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        guard let transport = self.tasks[dataTask] else { return }
        transport.urlSession(session, dataTask: dataTask, didReceive: data)
    }
}

func /<T: Endpoint>(left: Client, right: T.Type) -> T {
    return right.init(on: left)
}
