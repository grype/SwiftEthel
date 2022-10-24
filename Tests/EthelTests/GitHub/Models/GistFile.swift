//
//  GistFile.swift
//  
//
//  Created by Pavel Skaldin on 10/23/22.
//  Copyright © 2022 Pavel Skaldin. All rights reserved.
//

import Foundation

struct GistFile : Codable {
    var filename: String?
    var gistType: String?
    var language: String?
    var url: URL?
    var gistSize: Int = 0
    
    enum CodingKeys : String, CodingKey {
        case filename, gistType = "type", language, url = "raw_url", gistSize = "size"
    }
}
