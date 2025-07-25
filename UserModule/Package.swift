// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UserModule",
    platforms: [.iOS(.v16)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "UserModule",
            targets: ["UserModule"]
        )
    ],
    dependencies: [
        .package(path: "./CoreModule"),
        .package(url: "https://github.com/theosementa/NetworkKit", exact: "1.0.1")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "UserModule",
            dependencies: [
                "CoreModule",
                .product(name: "NetworkKit", package: "NetworkKit")
            ],
            swiftSettings: [.swiftLanguageMode(.v5)]
        ),
        .testTarget(
            name: "UserModuleTests",
            dependencies: ["UserModule"]
        )
    ]
)
