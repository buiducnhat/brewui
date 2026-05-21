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
    targets: [
        .executableTarget(
            name: "BrewUI",
            path: "Sources/BrewUI"
        )
    ]
)
