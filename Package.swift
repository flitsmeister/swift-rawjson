// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import Foundation

var dependencies = [Package.Dependency]()
var plugins = [Target.PluginUsage]()

#if !os(Linux)
if ProcessInfo.processInfo.environment["RESOLVE_COMMAND_PLUGINS"] != nil {
  dependencies.append(contentsOf: [
    .package(url: "https://github.com/realm/SwiftLint", from: "0.52.2"),
    .package(url: "https://github.com/nicklockwood/SwiftFormat", from: "0.51.12"),
  ])
  plugins.append(contentsOf: [
    .plugin(name: "SwiftLintPlugin", package: "SwiftLint"),
  ])
}
#endif

let package = Package(
  name: "SwiftRawJson", // renamed so module collision will not happen
  platforms: [.macOS(.v12), .iOS(.v13)],
  products: [
    .library(
      name: "SwiftRawJson",
      targets: ["SwiftRawJson"]
    ),
  ],
  dependencies: dependencies,
  targets: [
    .target(
      name: "SwiftRawJson"
    ),
    .testTarget(
      name: "SwiftRawJsonTests",
      dependencies: ["SwiftRawJson"]
    ),
  ]
)
