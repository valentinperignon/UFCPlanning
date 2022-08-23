// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PlanningProvider",
    platforms: [.iOS(.v15)],
    products: [
        .library(name: "PlanningProvider", targets: ["PlanningProvider"]),
    ],
    targets: [
        .target(name: "PlanningProvider", dependencies: []),
        .testTarget(name: "PlanningProviderTests", dependencies: ["PlanningProvider"]),
    ]
)
