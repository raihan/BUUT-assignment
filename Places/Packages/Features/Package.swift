// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Features",
    platforms: [.iOS("26.0")],
    products: [
        .library(
            name: "Features",
            targets: ["Features"]),
    ],
    dependencies: [
        .package(path: "../LocationsApi"),
        .package(path: "../Models"),
        .package(path: "../UIComponents"),
        .package(path: "../Utility")
    ],
    targets: [
        .target(
            name: "Features",
            dependencies: ["LocationsApi", "Models", "UIComponents", "Utility"]),
        .testTarget(
            name: "FeaturesTests",
            dependencies: ["Features", "LocationsApi", "Models", "UIComponents", "Utility"]
        ),
    ]
)
