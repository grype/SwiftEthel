//
//  GHGistEndpoint.swift
//  Ethel
//
//  Created by Pavel Skaldin on 10/3/21.
//  Copyright © 2021 Pavel Skaldin. All rights reserved.
//

@testable import Ethel
import Foundation

class GHGistEndpoint: GHEndpoint {
    override var path: Path? { "/gists/\(id)" }
    
    var id: String = ""
    
    func get() -> Promise<GHGist> {
        execute {
            Get()
            DecodeJSON<GHGist>()
        }
    }
    
    func delete() -> Promise<Any?> {
        execute {
            Delete()
        }
    }
    
}
