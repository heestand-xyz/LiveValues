// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "LiveValues",
    platforms: [
        .iOS(.v11),
        .macOS(.v10_12),
        .tvOS(.v11)
    ],
    products: [
        .library(name: "LiveValues", targets: ["LiveValues"]),
    ],
    dependencies: [
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        .target(name: "LiveValues", path: "Source")
    ]
)
