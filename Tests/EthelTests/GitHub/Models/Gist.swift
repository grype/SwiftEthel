//
//  Gist.swift
//  Ethel
//
//  Created by Pavel Skaldin on 1/25/20.
//  Copyright © 2020 Pavel Skaldin. All rights reserved.
//

import Foundation

struct Gist: Codable, CustomStringConvertible {
    var id: String?
    var url: URL?
    var isPublic: Bool?
    var created: Date?
    var updated: Date?
    var gistDescription: String?
    var files: [String: GistFile]?

    enum CodingKeys: String, CodingKey {
        case id, url
        case isPublic = "public"
        case gistDescription = "description"
        case created = "created_at"
        case updated = "updated_at"
        case files
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try? container.decode(String.self, forKey: .id)
        url = try? container.decode(URL.self, forKey: .url)
        isPublic = try? container.decode(Bool.self, forKey: .isPublic)
        if let value = try? container.decodeIfPresent(String.self, forKey: .created) {
            created = ISO8601DateFormatter().date(from: value)
        }
        if let value = try? container.decodeIfPresent(String.self, forKey: .updated) {
            updated = ISO8601DateFormatter().date(from: value)
        }
        gistDescription = try? container.decode(String.self, forKey: .gistDescription)
        files = try? container.decode([String: GistFile].self, forKey: .files)
    }

    var description: String {
        return "GHGist <\(String(describing: id))>"
    }
}
