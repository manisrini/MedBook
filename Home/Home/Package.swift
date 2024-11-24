// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

private var utilities = "Utilities"
private var homeInterface = "HomeInterface"
private var designSystem = "DSM"
private var networkManager = "NetworkManager"

let package = Package(
    name: "Home",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "Home",
            targets: ["Home"]),
    ],
    dependencies: [
        .package(name: utilities, path: "../../\(utilities)"),
        .package(name: homeInterface, path: "../\(homeInterface)"),
        .package(name: "DesignSystem", path: "../../\(designSystem)"),
        .package(name: networkManager, path: "../../\(networkManager)"),
    ],
    targets: [
        .target(
            name: "Home",
            dependencies: [
                .product(name: utilities, package: utilities),
                .product(name: homeInterface, package: homeInterface),
                .product(name: "DesignSystem", package: "DesignSystem"),
                .product(name: networkManager, package: networkManager),
            ]
        ),
        .testTarget(
            name: "HomeTests",
            dependencies: ["Home"]
        ),
    ]
)
