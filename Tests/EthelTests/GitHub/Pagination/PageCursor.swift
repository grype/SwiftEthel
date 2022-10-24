//
//  GHPageCursor.swift
//  Ethel
//
//  Created by Pavel Skaldin on 2/10/20.
//  Copyright © 2020 Pavel Skaldin. All rights reserved.
//

@testable import Ethel
import Foundation

class PageCursor: Cursor {
    var hasMore: Bool = true
    var page: Int = 1
    var pageSize: Int = 5
}

extension PageCursor: CustomStringConvertible {
    var description: String {
        return "<PageCursor: \(Unmanaged.passUnretained(self).toOpaque())> page: \(page); pageSize: \(pageSize)"
    }
}
