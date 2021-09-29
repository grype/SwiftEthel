//
//  Path.swift
//  
//
//  Created by Pavel Skaldin on 7/20/19.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

import Foundation

public struct Path : ExpressibleByStringInterpolation {
    
    public static let DefaultDelimiter = "/"
    
    /// Whether path is absolute as opposed to relative.
    /// An absolute path will have a root.
    private(set) var isAbsolute: Bool = true
    
    /// Path delimiter string. Defaults to `Path.DefaultDelimiter`.
    private(set) var delimiter: String = DefaultDelimiter
    
    /// Path segments starting with the root.
    private(set) var segments: [String]!
    
    // MARK: - Initializing
    
    public init(stringLiteral value: String) {
        self.init(value)
    }
    
    public init(_ string: String? = nil, isAbsolute absolute: Bool, delimiter aDelimeter: String = DefaultDelimiter) {
        isAbsolute = absolute
        delimiter = aDelimeter
        segments = string?.components(separatedBy: delimiter).filter { !$0.isEmpty } ?? [String]()
    }
    
    public init(_ string: String? = nil, delimiter aDelimeter: String = DefaultDelimiter) {
        self.init(string, isAbsolute: string == nil || string!.hasPrefix(aDelimeter), delimiter: aDelimeter)
    }
    
    private init(_ segments: [String], isAbsolute: Bool, delimiter: String) {
        self.isAbsolute = isAbsolute
        self.segments = segments
        self.delimiter = delimiter
    }
    
    // MARK: - Testing
    
    /// Whether the path is a root path and has no additional segments.
    public var isRoot: Bool {
        return isAbsolute && isEmpty
    }
    
    /// An empty path has no segments. An absolute path that's empty is a root path.
    public var isEmpty: Bool {
        return segments.count == 0
    }
    
    // MARK: - Resolving
    
    /// Resolves a path by appending string argument
    public func path(resolving str: String) -> Path {
        let relativePath = Path(str, delimiter: delimiter)
        return path(resolving: relativePath)
    }
    
    /// Resolves a path by appending another path
    public func path(resolving path: Path) -> Path {
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
    
    // MARK: - Converting
    
    /// Returns string representation of the path
    public var pathString: String {
        var result = segments.joined(separator: String(delimiter))
        if isAbsolute {
            result = delimiter + result
        }
        return result
    }
    
    /// Returns relative path
    public var relativePath: Path {
        return Path(segments, isAbsolute: false, delimiter: delimiter)
    }
}

// MARK: - Extensions (Path)

extension Path {
    public static func /(left: Path, right: String) -> Path {
        return left.path(resolving: right)
    }
    
    public static func /(left: Path, right: Path) -> Path {
        return left.path(resolving: right)
    }
    
    public static func /(left: Path.Type, right: String) -> Path {
        return Path(right, isAbsolute: true, delimiter: Path.DefaultDelimiter)
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

// MARK: - Extensions (Foundation)

extension String {
    /// Converts String to Path
    public var pathValue: Path { return Path(self) }
}

extension URL {
    /// Converts URL to Path
    public var pathValue: Path { return Path(path) }
    
    /// Strips path components from URL and returns a new URL that points to the root
    public var rootURL: URL? {
        return URL(string: "/", relativeTo: self)
    }
    
    public static func / (left: URL, right: String) -> URL? {
        let leftPath = left.path.count == 0 ? "/" : left.path
        let newPath = Path(leftPath).path(resolving: right)
        return left.rootURL?.appendingPathComponent(newPath.pathString)
    }
    
    public static func / (left: URL, right: Path) -> URL? {
        let leftPath = left.path.count == 0 ? "/" : left.path
        let newPath = Path(leftPath).path(resolving: right)
        return left.rootURL?.appendingPathComponent(newPath.pathString)
    }
    
    public mutating func removeAllPathComponents() {
        while pathComponents.count > 1 {
            deleteLastPathComponent()
        }
    }
    
    public mutating func resolve(_ aPath: Path) {
        if aPath.isAbsolute {
            removeAllPathComponents()
        }
        aPath.segments.forEach { (aSegment) in
            appendPathComponent(aSegment)
        }
    }
    
    public func resolving(_ aPath: Path) -> URL {
        var url = URL(string: absoluteString)!
        url.resolve(aPath)
        return url
    }
}
