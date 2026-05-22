// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "BrewUI",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .executable(name: "BrewUI", targets: ["BrewUI"])
    ],
    dependencies: [
        .package(url: "https://github.com/sparkle-project/Sparkle", exact: "2.9.2")
    ],
    targets: [
        .executableTarget(
            name: "BrewUI",
            dependencies: [
                .product(name: "Sparkle", package: "Sparkle")
            ],
            path: "Sources/BrewUI"
        )
    ]
)
