//
//  ContentBuliders.swift
//  Ethel
//
//  Created by Pavel Skaldin on 10/4/21.
//  Copyright © 2021 Pavel Skaldin. All rights reserved.
//

import Foundation
import SwiftAnnouncements

public typealias ContentTransferProgressBlock = (Progress, Transport) -> Void

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
    public var url: URL
    public var progressBlock: ContentTransferProgressBlock?

    public init(to aUrl: URL, progress aProgressBlock: ContentTransferProgressBlock? = nil) {
        url = aUrl
        progressBlock = aProgressBlock
    }

    public func apply(to aTransport: Transport) {
        aTransport.requestType = .download(url)
        subscribe(to: aTransport)
    }

    func subscribe(to aTransport: Transport) {
        guard let progressBlock = progressBlock else {
            return
        }
        var subscription: Subscription<Transport.Announcement>!
        subscription = aTransport.announcer.when(Transport.Announcement.self, subscriber: nil) { announcement, _ in
            switch announcement {
            case Transport.Announcement.downloadProgressed:
                guard let progress = aTransport.downloadProgress else { return }
                progressBlock(progress, aTransport)
            case Transport.Announcement.taskEnded:
                aTransport.announcer.remove(subscription: subscription)
            default:
                break
            }
        }
    }
}

/**
 Configures transport for uploading content.

 Typically this is going to be a PUT or a POST.
 */
public struct Upload: TransportBuilding {
    var url: URL!
    var data: Data!
    public var progressBlock: ContentTransferProgressBlock?

    public init(fromURL aUrl: URL, progress aProgressBlock: ContentTransferProgressBlock? = nil) {
        url = aUrl
        progressBlock = aProgressBlock
    }

    public init(data aData: Data, progress aProgressBlock: ContentTransferProgressBlock? = nil) {
        data = aData
        progressBlock = aProgressBlock
    }

    public func apply(to aTransport: Transport) {
        if let url = url {
            aTransport.requestType = .uploadFile(url)
        }
        else if let data = data {
            aTransport.requestType = .uploadData(data)
        }
        subscribe(to: aTransport)
    }

    func subscribe(to aTransport: Transport) {
        guard let progressBlock = progressBlock else {
            return
        }
        var subscription: Subscription<Transport.Announcement>!
        subscription = aTransport.announcer.when(Transport.Announcement.self, subscriber: nil) { announcement, _ in
            switch announcement {
            case Transport.Announcement.downloadProgressed:
                guard let progress = aTransport.uploadProgress else { return }
                progressBlock(progress, aTransport)
            case Transport.Announcement.taskEnded:
                aTransport.announcer.remove(subscription: subscription)
            default:
                break
            }
        }
    }
}
