// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Utility",
    platforms: [.iOS("26.0")],
    products: [
        .library(
            name: "Utility",
            targets: ["Utility"]),
    ],
    targets: [
        .target(
            name: "Utility"),
        .testTarget(
            name: "UtilityTests",
            dependencies: ["Utility"]
        ),
    ]
)
