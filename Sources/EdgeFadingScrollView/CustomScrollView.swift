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
        ScrollView(axes, showsIndicators: showsIndicators) {
            AnyView(content()) // HACK: Wrap this with AnyView() or whatever. Otherwise, the calculation of the content size doesn't work well.
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    GeometryReader { contentViewProxy in
                        Color.clear
                            .preference(key: ContentSizePreferenceKey.self, value: contentViewProxy.size)
                            .onPreferenceChange(ContentSizePreferenceKey.self, perform: onContentSizeChange ?? { _ in })
                    }
                )
                .background(
                    // オフセット読み取り用のGeometryReader
                    GeometryReader { proxy in
                        let _ = print("CustomScrollView offset: \(proxy.frame(in: .named(frameLayerCoordinateSpaceName)))")
                        Color.clear
                            .preference(
                                key: RectPreferenceKey.self,
                                value: proxy.frame(in: .named(frameLayerCoordinateSpaceName))
                            )
                    }
                )
        }
        .coordinateSpace(name: frameLayerCoordinateSpaceName)
        .onPreferenceChange(RectPreferenceKey.self, perform: onOffsetChange ?? { _ in })
        .background(
            // ScrollViewのサイズ読み取り用のGeometryReader
            GeometryReader { scrollViewProxy in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: scrollViewProxy.size)
                    .onPreferenceChange(SizePreferenceKey.self, perform: onSizeChange ?? { _ in })
            }
        )
    }
}

private struct RectPreferenceKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = value.union(nextValue())
    }
}

private struct ContentSizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        let next = nextValue()
        value = CGSize(
            width: max(value.width, next.width),
            height: max(value.height, next.height)
        )
    }
}

private struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        let next = nextValue()
        value = CGSize(
            width: max(value.width, next.width),
            height: max(value.height, next.height)
        )
    }
}
