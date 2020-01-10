//
//  File.swift
//  
//
//  Created by Pavel Skaldin on 1/9/20.
//

import Foundation

public class Transport {
    
    // MARK:- Types
    
    enum RequestType {
        case data, download, upload
    }
    
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
    
    // MARK:- Initialization
    
    init(_ aSession: URLSession) {
        session = aSession
    }
    
    // MARK:- Execution
    
    @discardableResult
    func execute(completion: @escaping (Transport)->Void) -> URLSessionTask {
        guard let request = request else {
            fatalError("Transport has no configured request")
        }
        
        var task: URLSessionTask!
        
        task = session.dataTask(with: request) { (data, response, error) in
            self.response = response
            self.responseData = data
            self.responseError = error
            self.hasResponse = true
        }
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
