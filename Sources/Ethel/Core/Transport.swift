//
//  File.swift
//
//
//  Created by Pavel Skaldin on 1/9/20.
//

import Beacon
import Foundation

open class Transport: NSObject {
    // MARK: - Types
    
    public enum RequestType {
        case data, download, upload
    }
    
    public typealias Completion = (Transport, URLSessionTask?) -> Void
    
    // MARK: - Properties
    
    public var type: RequestType = .data
    
    public var session: URLSession
    
    public var request: URLRequest? {
        didSet { request?.transport = self }
    }
    
    public var response: URLResponse? {
        didSet { response?.transport = self }
    }
    
    public var contentWriter: ((Any) throws -> Data?)?
    
    public var contentReader: ((Data) throws -> Any?)?
    
    public fileprivate(set) var isComplete = false
    
    public fileprivate(set) var responseData: Data?
    
    public fileprivate(set) var responseError: Error?
    
    private var completion: Completion!
    
    public fileprivate(set) var task: URLSessionTask?
    
    // MARK: - Initializating
    
    public init(_ aSession: URLSession) {
        session = aSession
        super.init()
    }
    
    // MARK: - Executing
    
    public func execute(completion aCompletionBlock: @escaping Completion) -> URLSessionTask {
        assert(request != nil, "Transport has no configured request")
        let task = session.dataTask(with: request!)
        completion = aCompletionBlock
        task.resume()
        self.task = task
        emit(self, on: Beacon.ethel)
        return task
    }
    
    // MARK: - Contents
    
    open var requestContents: Any? {
        get { request?.httpBody }
        set { try? setRequestContents(newValue) }
    }
    
    open func setRequestContents(_ contents: Any?) throws {
        if let contents = contents, let contentWriter = contentWriter {
            request?.httpBody = try contentWriter(contents)
        }
        else {
            request?.httpBody = contents as? Data
        }
    }
    
    open var responseContents: Any? { try? getResponseContents() }
    
    open func getResponseContents() throws -> Any? {
        guard isComplete, let responseData = responseData else { return nil }
        if let contentReader = contentReader {
            return try contentReader(responseData)
        }
        return responseData
    }
    
    // MARK: - CustomStringConvertible
    
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
            Request: \(requestDescription)
            Response: \(responseDescription)
            Task: (\(task?.state.rawValue.description ?? "?") \(task?.description ?? "<nil>")
        """
    }
}

// MARK: - URLSessionDelegate

extension Transport: URLSessionDelegate {
    public func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        responseError = error
        isComplete = true
        task = nil
        emit(error: error, on: Beacon.ethel)
        completion(self, nil)
    }
}

// MARK: - URLSessionTaskDelegate

extension Transport: URLSessionTaskDelegate {
    public func urlSession(_ session: URLSession, task aTask: URLSessionTask, didCompleteWithError error: Error?) {
        responseError = error
        response = aTask.response
        isComplete = true
        task = nil
        if let error = error {
            emit(error: error, on: Beacon.ethel)
        }
        else {
            emit(self, on: Beacon.ethel)
        }
        completion(self, task)
    }
}

// MARK: - URLSessionDataDelegate

extension Transport: URLSessionDataDelegate {
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        guard let _ = responseData else {
            responseData = data
            return
        }
        responseData?.append(data)
    }
}

// MARK: - NSCopying

extension Transport: NSCopying {
    public func copy(with zone: NSZone? = nil) -> Any {
        let transport = Transport(session)
        transport.type = type
        transport.request = request
        transport.response = response
        transport.task = task
        transport.contentReader = contentReader
        transport.contentWriter = contentWriter
        transport.isComplete = isComplete
        transport.responseData = responseData
        transport.responseError = responseError
        return transport
    }
}

// MARK: - URLRequest

extension URLRequest {
    private enum AssociatedKeys {
        static var transport = "Ethel.Transport"
    }
    
    public var transport: Transport? {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.transport) as? Transport }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.transport, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
}

// MARK: - URLResponse

extension URLResponse {
    private enum AssociatedKeys {
        static var transport = "Ethel.Transport"
    }
    
    public var transport: Transport? {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.transport) as? Transport }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.transport, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
}
