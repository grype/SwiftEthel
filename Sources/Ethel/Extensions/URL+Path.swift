//
//  URL+Path.swift
//  Ethel
//
//  Created by Pavel Skaldin on 9/28/21.
//  Copyright © 2021 Pavel Skaldin. All rights reserved.
//

import Foundation

public extension URL {
    /// Converts URL to Path
    var pathValue: Path { Path(path) }
    
    /// Strips path components from URL and returns a new URL that points to the root
    var rootURL: URL? { resolving("/") }
    
    static func / (left: URL, right: String) -> URL? {
        let leftPath = left.path.isEmpty ? "/" : left.path
        let newPath = Path(leftPath).path(resolving: right)
        return left.rootURL?.appendingPathComponent(String(newPath.pathString.dropFirst()))
    }
    
    static func / (left: URL, right: Path) -> URL? {
        let leftPath = left.path.isEmpty ? "/" : left.path
        let newPath = Path(leftPath).path(resolving: right)
        return left.rootURL?.appendingPathComponent(String(newPath.pathString.dropFirst()))
    }
    
    mutating func removeAllPathComponents() {
        while pathComponents.count > 1 {
            deleteLastPathComponent()
        }
    }
    
    mutating func resolve(_ aPath: Path) {
        if aPath.isAbsolute {
            removeAllPathComponents()
        }
        aPath.segments.forEach { aSegment in
            appendPathComponent(aSegment)
        }
    }
    
    func resolving(_ aPath: Path) -> URL {
        var url = URL(string: absoluteString)!
        url.resolve(aPath)
        return url
    }
}
