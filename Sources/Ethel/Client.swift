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

public class Client : NSObject, URLSessionDataDelegate {
    
    private(set) var baseUrl: URL?
    
    private(set) var session: URLSession!
    
    private var tasks = [URLSessionTask : Transport]()
    
    var loggers = [SignalLogger]()
    
    // MARK: Init
    
    init(url anUrl: URL? = nil, sessionConfiguration: URLSessionConfiguration? = nil) {
        super.init()
        let sessionConfig = sessionConfiguration ?? URLSessionConfiguration.default
        baseUrl = anUrl
        session = URLSession(configuration: sessionConfig, delegate: self, delegateQueue: nil)
        loggers.append(ConsoleLogger(name: "Ethel.Client"))
    }
    
    // MARK: Configuring
    
    public func createTransport() -> Transport {
        return Transport(session)
    }
    
    public func configure(on aTransport: Transport) {
        if let baseUrl = baseUrl {
            aTransport.request = URLRequest(url: baseUrl)
        }
    }
    
    public var loggingEnabled = false {
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
    
    // MARK: Executing
    
    public func execute<T>(_ endpoint: Endpoint, with block: TransportBlock? = nil) -> Promise<T> {
        let transport = createTransport()
        configure(on: transport)
        endpoint.configure(on: transport)
        
        if let execBlock = block {
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
    
    public func execute<T>(method: String, endpoint: Endpoint, with block: TransportBlock? = nil) -> Promise<T> {
        return execute(endpoint) { (transport) in
            transport.request?.httpMethod = method
            block?(transport)
        }
    }
    
    public func get<T>(_ endpoint: Endpoint, with block: TransportBlock? = nil) -> Promise<T> {
        return execute(method: "GET", endpoint: endpoint, with: block)
    }
    
    public func delete<T>(_ endpoint: Endpoint, with block: TransportBlock? = nil) -> Promise<T> {
        return execute(method: "DELETE", endpoint: endpoint, with: block)
    }
    
    public func put<T>(_ endpoint: Endpoint, with block: TransportBlock? = nil) -> Promise<T> {
        return execute(method: "PUT", endpoint: endpoint, with: block)
    }
    
    public func post<T>(_ endpoint: Endpoint, with block: TransportBlock? = nil) -> Promise<T> {
        return execute(method: "POST", endpoint: endpoint, with: block)
    }
    
    public func patch<T>(_ endpoint: Endpoint, with block: TransportBlock? = nil) -> Promise<T> {
        return execute(method: "PATCH", endpoint: endpoint, with: block)
    }
    
    public func head<T>(_ endpoint: Endpoint, with block: TransportBlock? = nil) -> Promise<T> {
        return execute(method: "HEAD", endpoint: endpoint, with: block)
    }
    
    public func options<T>(_ endpoint: Endpoint, with block: TransportBlock? = nil) -> Promise<T> {
        return execute(method: "OPTIONS", endpoint: endpoint, with: block)
    }
    
    // MARK: URLSessionDelegate
    
    public func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        self.tasks.forEach { (task, transport) in
            transport.urlSession(session, didBecomeInvalidWithError: error)
        }
    }
    
    // MARK: URLSessionTaskDelegate
    
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

// MARK:- Extensions

func /<T: Endpoint>(left: Client, right: T.Type) -> T {
    return right.init(on: left)
}

// MARK:- JSON Extensions

extension Client {
    public func executeJSON<T: Decodable>(method: String, endpoint: Endpoint, decoder: JSONDecoder = JSONDecoder(), with block: TransportBlock? = nil) -> Promise<T> {
        return execute(endpoint) { (transport) in
            transport.request?.httpMethod = method
            transport.contentReader = { (data) -> T? in
                var result: T?
                do {
                    result = try JSONDecoder().decode(T.self, from: data)
                }
                catch {
                    print("Error decoding JSON data: \(error)")
                }
                return result
            }
            block?(transport)
        }
    }
    
    public func getJSON<T: Decodable>(_ endpoint: Endpoint, decoder: JSONDecoder = JSONDecoder(), with block: TransportBlock? = nil) -> Promise<T> {
        return executeJSON(method: "GET", endpoint: endpoint, decoder: decoder, with: block)
    }
    
    public func putJSON<T: Decodable>(_ endpoint: Endpoint, decoder: JSONDecoder = JSONDecoder(), with block: TransportBlock? = nil) -> Promise<T> {
        return executeJSON(method: "PUT", endpoint: endpoint, decoder: decoder, with: block)
    }
    
    public func postJSON<T: Decodable>(_ endpoint: Endpoint, decoder: JSONDecoder = JSONDecoder(), with block: TransportBlock? = nil) -> Promise<T> {
        return executeJSON(method: "POST", endpoint: endpoint, decoder: decoder, with: block)
    }
    
    public func patchJSON<T: Decodable>(_ endpoint: Endpoint, decoder: JSONDecoder = JSONDecoder(), with block: TransportBlock? = nil) -> Promise<T> {
        return executeJSON(method: "PATCH", endpoint: endpoint, decoder: decoder, with: block)
    }
    
    public func optionsJSON<T: Decodable>(_ endpoint: Endpoint, decoder: JSONDecoder = JSONDecoder(), with block: TransportBlock? = nil) -> Promise<T> {
        return executeJSON(method: "OPTIONS", endpoint: endpoint, decoder: decoder, with: block)
    }
    
    public func headJSON<T: Decodable>(_ endpoint: Endpoint, decoder: JSONDecoder = JSONDecoder(), with block: TransportBlock? = nil) -> Promise<T> {
        return executeJSON(method: "HEAD", endpoint: endpoint, decoder: decoder, with: block)
    }
    
    public func deleteJSON<T: Decodable>(_ endpoint: Endpoint, decoder: JSONDecoder = JSONDecoder(), with block: TransportBlock? = nil) -> Promise<T> {
        return executeJSON(method: "DELETE", endpoint: endpoint, decoder: decoder, with: block)
    }
}
