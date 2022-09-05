// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UFCPlanningCore",
    platforms: [.iOS(.v15)],
    products: [
        .library(name: "UFCPlanningCore", targets: ["UFCPlanningCore"]),
    ],
    dependencies: [
        .package(url: "https://github.com/realm/realm-swift.git", .upToNextMajor(from: "10.28.7"))
    ],
    targets: [
        .target(
            name: "UFCPlanningCore",
            dependencies: [
                .product(name: "RealmSwift", package: "realm-swift")
            ]
        ),
        .testTarget(name: "UFCPlanningCoreTests", dependencies: ["UFCPlanningCore"]),
    ]
)
