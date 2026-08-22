// swift-tools-version: 6.0

import PackageDescription

let package = Package(
  name: "Starter",
  platforms: [
    .iOS(.v17),
    .macOS(.v14),
    .tvOS(.v17),
    .visionOS(.v1),
    .watchOS(.v10),
  ],
  products: [
    .library(name: "AppCore", targets: ["AppCore"]),
  ],
  targets: [
    .target(
      name: "AppCore",
      path: "Sources/AppCore",
      swiftSettings: [
        .swiftLanguageMode(.v6),
      ]
    ),
    .testTarget(
      name: "AppCoreTests",
      dependencies: ["AppCore"],
      path: "Tests/AppCoreTests",
      swiftSettings: [
        .swiftLanguageMode(.v6),
      ]
    ),
  ]
)
