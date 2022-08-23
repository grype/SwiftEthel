//
//  GHRepositoryBasedEndpoint.swift
//  Ethel
//
//  Created by Pavel Skaldin on 1/5/22.
//  Copyright © 2022 Pavel Skaldin. All rights reserved.
//

import Ethel
import Foundation

protocol GHRepositoryBasedEndpoint {
    var owner: String? { get set }
    var repository: String? { get set }
}
