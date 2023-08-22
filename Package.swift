// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import Foundation

let isXcode = ProcessInfo.processInfo.environment["__CFBundleIdentifier"] == "com.apple.dt.Xcode"
let isSubDependency: () -> Bool = {
    let context = ProcessInfo.processInfo.arguments.drop {
        $0 != "-context"
    }.dropFirst(1).first
    guard let context else {
        return false
    }
    guard let json = (try? JSONSerialization.jsonObject(with: context.data(using: .utf8) ?? Data())) as? [String: Any] else {
        return false
    }
    guard let packageDirectory = json["packageDirectory"] as? String else {
        return false
    }
    return packageDirectory.contains(".build") || packageDirectory.contains("DerivedData")
}

var dependencies = [Package.Dependency]()
var plugins = [Target.PluginUsage]()

if isXcode && !isSubDependency() {
    dependencies.append(contentsOf: [
        .package(url: "https://github.com/realm/SwiftLint", from: "0.52.2"),
        .package(url: "https://github.com/nicklockwood/SwiftFormat", from: "0.51.12"),
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.1.0"),
    ])
    plugins.append(contentsOf: [
        .plugin(name: "SwiftLintPlugin", package: "SwiftLint"),
    ])
}

let package = Package(
  name: "swift-rawjson",
  platforms: [.macOS(.v12), .iOS(.v13)],
  products: [
    .library(
      name: "RawJson",
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
  ]
)
