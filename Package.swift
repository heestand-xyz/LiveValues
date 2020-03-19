// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "LiveValues",
    platforms: [
        .iOS(.v11),
        .macOS(.v10_13),
        .tvOS(.v11)
    ],
    products: [
        .library(name: "LiveValues", targets: ["LiveValues"]),
    ],
    targets: [
        .target(name: "LiveValues", path: "Source"),
        .testTarget(name: "LiveValuesTests", dependencies: ["LiveValues"]),
    ]
)
