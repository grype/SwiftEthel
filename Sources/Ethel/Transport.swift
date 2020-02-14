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
    
    public enum RequestType {
        case data, download, upload
    }
    
    public typealias Completion = (Transport, URLSessionTask?)->Void
    
    // MARK: Properties
    
    public var session: URLSession
    
    public var request: URLRequest? {
        didSet { request?.transport = self }
    }
    
    public var response: URLResponse? {
        didSet { response?.transport = self }
    }
    
    public var type: RequestType = .data
    
    public var contentWriter: ((Any) throws -> Data?)?
    
    public var contentReader: ((Data) throws -> Any?)?
    
    public private(set) var hasResponse = false
    
    public private(set) var responseData: Data?
    
    public private(set) var responseError: Error?
    
    private var completion: Completion!
    
    public private(set) var currentTask: URLSessionTask?
    
    // MARK: Initialization
    
    public init(_ aSession: URLSession) {
        session = aSession
        super.init()
    }
    
    // MARK: Execution
    
    public func execute(completion aCompletionBlock: @escaping Completion) -> URLSessionTask {
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
    
    public var url: URL? {
        set {
            request?.url = newValue
        }
        get {
            return hasResponse ? response?.url : request?.url
        }
    }
    
    // MARK: Testing
    
    public var isExecuting: Bool {
        return currentTask != nil
    }
    
    // MARK: Query
    
    public func add(queryItem: URLQueryItem) {
        addAll(queryItems: [queryItem])
    }
    
    public func remove(queryItem: URLQueryItem) {
        removeAll(queryItems: [queryItem])
    }
    
    public func addAll(queryItems: [URLQueryItem]) {
        guard let url = request?.url else {
            fatalError("No request configured with URL")
        }
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else { return }
        components.queryItems = (components.queryItems ?? []) + queryItems
        request?.url = components.url
    }
    
    public func removeAll(queryItems itemsToRemove: [URLQueryItem]) {
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
    
    public func removeAllQueryItems() {
        guard let url = request?.url else {
            fatalError("No request configured with URL")
        }
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: true), var queryItems = components.queryItems else { return }
        queryItems.removeAll()
        components.queryItems = queryItems
        request?.url = components.url
    }
    
    // MARK: Contents
    
    open var contents: Any? {
        set {
            try? setRequestContents(newValue)
        }
        get {
            return try? getResponseContents()
        }
    }
    
    open func setRequestContents(_ contents: Any?) throws {
        if let contents = contents, let contentWriter = contentWriter {
            request?.httpBody = try contentWriter(contents)
        }
        else {
            request?.httpBody = contents as? Data
        }
    }
    
    open func getResponseContents() throws -> Any? {
        guard hasResponse, let responseData = responseData else { return nil }
        if let contentReader = contentReader {
            return try contentReader(responseData)
        }
        return responseData
    }
    
    // MARK: CustomStringConvertible
    
    override public var description: String {
        var requestDescription = "<nil>"
        if let request = request {
            let method = request.httpMethod ?? "<nil>"
            let type = request.allHTTPHeaderFields?["Content-Type"] ?? ""
            let length = request.httpBody?.count ?? 0
            let url = request.url?.absoluteString ?? "<nil>"
            requestDescription = "[\(method)] [\(type)] (\(length)) \(url)"
        }
        
        var responseDescription = "<nil>"
        if let response = response as? HTTPURLResponse {
            let length = response.expectedContentLength
            let type = response.mimeType ?? ""
            let url = response.url?.absoluteString ?? "<nil>"
            responseDescription = "[\(response.statusCode)] [\(type)] (\(length)) \(url)"
        }
        else if let response = response {
            responseDescription = String(describing: response)
        }
        return """
        \(super.description)
            Executing: \(String(describing: isExecuting))
            Request: \(requestDescription)
            Response: \(responseDescription)
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


extension URLRequest {
    private struct AssociatedKeys {
        static var transport = "Ethel.Transport"
    }
    
    public var transport: Transport? {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.transport) as? Transport }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.transport, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
}


extension URLResponse {
    private struct AssociatedKeys {
        static var transport = "Ethel.Transport"
    }
    
    public var transport: Transport? {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.transport) as? Transport }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.transport, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
}
