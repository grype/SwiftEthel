//
//  FileDescription.swift
//  Ethel
//
//  Created by Pavel Skaldin on 1/4/22.
//  Copyright © 2022 Pavel Skaldin. All rights reserved.
//

import Foundation

struct FileDescription: Codable {
    enum CodingKeys: String, CodingKey {
        case type, encoding, size, name, path, content, sha, url, gitUrl = "git_url", htmlUrl = "html_url", downloadUrl = "download_url"
    }

    var type: String?
    var encoding: String?
    var size: Int?
    var name: String?
    var path: String?
    var content: String?
    var sha: String?
    var url: String?
    var gitUrl: String?
    var htmlUrl: String?
    var downloadUrl: String?
}
