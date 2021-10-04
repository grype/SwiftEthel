//
//  File.swift
//
//
//  Created by Pavel Skaldin on 10/3/21.
//

@testable import Ethel
import Foundation
import PromiseKit

class GHGistEndpoint: GHEndpoint {
    override var path: Path? { "/gists/\(id)" }
    
    var id: String
    
    required init(on aClient: Client) {
        id = ""
        super.init(on: aClient)
    }
    
    func get() -> Promise<GHGist> {
        execute {
            Get()
            DecodeJSON<GHGist>()
        }
    }
    
    func delete() -> Promise<Void> {
        execute {
            Delete()
        }
    }
    
}
