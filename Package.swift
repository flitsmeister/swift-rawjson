// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "RawJson",
  platforms: [.macOS(.v12), .iOS(.v13)],
  products: [
    // Products define the executables and libraries a package produces, making them visible to other packages.
    .library(
      name: "RawJson",
      targets: ["RawJson"]
    ),
  ],
  dependencies: [
    .package(url: "https://github.com/realm/SwiftLint.git", .upToNextMinor(from: "0.52.2")),
    .package(url: "https://github.com/nicklockwood/SwiftFormat", .upToNextMinor(from: "0.51.12")),
  ],
  targets: [
    // Targets are the basic building blocks of a package, defining a module or a test suite.
    // Targets can depend on other targets in this package and products from dependencies.
    .target(
      name: "RawJson",
      dependencies: [
      ],
      plugins: [
        .plugin(name: "SwiftLintPlugin", package: "SwiftLint"),
      ]
    ),
    .testTarget(
      name: "RawJsonTests",
      dependencies: ["RawJson"]
    ),
    .binaryTarget(
      name: "RawJsonBinary",
      url: "https://github.com/flitsmeister/swift-rawjson/releases/download/0.0.9/RawJson.zip",
      checksum: "cad32f9189cf2e817a21a546f06156b90038c8644514f1ae50276f5563954b5f"
    )
  ]
)
