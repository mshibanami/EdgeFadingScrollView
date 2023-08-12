//
//  ShadowedDivider.swift
//  RedirectWebForSafari
//
//  Created by Manabu Nakazawa on 6/4/21.
//  Copyright © 2021 Manabu Nakazawa. All rights reserved.
//

import Foundation
import SwiftUI

#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

var screenScale: CGFloat {
#if os(iOS)
    return UIScreen.main.scale
#elseif os(macOS)
    return NSScreen.main?.backingScaleFactor ?? 1.0
#endif
}
struct ShadowedDivider: View {
    let shadowPosition: ShadowPosition
    let dividerColor: Color
    let shadowColor: Color

    init(shadowPosition: ShadowPosition, dividerColor: Color, shadowColor: Color) {
        self.shadowPosition = shadowPosition
        self.dividerColor = dividerColor
        self.shadowColor = shadowColor
    }

    var body: some View {
        Rectangle()
            .frame(height: 1 / screenScale)
            .foregroundColor(dividerColor)
            .opacity(0.6)
            .shadow(
                color: shadowColor,
                radius: 1,
                y: shadowPosition.swiftUIShadowY)
            .zIndex(1)
    }
}
