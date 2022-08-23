//
//  GHGist.swift
//  Ethel
//
//  Created by Pavel Skaldin on 1/25/20.
//  Copyright © 2020 Pavel Skaldin. All rights reserved.
//

import Foundation

struct GHGist : Codable, CustomStringConvertible {
    var id: String?
    var url: URL?
    var isPublic: Bool?
    var created: Date?
    var updated: Date?
    var gistDescription: String?
    var files: [String : GHGistFile]?
    
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
        created = ISO8601DateFormatter().date(from: try container.decode(String.self, forKey: .created))
        updated = ISO8601DateFormatter().date(from: try container.decode(String.self, forKey: .updated))
        gistDescription = try? container.decode(String.self, forKey: .gistDescription)
        files = try? container.decode([String:GHGistFile].self, forKey: .files)
    }
    
    var description: String {
        return "GHGist <\(id!)>"
    }
}

struct GHGistFile : Codable {
    var filename: String?
    var gistType: String?
    var language: String?
    var url: URL?
    var gistSize: Int = 0
    
    enum CodingKeys : String, CodingKey {
        case filename, gistType = "type", language, url = "raw_url", gistSize = "size"
    }
}
