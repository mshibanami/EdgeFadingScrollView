//
//  ShadowedDivider.swift
//  RedirectWebForSafari
//
//  Created by Manabu Nakazawa on 6/4/21.
//  Copyright © 2021 Manabu Nakazawa. All rights reserved.
//

import Foundation
import SwiftUI

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
            .frame(height: 0.5)
            .foregroundColor(dividerColor)
            .opacity(0.6)
            .shadow(
                color: shadowColor,
                radius: 1,
                y: shadowPosition.swiftUIShadowY)
            .zIndex(1)
    }
}
