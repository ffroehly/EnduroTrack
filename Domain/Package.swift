// swift-tools-version: 5.9
// Domain Package
// This package contains all business entities, value objects, enums, use case protocols,
// and repository protocols. It has NO dependency on UIKit, SwiftUI, or any framework.
// It is the innermost layer of Clean Architecture.

import PackageDescription

let package = Package(
    name: "Domain",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "Domain",
            targets: ["Domain"]
        )
    ],
    targets: [
        .target(
            name: "Domain",
            path: "Sources/Domain"
        ),
        .testTarget(
            name: "DomainTests",
            dependencies: ["Domain"],
            path: "Tests/DomainTests"
        )
    ]
)
