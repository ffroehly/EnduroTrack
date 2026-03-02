// swift-tools-version: 6.0
//  EnduroTrack – Root Swift Package
//
//  This manifest sits alongside EnduroTrack.xcodeproj and makes the project's
//  Swift source usable with plain SPM tooling (`swift package resolve`,
//  `swift build`, `swift test`) without requiring Xcode.
//
//  External dependencies:
//    • swift-composable-architecture (remote, >= 1.0.0 < 2.0.0)
//
//  Local package dependencies (each has their own Package.swift):
//    • Domain        – business entities, value objects, use-case protocols
//    • DesignSystem  – reusable SwiftUI components, colours, typography
//
//  NOTE: The @main app entry point (App/EnduroTrackApp.swift) and the
//  Xcode-managed asset catalogue (Assets.xcassets) are excluded from the
//  library target – they are only meaningful inside the Xcode app target.

import PackageDescription

let package = Package(
    name: "EnduroTrack",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "EnduroTrack",
            targets: ["EnduroTrack"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture",
            from: "1.0.0"
        ),
        .package(path: "Domain"),
        .package(path: "DesignSystem"),
    ],
    targets: [
        // Library target – all app Swift sources except the executable entry point
        .target(
            name: "EnduroTrack",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "Domain", package: "Domain"),
                .product(name: "DesignSystem", package: "DesignSystem"),
            ],
            path: "EnduroTrack",
            exclude: [
                // @main entry point is only valid in an executable (Xcode app target)
                "App/EnduroTrackApp.swift",
                // Asset catalogues are Xcode-only resources
                "Assets.xcassets",
            ]
        ),

        // Unit-test target – mirrors EnduroTrackTests/
        .testTarget(
            name: "EnduroTrackTests",
            dependencies: ["EnduroTrack"],
            path: "EnduroTrackTests"
        ),
    ]
)
