// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Peeler",
    platforms: [
        .macOS(.v13),
    ],
    products: [
        .executable(name: "Peeler", targets: ["Peeler"]),
    ],
    targets: [
        .executableTarget(
            name: "Peeler",
            path: "Sources/Peeler",
            exclude: [
                "Resources/Info.plist",
                "Resources/Peeler.entitlements",
            ],
            resources: [
                .process("Resources"),
            ]
        ),
    ]
)
