//
//  String+Path.swift
//  Ethel
//
//  Created by Pavel Skaldin on 9/28/21.
//  Copyright © 2021 Pavel Skaldin. All rights reserved.
//

import Foundation

public extension String {
    /// Converts String to Path
    var pathValue: Path { Path(self) }
}
