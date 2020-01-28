//
//  File.swift
//  
//
//  Created by Pavel Skaldin on 1/9/20.
//

import Foundation
import Beacon

// MARK:- Transport

open class Transport : NSObject{
    
    // MARK: Types
    
    enum RequestType {
        case data, download, upload
    }
    
    typealias Completion = (Transport, URLSessionTask?)->Void
    
    // MARK: Properties
    
    var session: URLSession
    
    var request: URLRequest?
    
    var response: URLResponse?
    
    var type: RequestType = .data
    
    var contentWriter: ((Any) throws -> Data?)?
    
    var contentReader: ((Data) throws -> Any?)?
    
    private(set) var hasResponse = false
    
    private(set) var responseData: Data?
    
    private(set) var responseError: Error?
    
    private var completion: Completion!
    
    private(set) var currentTask: URLSessionTask?
    
    // MARK: Initialization
    
    init(_ aSession: URLSession) {
        session = aSession
        super.init()
    }
    
    // MARK: Execution
    
    func execute(completion aCompletionBlock: @escaping Completion) -> URLSessionTask {
        guard let request = request else {
            fatalError("Transport has no configured request")
        }
        
        var task: URLSessionTask!
        
        task = session.dataTask(with: request)
        completion = aCompletionBlock
        task.resume()
        currentTask = task
        emit(self)
        return task
    }
    
    // MARK: URL
    
    var url: URL? {
        set {
            request?.url = newValue
        }
        get {
            return hasResponse ? response?.url : request?.url
        }
    }
    
    // MARK: Testing
    
    var isExecuting: Bool {
        return currentTask != nil
    }
    
    // MARK: Query
    
    func add(queryItem: URLQueryItem) {
        addAll(queryItems: [queryItem])
    }
    
    func remove(queryItem: URLQueryItem) {
        removeAll(queryItems: [queryItem])
    }
    
    func addAll(queryItems: [URLQueryItem]) {
        guard let url = request?.url else {
            fatalError("No request configured with URL")
        }
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else { return }
        components.queryItems = (components.queryItems ?? []) + queryItems
        request?.url = components.url
    }
    
    func removeAll(queryItems itemsToRemove: [URLQueryItem]) {
        guard let url = request?.url else {
            fatalError("No request configured with URL")
        }
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: true), var queryItems = components.queryItems else { return }
        queryItems.removeAll { (anItem) -> Bool in
            itemsToRemove.contains(anItem)
        }
        components.queryItems = queryItems
        request?.url = components.url
    }
    
    func removeAllQueryItems() {
        guard let url = request?.url else {
            fatalError("No request configured with URL")
        }
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: true), var queryItems = components.queryItems else { return }
        queryItems.removeAll()
        components.queryItems = queryItems
        request?.url = components.url
    }
    
    // MARK: Contents
    
    var contents: Any? {
        set {
            try? setRequestContents(newValue)
        }
        get {
            return try? getResponseContents()
        }
    }
    
    public func setRequestContents(_ contents: Any?) throws {
        guard var request = request else {
            fatalError("Transport has no configured request")
        }
        if let contents = contents, let contentWriter = contentWriter {
            request.httpBody = try contentWriter(contents)
        }
        else {
            request.httpBody = contents as? Data
        }
    }
    
    public func getResponseContents() throws -> Any? {
        guard hasResponse, let responseData = responseData else { return nil }
        if let contentReader = contentReader {
            return try contentReader(responseData)
        }
        return responseData
    }
    
    // MARK: CustomStringConvertible
    
    override public var description: String {
        return """
        \(super.description)
            Executing: \(String(describing: isExecuting))
            Request: \((request != nil) ? String(describing: request!) : "<nil>")
            Response: \((response != nil) ? String(describing: response!) : "<nil>")
            Current Task: \((currentTask != nil) ? String(describing: currentTask!) : "<nil>" )
        """
    }
}

// MARK:- URLSessionDelegate

extension Transport : URLSessionDelegate {
    public func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        responseError = error
        hasResponse = true
        currentTask = nil
        emit(self)
        completion(self, nil)
    }
}

// MARK:- URLSessionTaskDelegate

extension Transport : URLSessionTaskDelegate {
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        responseError = error
        response = task.response
        hasResponse = true
        currentTask = nil
        emit(self)
        completion(self, task)
    }
}

// MARK:- URLSessionDataDelegate

extension Transport : URLSessionDataDelegate {
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        guard let _ = responseData else {
            self.responseData = data
            return
        }
        self.responseData?.append(data)
    }
}

// MARK:- NSCopying

extension Transport : NSCopying {
    public func copy(with zone: NSZone? = nil) -> Any {
        let transport = Transport(session)
        transport.type = type
        transport.request = request
        transport.response = response
        transport.currentTask = currentTask
        transport.contents = contents
        transport.contentReader = contentReader
        transport.contentWriter = contentWriter
        transport.hasResponse = hasResponse
        transport.responseData = responseData
        transport.responseError = responseError
        return transport
    }
}

// MARK:- Beacon

class TransportSignal : Signal {
    var transport: Transport
    
    override class var signalName: String {
        return "🚛 \(super.signalName)"
    }
    
    init(_ aTransport: Transport) {
        transport = aTransport
        super.init()
    }
    
    override var description: String {
        return "\(super.description) \(transport.description)"
    }
}

extension Transport : Signaling {
    public var beaconSignal: Signal {
        return TransportSignal(self)
    }
}
