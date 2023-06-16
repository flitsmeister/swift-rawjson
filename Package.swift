// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RawJson",
//    platforms: [.macOS("13.3"), .iOS("16.4")],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "RawJson",
            targets: ["RawJson"]),
    ],
    dependencies: [
         .package(url: "https://github.com/apple/swift-foundation.git", branch: "main")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "RawJson",
            dependencies: [
                // .product(name: "FoundationPreview", package: "swift-foundation")
            ]
        ),
        .testTarget(
            name: "RawJsonTests",
            dependencies: ["RawJson"]),
    ]
)
