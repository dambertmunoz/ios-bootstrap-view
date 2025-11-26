// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BootstrapUI",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .tvOS(.v15),
        .watchOS(.v8)
    ],
    products: [
        .library(
            name: "BootstrapUI",
            targets: ["BootstrapUI"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "BootstrapUI",
            dependencies: [],
            path: "Sources/BootstrapUI"
        ),
        .testTarget(
            name: "BootstrapUITests",
            dependencies: ["BootstrapUI"],
            path: "Tests/BootstrapUITests"
        ),
    ]
)
