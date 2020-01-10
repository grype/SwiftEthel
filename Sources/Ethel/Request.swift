//
//  File.swift
//  
//
//  Created by Pavel Skaldin on 1/9/20.
//

import Foundation

public class Transport {
    
}

public class Request<T> {
    
    typealias Result = T
    
    // MARK:- Types
    
    enum RequestType {
        case data(ResponseDecoder), download, upload(Data, ResponseDecoder)
        
        func task(for request: URLRequest, on session: URLSession, completion: @escaping (Response<Result>)->Void) -> URLSessionTask {
            switch self {
            case .data(let decoder):
                return session.dataTask(with: request) { (data, response, error) in
                    let contents = data != nil ? decoder.decode(Result.self, from: data!) : nil
                    let response = Response<Result>(urlResponse: response, url: nil, contents: contents, error: error)
                    completion(response)
                }
            case .download:
                return session.downloadTask(with: request) { (url, response, error) in
                    completion(Response(urlResponse: response, url: url, contents: nil, error: error))
                }
            case .upload(let data, let decoder):
                let contents = data != nil ? decoder.decode(Result.self, from: data!) : nil
                return session.uploadTask(with: request, from: data) { (data, response, error) in
                    completion(Response(urlResponse: response, url: nil, contents: contents, error: error))
                }
            }
        }
    }
    
    // MARK:- Properties
    
    var urlSession: URLSession
    
    var urlRequest: URLRequest
    
    var type: RequestType
    
    // MARK:- Initialization
    
    init(_ aRequest: URLRequest, type aType: RequestType, session aSession: URLSession) {
        type = aType
        urlSession = aSession
        urlRequest = aRequest
    }
    
    convenience init(_ anUrl: URL, type aType: RequestType, session aSession: URLSession) {
        self.init(URLRequest(url: anUrl), type: aType, session: aSession)
    }
    
    // MARK:- Execution
    
    @discardableResult
    func execute(completion: @escaping (Response<Result>)->Void) -> URLSessionTask {
        let task = type.task(for: urlRequest, on: urlSession, completion: completion)
        task.resume()
        return task
    }
}
