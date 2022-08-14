//
//  ShadowPosition.swift
//  RedirectWebForSafari
//
//  Created by Manabu Nakazawa on 6/4/21.
//  Copyright © 2021 Manabu Nakazawa. All rights reserved.
//

#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif

enum ShadowPosition {
    case top, bottom
    
    var shadowOffset: CGSize {
        switch self {
        case .top:
            return CGSize(width: 0, height: 1.5)
        case .bottom:
            return CGSize(width: 0, height: -1.5)
        }
    }
    
    var swiftUIShadowY: CGFloat {
        switch self {
        case .top:
            return -1
        case .bottom:
            return 1
        }
    }
}
