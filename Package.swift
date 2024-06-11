// swift-tools-version: 5.9

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
        .target(name: "MirrorDiffKit"),
        .testTarget(
            name: "MirrorDiffKitTests",
            dependencies: [
                "MirrorDiffKit"
            ]
        )
    ]
)
