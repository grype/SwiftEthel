//
//  Path.swift
//  
//
//  Created by Pavel Skaldin on 7/20/19.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

import Foundation

public struct Path {
    static let DefaultDelimiter = "/"
    
    private(set) var isAbsolute: Bool!
    private(set) var delimiter: String!
    private(set) var segments: [String]!
    
    // MARK:- Initializing
    
    init(_ string: String? = nil, delimiter: String = DefaultDelimiter) {
        isAbsolute = string == nil || string!.hasPrefix(delimiter)
        let newSegments = string?.components(separatedBy: delimiter) ?? [String]()
        segments = newSegments.filter { !$0.isEmpty }
        self.delimiter = delimiter
    }
    
    private init(_ segments: [String], isAbsolute: Bool, delimiter: String) {
        self.isAbsolute = isAbsolute
        self.segments = segments
        self.delimiter = delimiter
    }
    
    // MARK:- Testing
    
    var isRoot: Bool {
        return isAbsolute && isEmpty
    }
    
    var isEmpty: Bool {
        return segments.count == 0
    }
    
    // MARK:- Resolving
    
    func path(resolving str: String) -> Path {
        let relativePath = Path(str, delimiter: delimiter)
        return path(resolving: relativePath)
    }
    
    func path(resolving path: Path) -> Path {
        if path.isAbsolute {
            return Path(path.segments, isAbsolute: path.isAbsolute, delimiter: delimiter)
        }
        else {
            var newSegments = [String]()
            newSegments.append(contentsOf: segments)
            newSegments.append(contentsOf: path.segments)
            return Path(newSegments, isAbsolute: isAbsolute, delimiter: delimiter)
        }
    }
    
    // MARK:- Converting
    
    var pathString: String {
        var result = segments.joined(separator: String(delimiter))
        if isAbsolute {
            result = delimiter + result
        }
        return result
    }
    
    var relativePath: Path {
        return Path(segments, isAbsolute: false, delimiter: delimiter)
    }
}

// MARK:- Extensions (Path)

extension Path {
    static func /(left: Path, right: String) -> Path {
        return left.path(resolving: right)
    }
    
    static func /(left: Path, right: Path) -> Path {
        return left.path(resolving: right)
    }
}

extension Path: CustomStringConvertible {
    public var description: String {
        return String(format: "Path %@%@", isAbsolute ? delimiter :"", segments.joined(separator: delimiter))
    }
}

extension Path: Equatable {
    public static func == (lhs: Path, rhs: Path) -> Bool {
        return lhs.isAbsolute == rhs.isAbsolute && lhs.segments == rhs.segments
    }
}

// MARK:- Extensions (Foundation)

extension String {
    var pathValue: Path { return Path(self) }
}

extension URL {
    var pathValue: Path { return Path(path) }
    
    var rootURL: URL? {
        return URL(string: "/", relativeTo: self)
    }
    
    static func / (left: URL, right: String) -> URL? {
        let leftPath = left.path.count == 0 ? "/" : left.path
        let newPath = Path(leftPath).path(resolving: right)
        return left.rootURL?.appendingPathComponent(newPath.pathString)
    }
    
    static func / (left: URL, right: Path) -> URL? {
        let leftPath = left.path.count == 0 ? "/" : left.path
        let newPath = Path(leftPath).path(resolving: right)
        return left.rootURL?.appendingPathComponent(newPath.pathString)
    }
}
