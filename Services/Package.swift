// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Services",
    platforms: [.iOS(.v16), .macOS(.v13)],
    products: [
        .library(
            name: "Services",
            targets: ["BasicPromptService", "CodeWriterService", "KeysReader"]),
    ],
    dependencies: [
        .package(url: "https://github.com/SwiftedMind/GPTSwift", from: "2.0.0")
    ],
    targets: [
        .target(
            name: "BasicPromptService",
            dependencies: [
                "GPTSwift",
                "KeysReader"
            ]
        ),
        .target(
            name: "CodeWriterService",
            dependencies: [
                "GPTSwift",
                "KeysReader"
            ]
        ),
        .target(
            name: "KeysReader",
            dependencies: [
                "GPTSwift"
            ]
        )
    ]
)
