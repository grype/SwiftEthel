//
//  File.swift
//  
//
//  Created by Pavel Skaldin on 1/25/20.
//

import Foundation
import PromiseKit
@testable import Ethel

class GHEndpoint : Endpoint {
    
    var dateFormatter: ISO8601DateFormatter {
        return (client as! GHClient).dateFormatter
    }

}
