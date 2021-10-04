//
//  File.swift
//
//
//  Created by Pavel Skaldin on 10/1/21.
//

import Foundation

extension DispatchQueue {
    /// Sets queue-specific key with given value only for the duration of given block.
    /// When the block exits, the old value will be set
    func setSpecific<T>(key: DispatchSpecificKey<T>, value: T?, during aBlock: () -> Void) {
        let oldValue = getSpecific(key: key)
        setSpecific(key: key, value: value)
        aBlock()
        setSpecific(key: key, value: oldValue)
    }
}
