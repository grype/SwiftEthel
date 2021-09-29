//
//  File.swift
//
//
//  Created by Pavel Skaldin on 9/28/21.
//

import Foundation

public extension String {
    /// Converts String to Path
    var pathValue: Path { Path(self) }
}
