//
//  GHPageCursor.swift
//  Ethel
//
//  Created by Pavel Skaldin on 2/10/20.
//  Copyright © 2020 Pavel Skaldin. All rights reserved.
//

@testable import Ethel
import Foundation

class GHPageCursor: Cursor {
    var hasMore: Bool = true
    var page: Int = 1
    var pageSize: Int = 5
}

extension GHPageCursor: CustomStringConvertible {
    var description: String {
        return "<GHPageCursor: \(Unmanaged.passUnretained(self).toOpaque())> page: \(page); pageSize: \(pageSize)"
    }
}
