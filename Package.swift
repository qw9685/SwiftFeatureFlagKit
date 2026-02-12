// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "SwiftFeatureFlagKit",
    platforms: [
        .iOS(.v15),
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "SwiftFeatureFlagKit",
            targets: ["SwiftFeatureFlagKit"]
        ),
        .executable(
            name: "FeatureFlagDemo",
            targets: ["FeatureFlagDemo"]
        )
    ],
    targets: [
        .target(
            name: "SwiftFeatureFlagKit"
        ),
        .executableTarget(
            name: "FeatureFlagDemo",
            dependencies: ["SwiftFeatureFlagKit"]
        ),
        .testTarget(
            name: "SwiftFeatureFlagKitTests",
            dependencies: ["SwiftFeatureFlagKit"]
        )
    ]
)
