// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

private var utilities = "Utilities"
private var loginInterface = "LoginInterface"
private var homeInterface = "HomeInterface"
private var designSystem = "DSM"
private var networkManager = "NetworkManager"
private var dataBase = "DataBase"

let package = Package(
    name: "Login",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "Login",
            targets: ["Login"]),
    ],
    dependencies: [
        .package(name: utilities, path: "../../\(utilities)"),
        .package(name: loginInterface, path: "../\(loginInterface)"),
        .package(name: "DesignSystem", path: "../../\(designSystem)"),
        .package(name: networkManager, path: "../../\(networkManager)"),
        .package(name: dataBase, path: "../../\(dataBase)"),
        .package(name: homeInterface, path: "../\(homeInterface)"),
    ],
    targets: [
        .target(
            name: "Login",
            dependencies: [
                .product(name: utilities, package: utilities),
                .product(name: loginInterface, package: loginInterface),
                .product(name: homeInterface, package: homeInterface),
                .product(name: "DesignSystem", package: "DesignSystem"),
                .product(name: networkManager, package: networkManager),
                .product(name: dataBase, package: dataBase),
            ],
            resources: [.process("Resources")]
        ),
        .testTarget(
            name: "LoginTests",
            dependencies: ["Login"]
        ),
    ]
)
