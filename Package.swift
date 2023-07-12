// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import Foundation

var dependencies = [Package.Dependency]()
var plugins = [Target.PluginUsage]()

#if !os(Linux)
if ProcessInfo.processInfo.environment["RESOLVE_COMMAND_PLUGINS"] != nil {
  dependencies.append(contentsOf: [
    .package(url: "https://github.com/realm/SwiftLint", .upToNextMajor(from: "0.52.2")),
    .package(url: "https://github.com/nicklockwood/SwiftFormat", .upToNextMajor(from: "0.51.12")),
  ])
  plugins.append(contentsOf: [
    .plugin(name: "SwiftLintPlugin", package: "SwiftLint"),
  ])
}
#endif

let package = Package(
  name: "RawJson",
  platforms: [.macOS(.v12), .iOS(.v13)],
  products: [
    .library(
      name: "RawJson",
      type: .static,
      targets: ["RawJson"]
    ),
  ],
  dependencies: dependencies,
  targets: [
    .target(
      name: "RawJson"
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
