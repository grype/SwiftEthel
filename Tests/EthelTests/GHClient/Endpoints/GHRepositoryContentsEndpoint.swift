//
//  GHRepositoryContentsEndpoint.swift
//  Ethel
//
//  Created by Pavel Skaldin on 1/4/22.
//  Copyright © 2022 Pavel Skaldin. All rights reserved.
//

import Ethel
import Foundation

class GHRepositoryContentsEndpoint: GHEndpoint, GHRepositoryBasedEndpoint {
    var owner: String?
    var repository: String?
    override var path: Path? { "/repos/\(owner!)/\(repository!)/contents" }
    
    func get(at aPath: Path) -> Promise<OneOrMany<GHFileDescription>> {
        execute {
            Get(aPath)
            DecodeJSON<OneOrMany<GHFileDescription>>()
        }
    }
    
    subscript(path: Path) -> OneOrMany<GHFileDescription>? {
        try? self.get(at: path).wait()
    }
}

extension GHRepositoryEndpoint {
    var contents: GHRepositoryContentsEndpoint { self / GHRepositoryContentsEndpoint.self }
}
