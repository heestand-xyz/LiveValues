// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "LiveValues",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .tvOS(.v13)
    ],
    products: [
        .library(name: "LiveValues", targets: ["LiveValues"]),
    ],
    targets: [
        .target(name: "LiveValues", path: "Source"),
        .testTarget(name: "LiveValuesTests", dependencies: ["LiveValues"]),
    ]
)
