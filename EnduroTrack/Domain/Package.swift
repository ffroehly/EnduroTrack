// swift-tools-version: 6.0
//  Domain – Swift Package
//
//  Innermost layer in Clean Architecture.
//  Contains ONLY entities, value objects, enums, and use-case protocols.
//  NO dependencies on UIKit, SwiftUI, networking, or any 3rd-party library.

import PackageDescription

let package = Package(
    name: "Domain",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "Domain", targets: ["Domain"]),
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
        ),
    ]
)
