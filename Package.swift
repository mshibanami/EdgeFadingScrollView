// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "EdgeFadingScrollView",
    platforms: [
        .iOS(.v14),
        .macOS(.v11),
        .tvOS(.v14),
    ],
    products: [
        .library(
            name: "EdgeFadingScrollView",
            targets: ["EdgeFadingScrollView"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "EdgeFadingScrollView",
            dependencies: [],
            resources: [
                .process("Resources")
            ]),
        .testTarget(
            name: "EdgeFadingScrollViewTests",
            dependencies: ["EdgeFadingScrollView"]),
    ]
)
