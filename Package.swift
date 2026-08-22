// swift-tools-version: 6.2

import PackageDescription

let modernSwiftSettings: [SwiftSetting] = [
  .defaultIsolation(MainActor.self),
  .enableUpcomingFeature("InferIsolatedConformances"),
  .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
]

let package = Package(
  name: "Starter",
  platforms: [
    .macOS(.v26)
  ],
  products: [
    .library(name: "AppCore", targets: ["AppCore"]),
    .executable(name: "Starter", targets: ["StarterApp"]),
  ],
  targets: [
    .target(
      name: "AppCore",
      path: "Sources/AppCore",
      swiftSettings: modernSwiftSettings,
    ),
    .executableTarget(
      name: "StarterApp",
      dependencies: ["AppCore"],
      path: "Sources/Application",
      swiftSettings: modernSwiftSettings,
    ),
    .testTarget(
      name: "AppCoreTests",
      dependencies: ["AppCore"],
      path: "Tests/AppCoreTests",
      swiftSettings: modernSwiftSettings,
    ),
  ],
  swiftLanguageModes: [.v6],
)
