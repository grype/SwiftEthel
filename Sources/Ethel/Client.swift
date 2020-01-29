//
//  Client.swift
//  Ethel
//
//  Created by Pavel Skaldin on 7/18/19.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

import Foundation
import PromiseKit
import Beacon

// MARK:- Types

public typealias TransportBlock = (Transport) -> Void

// MARK:- Client

open class Client : NSObject, URLSessionDataDelegate {
    
    private(set) var baseUrl: URL?
    
    private(set) var session: URLSession!
    
    private var tasks = [URLSessionTask : Transport]()
    
    open var loggers = [SignalLogger]()
    
    // MARK: Init
    
    public init(url anUrl: URL? = nil, sessionConfiguration: URLSessionConfiguration? = nil) {
        super.init()
        let sessionConfig = sessionConfiguration ?? URLSessionConfiguration.default
        baseUrl = anUrl
        session = URLSession(configuration: sessionConfig, delegate: self, delegateQueue: nil)
        loggers.append(ConsoleLogger(name: "Ethel.Client"))
    }
    
    // MARK: Configuring
    
    open func createTransport() -> Transport {
        return Transport(session)
    }
    
    open func configure(on aTransport: Transport) {
        if let baseUrl = baseUrl {
            aTransport.request = URLRequest(url: baseUrl)
        }
    }
    
    open var loggingEnabled = false {
        didSet {
            loggers.forEach { (logger) in
                if loggingEnabled {
                    logger.start()
                }
                else {
                    logger.stop()
                }
            }
        }
    }
    
    // MARK: Resolving
    
    open func resolve<T>(_ resolver: Resolver<T>, transport: Transport) {
        var contents: T?
        do {
            contents = try transport.getResponseContents() as? T
            var error: Error?
            if let response = transport.response {
                error = validate(response: response)
            }
            resolver.resolve(contents, error ?? transport.responseError)
        }
        catch {
            resolver.reject(error)
        }
    }
    
    /// Returns an error if response is considered erroneous, that is
    /// the Promise should be rejected
    open func validate(response: URLResponse) -> Error? {
        guard let response = response as? HTTPURLResponse else { return nil }
        if response.statusCode >= 200 && response.statusCode < 300 {
            return nil
        }
        return ResponseError(code: response.statusCode)
    }
    
    // MARK: Executing
    
    open func execute<T>(_ endpoint: Endpoint, with block: TransportBlock? = nil) -> Promise<T> {
        let transport = createTransport()
        configure(on: transport)
        endpoint.configure(on: transport)
        
        if let execBlock = block {
            execBlock(transport)
        }
        
        return Promise<T> { seal in
            let task = transport.execute { (transport, task) in
                self.resolve(seal, transport: transport)
                if let task = task {
                    self.tasks.removeValue(forKey: task)
                }
            }
            self.tasks[task] = transport
        }
    }
    
    open func execute<T>(method: String, endpoint: Endpoint, with block: TransportBlock? = nil) -> Promise<T> {
        return execute(endpoint) { (transport) in
            transport.request?.httpMethod = method
            block?(transport)
        }
    }
    
    open func get<T>(_ endpoint: Endpoint, with block: TransportBlock? = nil) -> Promise<T> {
        return execute(method: "GET", endpoint: endpoint, with: block)
    }
    
    open func delete<T>(_ endpoint: Endpoint, with block: TransportBlock? = nil) -> Promise<T> {
        return execute(method: "DELETE", endpoint: endpoint, with: block)
    }
    
    open func put<T>(_ endpoint: Endpoint, with block: TransportBlock? = nil) -> Promise<T> {
        return execute(method: "PUT", endpoint: endpoint, with: block)
    }
    
    open func post<T>(_ endpoint: Endpoint, with block: TransportBlock? = nil) -> Promise<T> {
        return execute(method: "POST", endpoint: endpoint, with: block)
    }
    
    open func patch<T>(_ endpoint: Endpoint, with block: TransportBlock? = nil) -> Promise<T> {
        return execute(method: "PATCH", endpoint: endpoint, with: block)
    }
    
    open func head<T>(_ endpoint: Endpoint, with block: TransportBlock? = nil) -> Promise<T> {
        return execute(method: "HEAD", endpoint: endpoint, with: block)
    }
    
    open func options<T>(_ endpoint: Endpoint, with block: TransportBlock? = nil) -> Promise<T> {
        return execute(method: "OPTIONS", endpoint: endpoint, with: block)
    }
    
    // MARK: URLSessionDelegate
    
    open func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        self.tasks.forEach { (task, transport) in
            transport.urlSession(session, didBecomeInvalidWithError: error)
        }
    }
    
    // MARK: URLSessionTaskDelegate
    
    open func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        self.tasks.forEach { (task, transport) in
            transport.urlSession(session, task: task, didCompleteWithError: error)
        }
    }
    
    open func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        guard let transport = self.tasks[dataTask] else { return }
        transport.urlSession(session, dataTask: dataTask, didReceive: data)
    }
}

// MARK:- Extensions

public func /<T: Endpoint>(left: Client, right: T.Type) -> T {
    return right.init(on: left)
}
