//
//  File.swift
//
//
//  Created by Pavel Skaldin on 1/25/20.
//

@testable import Ethel
import Foundation
import PromiseKit

// MARK: - Configuration

struct GHClientConfiguration {
    var url: URL
    var authToken: String?
    
    static var `default` = GHClientConfiguration(url: URL(string: "https://api.github.com/")!, authToken: nil)
}

// MARK: - Client

class GHClient: Client {
    override var baseUrl: URL? { configuration.url }
    
    static var `default` = GHClient(configuration: GHClientConfiguration.default)
    
    var configuration: GHClientConfiguration
    
    var dateFormatter = ISO8601DateFormatter()
    
    init(configuration aConfig: GHClientConfiguration) {
        configuration = aConfig
        super.init(aConfig.url, sessionConfiguration: URLSessionConfiguration.background(withIdentifier: "GHClient"))
    }
    
    // MARK: Endpoints
    
    var gists: GHGistsEndpoint {
        return self / GHGistsEndpoint.self
    }
}
