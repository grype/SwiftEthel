//
//  ResponseError.swift
//  
//
//  Created by Pavel Skaldin on 12/27/21.
//

import Foundation

enum ResponseError : LocalizedError {
    case unexpectedResponseType(expected: Any.Type, actual: Any.Type)
    case httpError(code: Int)
    
    var errorDescription: String? {
        switch self {
        case let .unexpectedResponseType(expected, actual):
            return "Unexpected response type - expected \(expected), but got \(actual))"
        case let .httpError(code: code):
            var description = "HTTP \(code)"
            if let status = HTTPStatusCodes[code] {
                description.append(contentsOf: ": \(status)")
            }
            return description
        }
    }

    /// A localized message describing the reason for the failure.
    var failureReason: String? {
        switch self {
        case let .unexpectedResponseType(expected: expected, actual: actual):
            return "Client expected response data to be decodable as \(expected), but found \(actual) instead."
        default:
            return nil
        }
    }

    /// A localized message describing how one might recover from the failure.
    var recoverySuggestion: String? {
        switch self {
        case .unexpectedResponseType:
            return "You may want to make the expected type optional, if the response returned no content. Otherwise, ensure correct response type is expected and that the received data can be decoded as the specified type."
        default:
            return nil
        }
    }
}


private var HTTPStatusCodes: [Int: String] = [
    100: "Continue",
    101: "Switching Protocols",
    102: "Processing",
    103: "Early Hints",
    200: "OK",
    201: "Created",
    202: "Accepted",
    203: "Non-Authoritative Information",
    204: "No Content",
    205: "Reset Content",
    206: "Partial Content",
    207: "Multi-Status",
    208: "Already Reported",
    226: "IM Used",
    300: "Multiple Choices",
    301: "Moved Permanently",
    302: "Found",
    303: "See Other",
    304: "Not Modified",
    305: "Use Proxy",
    306: "Switch Proxy",
    307: "Temporary Redirect",
    308: "Permanent Redirect",
    400: "Bad Request",
    401: "Unauthorized",
    402: "Payment Required",
    403: "Forbidden",
    404: "Not Found",
    405: "Method Not Allowed",
    406: "Not Acceptable",
    407: "Proxy Authentication Required",
    408: "Request Timeout",
    409: "Conflict",
    410: "Gone",
    411: "Length Required",
    412: "Precondition Failed",
    413: "Payload Too Large",
    414: "URI Too Long",
    415: "Unsupported Media Type",
    416: "Range Not Satisfiable",
    417: "Expectation Failed",
    418: "I'm a teapot",
    420: "Method Failure",
    421: "Misdirected Request",
    422: "Unprocessable Entity",
    423: "Locked",
    424: "Failed Dependency",
    425: "Too Early",
    426: "Upgrade Required",
    428: "Precondition Required",
    429: "Too Many Requests",
    431: "Request Header Fields Too Large",
    440: "Login Time-out",
    444: "No Response",
    449: "Retry With",
    450: "Blocked by Windows Parental Controls",
    451: "Unavailable For Legal Reasons",
    494: "Request header too large",
    495: "SSL Certificate Error",
    496: "SSL Certificate Required",
    497: "HTTP Request Sent to HTTPS Port",
    498: "Invalid Token",
    499: "Client Closed Request",
    500: "Internal Server Error",
    501: "Not Implemented",
    502: "Bad Gateway",
    503: "Service Unavailable",
    504: "Gateway Timeout",
    505: "HTTP Version Not Supported",
    506: "Variant Also Negotiates",
    507: "Insufficient Storage",
    508: "Loop Detected",
    509: "Bandwidth Limit Exceeded",
    510: "Not Extended",
    511: "Network Authentication Required",
    520: "Web Server Returned an Unknown Error",
    521: "Web Server Is Down",
    522: "Connection Timed Out",
    523: "Origin Is Unreachable",
    524: "A Timeout Occurred",
    525: "SSL Handshake Failed",
    526: "Invalid SSL Certificate",
    527: "Railgun Error",
    529: "Site is overloaded",
    530: "Site is frozen",
    598: "Network read timeout error"
]
