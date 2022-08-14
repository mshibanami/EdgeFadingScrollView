//
//  CustomScrollView.swift
//  RedirectWebForSafari
//
//  Created by Manabu Nakazawa on 6/4/21.
//  Copyright © 2021 Manabu Nakazawa. All rights reserved.
//

import SwiftUI

private let frameLayerCoordinateSpaceName = "frameLayer"

/// https://fivestars.blog/swiftui/scrollview-offset.html
struct CustomScrollView<Content: View>: View {
    let axes: Axis.Set
    let showsIndicators: Bool
    let onOffsetChange: ((CGRect) -> Void)?
    let onContentSizeChange: ((CGSize) -> Void)?
    let onSizeChange: ((CGSize) -> Void)?
    let content: () -> Content
    
    init(
        _ axes: Axis.Set = .vertical,
        showsIndicators: Bool = true,
        onOffsetChange: ((CGRect) -> Void)? = nil,
        onContentSizeChange: ((CGSize) -> Void)? = nil,
        onSizeChange: ((CGSize) -> Void)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.axes = axes
        self.showsIndicators = showsIndicators
        self.onOffsetChange = onOffsetChange
        self.onContentSizeChange = onContentSizeChange
        self.onSizeChange = onSizeChange
        self.content = content
    }
    
    var body: some View {
        GeometryReader { scrollViewProxy in
            ScrollView(axes, showsIndicators: showsIndicators) {
                offsetReader
                AnyView(content()) // なにかのViewで囲わないとContentSize計算がおかしくなる。
                    .padding(.top, -8)
                    .background(
                        GeometryReader { contentViewProxy in
                            Color.clear
                                .preference(key: ContentSizePreferenceKey.self, value: contentViewProxy.size)
                                .onPreferenceChange(ContentSizePreferenceKey.self, perform: onContentSizeChange ?? { _ in })
                        }
                    )
            }
            .coordinateSpace(name: frameLayerCoordinateSpaceName)
            .onPreferenceChange(RectPreferenceKey.self, perform: onOffsetChange ?? { _ in })
            .preference(key: SizePreferenceKey.self, value: scrollViewProxy.size)
            .onPreferenceChange(SizePreferenceKey.self, perform: onSizeChange ?? { _ in })
        }
    }
    
    var offsetReader: some View {
        GeometryReader { proxy in
            Color.clear.preference(
                key: RectPreferenceKey.self,
                value: proxy.frame(in: .named(frameLayerCoordinateSpaceName)))
        }
        .frame(height: 0)
        // this makes sure that the reader doesn't affect the content height
    }
}

private struct RectPreferenceKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {}
}

private struct ContentSizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}

private struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}
