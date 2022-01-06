//
//  File.swift
//
//
//  Created by Pavel Skaldin on 10/4/21.
//

import Foundation

/**
 Configures transport with block-based content reader
 */
public struct Read<T>: TransportBuilding {
    private(set) var block: ((Data) throws -> T?)?
    public init(_ aBlock: @escaping (Data) throws -> T?) {
        block = aBlock
    }

    public func apply(to aTransport: Transport) {
        aTransport.contentReader = block
    }
}


/**
 Configures transport with block-based content writer
 */
public struct Write: TransportBuilding {
    private(set) var block: (Any) throws -> Data?
    public init(_ aBlock: @escaping (Any) throws -> Data?) {
        block = aBlock
    }

    public func apply(to aTransport: Transport) {
        aTransport.contentWriter = block
    }
}

/**
 Configures transport for downloading response to a local file given by a URL.
 
 Typically this requires a GET HTTP method.
 */
public struct Download: TransportBuilding {
    var url: URL
    public init(to aUrl: URL) {
        url = aUrl
    }
    public func apply(to aTransport: Transport) {
        aTransport.requestType = .download(url)
    }
}

/**
 Configures transport for uploading content.
 
 Typically this is going to be a PUT or a POST.
 */
public struct Upload: TransportBuilding {
    var url: URL!
    var data: Data!
    public init(fromURL aUrl: URL) {
        url = aUrl
    }
    public init(data aData: Data) {
        data = aData
    }
    public func apply(to aTransport: Transport) {
        if let url = url {
            aTransport.requestType = .uploadFile(url)
        }
        else if let data = data {
            aTransport.requestType = .uploadData(data)
        }
    }
}
