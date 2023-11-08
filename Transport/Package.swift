// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Transport",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "TransportHome",
            targets: ["TransportHome"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/DevYeom/ModernRIBs.git", exact: "1.0.2"),
        .package(path: "../Finance")
    ],
    targets: [
        .target(
            name: "TransportHome",
            dependencies: [
                "ModernRIBs",
                .product(name: "FinanceRepository", package: "Finance"),
                .product(name: "Topup", package: "Finance")
            ],
            resources: [
                .process("Resources"), // 리소스 같은 경우 여기서 선언!!! :)
            ]
        ),
    ]
)
