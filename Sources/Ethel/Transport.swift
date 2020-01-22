//
//  File.swift
//  
//
//  Created by Pavel Skaldin on 1/9/20.
//

import Foundation

public class Transport : NSObject {
    
    // MARK:- Types
    
    enum RequestType {
        case data, download, upload
    }
    
    typealias Completion = (Transport, URLSessionTask?)->Void
    
    // MARK:- Properties
    
    var session: URLSession
    
    var request: URLRequest?
    
    var response: URLResponse?
    
    var type: RequestType = .data
    
    var contentWriter: ((Any)->Data?)?
    
    var contentReader: ((Data)->Any?)?
    
    private(set) var hasResponse = false
    
    private(set) var responseData: Data?
    
    private(set) var responseError: Error?
    
    private var completion: Completion!
    
    // MARK:- Initialization
    
    init(_ aSession: URLSession) {
        session = aSession
        super.init()
    }
    
    // MARK:- Execution
    
    func execute(completion aCompletionBlock: @escaping Completion) -> URLSessionTask {
        guard let request = request else {
            fatalError("Transport has no configured request")
        }
        
        var task: URLSessionTask!
        
        task = session.dataTask(with: request)
        completion = aCompletionBlock
        task.resume()
        return task
    }
    
    // MARK:- URL
    
    var url: URL? {
        set {
            request?.url = newValue
        }
        get {
            return hasResponse ? response?.url : request?.url
        }
    }
    
    // MARK:- Query
    
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
    
    // MARK:- Contents
    
    var contents: Any? {
        set {
            guard var request = request else {
                fatalError("Transport has no configured request")
            }
            if let newValue = newValue, let contentWriter = contentWriter {
                request.httpBody = contentWriter(newValue)
            }
            else {
                request.httpBody = newValue as? Data
            }
        }
        get {
            guard hasResponse, let responseData = responseData else { return nil }
            if let contentReader = contentReader {
                return contentReader(responseData)
            }
            return responseData
        }
    }
}

extension Transport : URLSessionDelegate {
    public func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        responseError = error
        hasResponse = true
        completion(self, nil)
    }
}

extension Transport : URLSessionTaskDelegate {
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        responseError = error
        response = task.response
        hasResponse = true
        completion(self, task)
    }
}

extension Transport : URLSessionDataDelegate {
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        guard let _ = responseData else {
            self.responseData = data
            return
        }
        self.responseData?.append(data)
    }
}
