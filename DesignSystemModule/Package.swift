// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import Foundation

let isPreview = ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"

var resources: [Resource] {
    if isPreview {
        return [
            .process("Resources/PreviewAssets.xcassets")
            // TODO: Add fonts if possible
        ]
    } else {
        return []
    }
}

let package = Package(
    name: "DesignSystemModule",
    platforms: [.iOS(.v16)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "DesignSystemModule",
            targets: ["DesignSystemModule"]
        )
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(name: "DesignSystemModule"),
        .testTarget(
            name: "DesignSystemModuleTests",
            dependencies: ["DesignSystemModule"]
        )
    ]
)
