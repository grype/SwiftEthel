//
//  EndpointTests.swift
//  Ethel
//
//  Created by Pavel Skaldin on 12/22/21.
//  Copyright © 2021 Pavel Skaldin. All rights reserved.
//

import Cuckoo
@testable import Ethel
import Foundation
import Nimble
import PromiseKit
import XCTest

class TestEndpoint: Endpoint {
    var client: Client
    
    var path: Path? { "/" }
    
    required init(on aClient: Client) {
        client = aClient
    }
    
    var configured: Bool = false
    
    func configureDerivedEndpoint(_ anEndpoint: Endpoint) {
        if let testEndpoint = anEndpoint as? TestEndpoint {
            testEndpoint.configured = true
        }
    }
}

class EndpointA: TestEndpoint {
    override var path: Path? { "/a" }
}

class EndpointB: TestEndpoint {
    override var path: Path? { "/b" }
}

class EndpointTests: ClientTestCase {
    func testConfiguresDerivedEndpoint() {
        let source = client / EndpointA.self
        let destination = source / EndpointB.self
        expect(source.configured).to(beFalse())
        expect(destination.configured).to(beTrue())
    }
}
