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
    dependencies: [
        .package(url: "https://github.com/sparkle-project/Sparkle.git", from: "2.8.1"),
    ],
    targets: [
        .executableTarget(
            name: "Peeler",
            dependencies: [
                .product(name: "Sparkle", package: "Sparkle"),
            ],
            path: "Sources/Peeler",
            exclude: [
                "Resources/Info.plist",
                "Resources/Peeler.entitlements",
            ],
            resources: [
                .process("Resources"),
            ],
            linkerSettings: [
                .unsafeFlags(["-Xlinker", "-rpath", "-Xlinker", "@executable_path/../Frameworks"]),
            ]
        ),
    ]
)
