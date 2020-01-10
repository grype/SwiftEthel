//
//  File.swift
//  
//
//  Created by Pavel Skaldin on 1/9/20.
//

import Foundation

public class Request {
    
    // MARK:- Types
    
    enum RequestType {
        case data, download, upload(Data)
        
        func task(for request: URLRequest, on session: URLSession, completion: @escaping (Response)->Void) -> URLSessionTask {
            switch self {
            case .data:
                return session.dataTask(with: request) { (data, response, error) in
                    completion(Response(urlResponse: response, url: nil, data: data, error: error))
                }
            case .download:
                return session.downloadTask(with: request) { (url, response, error) in
                    completion(Response(urlResponse: response, url: url, data: nil, error: error))
                }
            case .upload(let data):
                return session.uploadTask(with: request, from: data) { (data, response, error) in
                    completion(Response(urlResponse: response, url: nil, data: data, error: error))
                }
            }
        }
    }
    
    // MARK:- Properties
    
    var urlSession: URLSession
    
    var urlRequest: URLRequest
    
    var type: RequestType = .data
    
    var method: String? {
        get {
            urlRequest.httpMethod
        }
        set {
            urlRequest.httpMethod = newValue
        }
    }
    
    // MARK:- Initialization
    
    init(_ aRequest: URLRequest, session aSession: URLSession) {
        urlSession = aSession
        urlRequest = aRequest
    }
    
    convenience init(_ anUrl: URL, session aSession: URLSession) {
        self.init(URLRequest(url: anUrl), session: aSession)
    }
    
    // MARK:- Execution
    
    @discardableResult
    func execute(completion: @escaping (Response)->Void) -> URLSessionTask {
        let task = type.task(for: urlRequest, on: urlSession, completion: completion)
        task.resume()
        return task
    }
}
