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
        )
    ],
    targets: [
        .target(
            name: "SwiftFeatureFlagKit",
            path: "Sources/SwiftFeatureFlagKit"
        ),
        .testTarget(
            name: "SwiftFeatureFlagKitTests",
            dependencies: ["SwiftFeatureFlagKit"],
            path: "Tests/SwiftFeatureFlagKitTests"
        )
    ]
)
