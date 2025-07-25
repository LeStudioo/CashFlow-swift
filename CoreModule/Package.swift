// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CoreModule",
    platforms: [.iOS(.v16)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "CoreModule",
            targets: ["CoreModule"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/theosementa/TheoKit", exact: "1.0.7"),
        .package(url: "https://github.com/theosementa/StatsKit", exact: "1.0.6")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "CoreModule",
            dependencies: [
                .product(name: "TheoKit", package: "TheoKit"),
                .product(name: "StatsKit", package: "StatsKit")
            ],
            swiftSettings: [.swiftLanguageMode(.v5)]
        ),
        .testTarget(
            name: "CoreModuleTests",
            dependencies: ["CoreModule"]
        )
    ]
)
