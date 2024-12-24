// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CoreDataRepository",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .tvOS(.v15),
        .watchOS(.v8),
    ],
    products: [
        .library(
            name: "CoreDataRepository",
            targets: ["CoreDataRepository"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/CombineCommunity/CombineExt.git", .upToNextMajor(from: "1.5.1"))
    ],
    targets: [
        .target(
            name: "CoreDataRepository",
            dependencies: [
                .product(name: "CombineExt", package: "CombineExt"),
            ],
            path: "./Sources"
        )
    ]
)
