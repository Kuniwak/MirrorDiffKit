// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MirrorDiffKit",
    products: [
        .library(
            name: "MirrorDiffKit", 
            targets: ["MirrorDiffKit"]
        )
    ],
    targets: [
        .target(
            name: "MirrorDiffKit",
            path: "Sources"
        ),
        .testTarget(
            name: "MirrorDiffKitTests",
            dependencies: [
                "MirrorDiffKit"
            ]
        )
    ]
)
