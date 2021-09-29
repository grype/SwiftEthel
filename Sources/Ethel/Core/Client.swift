//
//  Client.swift
//  Ethel
//
//  Created by Pavel Skaldin on 7/18/19.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

import Foundation
import PromiseKit

// MARK: - Types

public typealias TransportBlock = (Transport) -> Void

// MARK: - Client

/**
 I am a base class for defining a client for web APIs.
 
 I typically need to be subclassed as I provide very limitted functionality.
 I maintain a reference to the base url of the API, which is the longest
 common path for all of my endpoints.
 
 Instantiate me with a base URL and an `URLSessionConfiguration`, which I use
 for configuring `URLSession` when making requests.
 
 My sole purpose is to capture common behavior that is shared by all endpoints, or
 by groups of endpoints - i.e., I could provide methods for configuring authenticated
 requests vs un-authenticated.
 
 The rest of the behavior should be defined in the individual `Endpoint`s. I can create
 endpoints using `/` operator, much like an endpoints can. For example, the following
 two statements are equivalent - they both result in an instance of MyEndpoint configured
 with a client:
 
 ```
 MyEndpoint(client: client)
 client / MyEndpoint.self
 ```
 
 When creating endpoint instances this way, the final path of the endpoint is resolved using
 both the client's `baseUrl` and the endpoints's `path`
 
 Subclassing notes:
 
 Override `configureTransport` if you need to configure the request. This is done
 via an intermediate `Transport` object that gets passed into the function as the sole
 argument.
 */
open class Client: NSObject, URLSessionDataDelegate {
    private(set) var baseUrl: URL!
    
    private(set) var session: URLSession!
    
    private var tasks = [URLSessionTask: Transport]()
    
    // MARK: Init
    
    public convenience init(_ urlString: String, sessionConfiguration: URLSessionConfiguration? = nil) {
        self.init(URL(string: urlString)!, sessionConfiguration: sessionConfiguration)
    }
    
    public init(_ anUrl: URL, sessionConfiguration: URLSessionConfiguration? = nil) {
        super.init()
        baseUrl = anUrl
        initializeURLSession(sessionConfiguration)
    }
    
    fileprivate func initializeURLSession(_ sessionConfiguration: URLSessionConfiguration?) {
        let sessionConfig = sessionConfiguration ?? URLSessionConfiguration.default
        session = URLSession(configuration: sessionConfig, delegate: self, delegateQueue: nil)
    }
    
    // MARK: Configuring
    
    open func createTransport() -> Transport {
        return Transport(session)
    }
    
    open func configure(on aTransport: Transport) {
        aTransport.request = URLRequest(url: baseUrl)
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
        if response.statusCode >= 200, response.statusCode < 300 {
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
            let task = transport.execute { transport, task in
                self.resolve(seal, transport: transport)
                if let task = task {
                    self.tasks.removeValue(forKey: task)
                }
            }
            self.tasks[task] = transport
        }
    }
    
    open func execute<T>(method: String, endpoint: Endpoint, with block: TransportBlock? = nil) -> Promise<T> {
        return execute(endpoint) { transport in
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
        tasks.forEach { _, transport in
            transport.urlSession(session, didBecomeInvalidWithError: error)
        }
    }
    
    // MARK: URLSessionTaskDelegate
    
    open func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        tasks.forEach { task, transport in
            transport.urlSession(session, task: task, didCompleteWithError: error)
        }
    }
    
    open func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        guard let transport = tasks[dataTask] else { return }
        transport.urlSession(session, dataTask: dataTask, didReceive: data)
    }
}

// MARK: - Extensions

public func / <T: Endpoint>(left: Client, right: T.Type) -> T {
    return right.init(on: left)
}
