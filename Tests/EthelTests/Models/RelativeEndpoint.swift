//
//  File.swift
//  
//
//  Created by Pavel Skaldin on 2/11/20.
//

import Foundation
@testable import Ethel

class RelativeEndpoint: Endpoint {
    override var path: Path {
        return Path("relative")
    }
}
