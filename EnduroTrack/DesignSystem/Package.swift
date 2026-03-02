// swift-tools-version: 6.0
//  DesignSystem – Swift Package
//
//  Provides reusable SwiftUI components, colours, typography, and charts.
//  Depends on SwiftUI only – no business logic, no networking.

import PackageDescription

let package = Package(
    name: "DesignSystem",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "DesignSystem", targets: ["DesignSystem"]),
    ],
    targets: [
        .target(
            name: "DesignSystem",
            path: "Sources/DesignSystem"
        ),
    ]
)
