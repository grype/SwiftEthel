//
//  File.swift
//
//
//  Created by Pavel Skaldin on 2/11/20.
//

@testable import Ethel
import Foundation

class RelativeEndpoint: Endpoint {
    override var path: Path {
        return Path("relative")
    }
}
