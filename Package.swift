// swift-tools-version: 6.0

import PackageDescription

let package = Package(
  name: "Starter",
  platforms: [
    .macOS(.v14),
  ],
  products: [
    .library(name: "AppCore", targets: ["AppCore"]),
    .executable(name: "Starter", targets: ["StarterApp"]),
  ],
  targets: [
    .target(
      name: "AppCore",
      path: "Sources/AppCore",
      swiftSettings: [
        .swiftLanguageMode(.v6)
      ]
    ),
    .executableTarget(
      name: "StarterApp",
      dependencies: ["AppCore"],
      path: "Sources/Application",
      swiftSettings: [
        .swiftLanguageMode(.v6)
      ]
    ),
    .testTarget(
      name: "AppCoreTests",
      dependencies: ["AppCore"],
      path: "Tests/AppCoreTests",
      swiftSettings: [
        .swiftLanguageMode(.v6)
      ]
    ),
  ]
)
