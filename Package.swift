// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

#if os(Linux)
let dependencies: [Package.Dependency] = []
let plugins: [Target.PluginUsage] = []
#else
let dependencies: [Package.Dependency] = [
  .package(url: "https://github.com/realm/SwiftLint", .upToNextMajor(from: "0.52.2")),
  .package(url: "https://github.com/nicklockwood/SwiftFormat", .upToNextMajor(from: "0.51.12")),
]
let plugins: [Target.PluginUsage] = [.plugin(name: "SwiftLintPlugin", package: "SwiftLint"),]
#endif

let package = Package(
  name: "RawJson",
  platforms: [.macOS(.v12), .iOS(.v13)],
  products: [
    // Products define the executables and libraries a package produces, making them visible to other packages.
    .library(
      name: "RawJson",
      type: .static,
      targets: ["RawJson"]
    ),
  ],
  dependencies: dependencies,
  targets: [
    // Targets are the basic building blocks of a package, defining a module or a test suite.
    // Targets can depend on other targets in this package and products from dependencies.
    .target(
      name: "RawJson",
      dependencies: [
      ],
      plugins: plugins
    ),
    .testTarget(
      name: "RawJsonTests",
      dependencies: ["RawJson"]
    ),
//    .binaryTarget(
//      name: "RawJsonBinary",
//      url: "https://github.com/flitsmeister/swift-rawjson/releases/download/0.0.11/RawJson.zip",
//      checksum: "80c580a5a123dcf994658f92cb21eff28f6398f31e8ce09ca03d30fda625e21a"
//    )
  ]
)
