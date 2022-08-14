//
//  File.swift
//  
//
//  Created by Manabu Nakazawa on 14/8/2022.
//

import Foundation
import SwiftUI

extension ColorAsset {
    var swiftUIColor: SwiftUI.Color {
#if os(macOS)
        SwiftUI.Color(color.colorNameComponent)
#elseif os(iOS)
        SwiftUI.Color(color)
#endif
    }
}
