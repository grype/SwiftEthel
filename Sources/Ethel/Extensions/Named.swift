//
//  Named.swift
//  Ethel
//
//  Created by Pavel Skaldin on 7/20/19.
//  Copyright © 2019 Pavel Skaldin. All rights reserved.
//

import Foundation

protocol Named {
    var typeName: String {get}
}

extension Named {
    var typeName: String {
        return String(describing: type(of: self))
    }
}
