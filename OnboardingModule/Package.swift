// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "OnboardingModule",
    platforms: [.iOS(.v16)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "OnboardingModule",
            targets: ["OnboardingModule"]
        )
    ],
    dependencies: [
        .package(path: "./DesignSystemModule"),
        .package(path: "./CoreModule"),
        .package(path: "./UserModule"),
        .package(url: "https://github.com/google/GoogleSignIn-iOS", exact: "9.0.0")
//        .package(url: "https://github.com/theosementa/StatsKit", exact: "1.0.6"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "OnboardingModule",
            dependencies: [
                "DesignSystemModule",
                "CoreModule",
                "UserModule",
                .product(name: "GoogleSignIn", package: "GoogleSignIn-iOS")
//                .product(name: "StatsKit", package: "StatsKit")
            ],
            swiftSettings: [.swiftLanguageMode(.v5)]
        ),
        .testTarget(
            name: "OnboardingModuleTests",
            dependencies: ["OnboardingModule"]
        )
    ]
)
