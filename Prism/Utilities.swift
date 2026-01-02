//
//  Utilities.swift
//  Prism
//
//  Created by A. Zheng (github.com/aheze) on 9/26/22.
//  Copyright © 2022 A. Zheng. All rights reserved.
//

import SwiftUI


public extension Color {
    #if os(iOS)
    init(_ color: UIColor) {
        self.init(uiColor: color)
    }
    #elseif os(macOS)
    init(_ color: NSColor) {
        self.init(nsColor: color)
    }
    #endif
}

