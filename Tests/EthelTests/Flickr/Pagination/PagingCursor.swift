//
//  PagingCursor.swift
//  
//
//  Created by Pavel Skaldin on 10/25/22.
//  Copyright © 2022 Pavel Skaldin. All rights reserved.
//

import Foundation
import Ethel

class PagingCursor: Cursor {
    var page: Int = 1
    var pageSize: Int = 100
    var hasMore: Bool = true

    func configure<E: PagingEndpoint>(on anEndpoint: E) {
        anEndpoint.page = page
        anEndpoint.pageSize = pageSize
    }

    func advance() {
        page += 1
    }
}
