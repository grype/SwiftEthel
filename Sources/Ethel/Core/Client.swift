//
//  Client.swift
//  Ethel
//
//  Created by Pavel Skaldin on 7/18/19.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

import Beacon
import Foundation

// MARK: - Types

public typealias TransportBlock = (Transport) -> Void

// MARK: - Client

/**
 I am a base class for defining a web API client.
 
 I typically need to be subclassed as I provide very limitted functionality.
 I maintain a reference to the base url of the API, which is typically the longest
 common path for all of my endpoints.
 
 *Instantiating*
 
 Instantiate me with a base URL and a `URLSessionConfiguration`, which I use
 for configuring `URLSession`s when making requests.
 
 My sole purpose is to capture common behavior that is shared by all endpoints, or
 by groups of endpoints - i.e., I could provide methods for configuring authenticated
 requests vs un-authenticated.
 
 The rest of the behavior should be defined in the individual `Endpoint`s.
 
 *Deriving endpoints*
 
 I can create endpoints using `/` operator, much like an endpoints can. For example, the following
 two statements are equivalent - they both result in an instance of MyEndpoint configured with a client:
 
 ```
 MyEndpoint(client: client)
 client / MyEndpoint.self
 ```
 
 When creating endpoints this way, the final path of the endpoint is resolved using
 both the client's `baseUrl` and the endpoints's `path`, if one is present.
 
 *Making requests*
 
 Requests are typically initiated by an endpoint calling its `execute()` method, which in turn
 calls my `execute()` method, passing in a reference to the endpoint. I then create a `Transport` object and
 configure it by calling `prepare()`. I then ask the endpoint to do the same by calling its `prepare()` method.
 If the caller provided a block, I'll then evaluate it, allowing the caller to further configure the transport
 object before it is executed. Finally, I execute the transport object, which results in an asynchronous url task.
 I maintain a table of those `tasks`, removing them as they complete (with or without errors).
 
 Lastly, requests are executed on a dedicated `queue`, which I will create if one wasn't provided at the time of initialization.
 During execution I will set up a queue-specific variable `CurrentContext`. Any method that is called from within the execution phase
 can access it via my `queue` variable. That context objet will contain both the transport and the endpoint objects that initiated
 current request.
 
 *Subclassing*
 
 * Override `prepare()` if you need to configure requests in a way that is common to all endpoints.
 * Provide accessors for top-tier endpoints (e.g. `var other: OtherEndpoint { self / OtherEndpoint.self}`.
   This makes it possible to mimic the API map.
 
 */
open class Client: NSObject, URLSessionDataDelegate, URLSessionDownloadDelegate {
    open private(set) var baseUrl: URL
    
    open private(set) var session: URLSession!
    
    private(set) var tasks = [URLSessionTask: Transport]()
    
    // MARK: Init
    
    public convenience init(_ urlString: String, sessionConfiguration: URLSessionConfiguration? = nil) {
        self.init(URL(string: urlString)!, sessionConfiguration: sessionConfiguration)
    }
    
    public init(_ anUrl: URL, sessionConfiguration: URLSessionConfiguration? = nil) {
        baseUrl = anUrl
        super.init()
        initializeURLSession(sessionConfiguration)
    }
    
    private func initializeURLSession(_ sessionConfiguration: URLSessionConfiguration?) {
        let sessionConfig = sessionConfiguration ?? URLSessionConfiguration.default
        session = URLSession(configuration: sessionConfig, delegate: self, delegateQueue: nil)
    }
    
    // MARK: Configuring
    
    open func createTransport() -> Transport {
        return Transport(session)
    }
    
    @TransportBuilder
    open func prepare() -> TransportBuilding {
        if let path = Context.current?.endpoint.path {
            Request(baseUrl.resolving(path))
        }
        else {
            Request(baseUrl)
        }
    }
    
    /// Returns an error if response is considered erroneous
    open func validate(response: URLResponse) -> Error? {
        guard let response = response as? HTTPURLResponse else { return nil }
        if response.statusCode >= 200, response.statusCode < 300 {
            return nil
        }
        return ResponseError.httpError(code: response.statusCode)
    }
    
    // MARK: Executing
    
    open func execute<T>(_ endpoint: Endpoint, @TransportBuilder with block: () -> TransportBuilding) async throws -> T {
        let transport = createTransport()
        try await Context.with(.init(endpoint: endpoint, transport: transport)) {
            prepare().apply(to: transport)
            endpoint.prepare().apply(to: transport)
            block().apply(to: transport)
            try await transport.execute()
        }
        let contents = try transport.getResponseContents()
        guard let typedContents = contents as? T else {
            throw ResponseError.unexpectedResponseType(expected: T.self, actual: type(of: contents))
        }
        return typedContents
    }
    
    // MARK: URLSessionDelegate
    
    open func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        if let error = error {
            emit(error: error, on: Beacon.ethel)
        }
        else {
            emit(session, on: Beacon.ethel)
        }
        tasks.forEach { _, transport in
            transport.urlSession(session, didBecomeInvalidWithError: error)
        }
    }
    
    // MARK: URLSessionTaskDelegate
    
    open func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            emit(error: error, on: Beacon.ethel)
        }
        else {
            emit(task, on: Beacon.ethel)
        }
        guard let transport = tasks[task] else {
            emit("Could not find task in registry: \(task)")
            return
        }
        transport.urlSession(session, task: task, didCompleteWithError: error)
    }
    
    open func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        guard let transport = tasks[dataTask] else {
            emit("Could not find task in registry: \(dataTask)")
            return
        }
        transport.urlSession(session, dataTask: dataTask, didReceive: data)
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        guard let transport = tasks[task] else {
            emit("Could not find task in registry: \(task)")
            return
        }
        transport.urlSession(session, task: task, didSendBodyData: bytesSent, totalBytesSent: totalBytesSent, totalBytesExpectedToSend: totalBytesExpectedToSend)
    }
    
    // MARK: - URLSessionDownloadDelegate

    open func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let transport = tasks[downloadTask] else {
            emit("Could not find task in registry: \(downloadTask)")
            return
        }
        transport.urlSession(session, downloadTask: downloadTask, didFinishDownloadingTo: location)
    }
    
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        guard let transport = tasks[downloadTask] else {
            emit("Could not find task in registry: \(downloadTask)")
            return
        }
        transport.urlSession(session, downloadTask: downloadTask, didWriteData: bytesWritten, totalBytesWritten: totalBytesWritten, totalBytesExpectedToWrite: totalBytesExpectedToWrite)
    }
}

// MARK: - Extensions

public func / <T: Endpoint>(left: Client, right: T.Type) -> T {
    return right.init(on: left)
}

extension DispatchQueue {
    static var currentQueueLabel: String? {
        let name = __dispatch_queue_get_label(nil)
        return String(cString: name, encoding: .utf8)
    }
    
    static var current: DispatchQueue? {
        guard let label = currentQueueLabel else { return nil }
        return DispatchQueue(label: label)
    }
}
