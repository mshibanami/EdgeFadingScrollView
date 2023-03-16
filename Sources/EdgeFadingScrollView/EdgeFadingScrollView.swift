//
//  EdgeFadingScrollView.swift
//  RedirectWebForSafari
//
//  Created by Manabu Nakazawa on 11/4/21.
//  Copyright © 2021 Manabu Nakazawa. All rights reserved.
//

import SwiftUI

public struct EdgeFadingScrollView<Content: View>: View {
    var axes: Axis.Set
    var showsIndicators: Bool
    var content: () -> Content
    var fadingEdgeColor: Color?
    var fadingEdgeShadowColor: Color?
    var fadingStartEdgeColor: Color? = nil
    var fadingEndEdgeColor: Color? = nil
    var fadingStartEdgeShadowColor: Color? = nil
    var fadingEndEdgeShadowColor: Color? = nil
    
    @State private var scrollViewContentSize = CGSize.zero {
        didSet { updateDividerIsHidden() }
    }
    @State private var scrollViewSize = CGSize.zero {
        didSet { updateDividerIsHidden() }
    }
    @State private var scrollViewOffset = CGRect.zero {
        didSet { updateDividerIsHidden() }
    }
    
    @State private var headerDividerIsHidden = true
    @State private var footerDividerIsHidden = true
    
    public init(
        _ axes: Axis.Set = .vertical,
        showsIndicators: Bool = true,
        fadingEdgeColor: Color? = nil,
        fadingEdgeShadowColor: Color? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.axes = axes
        self.showsIndicators = showsIndicators
        self.fadingEdgeColor = fadingEdgeColor
        self.fadingEdgeShadowColor = fadingEdgeShadowColor
        self.content = content
    }
    
    public var body: some View {
        return VStack(spacing: 0) {
            makeEdge(shadowPosition: .bottom)
                .opacity(headerDividerIsHidden ? 0 : 1)
            GeometryReader { scrollViewProxy in
                CustomScrollView(
                    axes,
                    showsIndicators: showsIndicators,
                    onOffsetChange: {
                        self.scrollViewOffset = $0
                    },
                    onContentSizeChange: {
                        self.scrollViewContentSize = $0
                    },
                    onSizeChange: {
                        self.scrollViewSize = $0
                    }) {
                        content()
                    }
            }
            makeEdge(shadowPosition: .top)
                .opacity(footerDividerIsHidden ? 0 : 1)
        }
    }

    func makeEdge(shadowPosition: ShadowPosition) -> some View {
        let defaultDividerColor = Asset.shadowedSeparatorFillColor.swiftUIColor
        let defaultShadowColor = Asset.separatorShadowColor.swiftUIColor
        let dividerColor: Color
        let shadowColor: Color
        switch shadowPosition {
        case .top:
            dividerColor = fadingEndEdgeColor ?? fadingEdgeColor ?? Asset.shadowedSeparatorFillColor.swiftUIColor
            shadowColor = fadingEndEdgeShadowColor ?? fadingEdgeShadowColor ?? Asset.separatorShadowColor.swiftUIColor
        case .bottom:
            dividerColor = fadingStartEdgeColor ?? fadingEdgeColor ?? defaultDividerColor
            shadowColor = fadingStartEdgeShadowColor ?? fadingEdgeShadowColor ?? defaultShadowColor
        }
        return ShadowedDivider(
            shadowPosition: shadowPosition,
            dividerColor: dividerColor,
            shadowColor: shadowColor)
    }
    
    private func updateDividerIsHidden() {
        withAnimation(.easeOut(duration: 0.3)) {
            updateHeaderDividerIsHidden()
            updateFooterDividerIsHidden()
        }
    }
    
    private func updateHeaderDividerIsHidden() {
        headerDividerIsHidden = scrollViewOffset.minY >= 0
    }

    private func updateFooterDividerIsHidden() {
        guard scrollViewSize.height > 0 else {
            footerDividerIsHidden = true
            return
        }
        let exceededContentViewHeight = scrollViewSize.height
        - scrollViewContentSize.height
        - scrollViewOffset.minY
        - 8
        footerDividerIsHidden = exceededContentViewHeight >= 0
    }
}

// MARK: - View modifying extensions
public extension EdgeFadingScrollView {
    func fadingEdgeColor(_ fadingEdgeColor: Color?) -> Self {
        var view = self
        view.fadingEdgeColor = fadingEdgeColor
        return view
    }

    func fadingEdgeShadowColor(_ fadingEdgeShadowColor: Color?) -> Self {
        var view = self
        view.fadingEdgeShadowColor = fadingEdgeShadowColor
        return view
    }

    func fadingStartEdgeColor(_ fadingStartEdgeColor: Color?) -> Self {
        var view = self
        view.fadingStartEdgeColor = fadingStartEdgeColor
        return view
    }

    func fadingEndEdgeColor(_ fadingEndEdgeColor: Color?) -> Self {
        var view = self
        view.fadingEndEdgeColor = fadingEndEdgeColor
        return view
    }

    func fadingStartEdgeShadowColor(_ fadingStartEdgeShadowColor: Color?) -> Self {
        var view = self
        view.fadingStartEdgeShadowColor = fadingStartEdgeShadowColor
        return view
    }

    func fadingEndEdgeShadowColor(_ fadingEndEdgeShadowColor: Color?) -> Self {
        var view = self
        view.fadingEndEdgeShadowColor = fadingEndEdgeShadowColor
        return view
    }
}
