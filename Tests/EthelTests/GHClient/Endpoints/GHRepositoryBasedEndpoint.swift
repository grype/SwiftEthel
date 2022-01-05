//
//  File.swift
//
//
//  Created by Pavel Skaldin on 1/5/22.
//

import Ethel
import Foundation

protocol GHRepositoryBasedEndpoint {
    var owner: String? { get set }
    var repository: String? { get set }
}
