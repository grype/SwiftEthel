//
//  Size.swift
//  
//
//  Created by Pavel Skaldin on 10/25/22.
//  Copyright © 2022 Pavel Skaldin. All rights reserved.
//

import Foundation

struct Size: Decodable {
    var width: Int?
    var height: Int?
    var label: String?
    var rawUrl: String?
    var url: URL? {
        guard let rawUrl = rawUrl else { return nil }
        return URL(string: rawUrl)
    }

    var rawSource: String?
    var source: URL? {
        guard let rawSource = rawSource else { return nil }
        return URL(string: rawSource)
    }

    var area: Int { (width ?? 0) * (height ?? 0) }

    enum CodingKeys: String, CodingKey {
        case width, height, label, rawUrl = "url", rawSource = "source"
    }
}
