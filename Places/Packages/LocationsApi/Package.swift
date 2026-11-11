// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LocationsApi",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "LocationsApi",
            targets: ["LocationsApi"]),
    ],
    dependencies: [
        .package(path: "../ApiService"),
        .package(path: "../Models")
    ],
    targets: [
        .target(
            name: "LocationsApi", dependencies: ["ApiService", "Models"]),
        .testTarget(
            name: "LocationsApiTests",
            dependencies: ["LocationsApi"]
        ),
    ]
)
