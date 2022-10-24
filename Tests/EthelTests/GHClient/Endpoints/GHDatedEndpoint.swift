//
//  GHDatedEndpoint.swift
//
//
//  Created by Pavel Skaldin on 10/22/22.
//  Copyright © 2022 Pavel Skaldin. All rights reserved.
//

import Foundation

protocol GHDatedEndpoint: AnyObject {
    var since: Date? { get set }
    func since(_ date: Date) -> Self
}

extension GHDatedEndpoint {
    func since(_ date: Date) -> Self {
        since = date
        return self
    }
}
