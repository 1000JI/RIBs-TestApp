// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Platform",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "CombineUtil",
            targets: ["CombineUtil"]
        ),
        .library(
            name: "RIBsUtil",
            targets: ["RIBsUtil"]
        ),
        .library(
            name: "RIBsTestSupport",
            targets: ["RIBsTestSupport"]
        ),
        .library(
            name: "PlatformTestSupport",
            targets: ["PlatformTestSupport"]
        ),
        .library(
            name: "SuperUI",
            targets: ["SuperUI"]
        ),
        .library(
            name: "DefaultsStore",
            targets: ["DefaultsStore"]
        ),
        
        .library(
            name: "Network",
            targets: ["Network"]
        ),
        
        .library(
            name: "NetworkImp",
            targets: ["NetworkImp"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/CombineCommunity/CombineExt", exact: "1.8.1"),
        .package(url: "https://github.com/DevYeom/ModernRIBs.git", exact: "1.0.2"),
        .package(url: "https://github.com/pointfreeco/combine-schedulers", exact: "1.0.0"),
        .package(url: "https://github.com/pointfreeco/swift-snapshot-testing", exact: "1.14.2"),
        .package(url: "https://github.com/httpswift/swifter", exact: "1.5.0"),
        .package(url: "https://github.com/lyft/Hammer", exact: "0.14.3")
    ],
    targets: [
        .target(
            name: "CombineUtil",
            dependencies: [
                "CombineExt",
                .product(name: "CombineSchedulers", package: "combine-schedulers")
            ]
        ),
        .target(
            name: "RIBsUtil",
            dependencies: [
                "ModernRIBs"
            ]
        ),
        .target(
            name: "RIBsTestSupport",
            dependencies: [
                "ModernRIBs"
            ]
        ),
        .target(
            name: "PlatformTestSupport",
            dependencies: [
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
                .product(name: "Swifter", package: "swifter"),
                .product(name: "Hammer", package: "Hammer")
            ]
        ),
        .target(
            name: "SuperUI",
            dependencies: [
                "RIBsUtil"
            ]
        ),
        .target(
            name: "DefaultsStore",
            dependencies: [
            ]
        ),
        .target(
            name: "Network",
            dependencies: [
            ]
        ),
        .target(
            name: "NetworkImp",
            dependencies: [
                "Network"
            ]
        ),
    ]
)
