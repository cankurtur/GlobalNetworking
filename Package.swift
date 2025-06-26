// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "GlobalNetworking",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "GlobalNetworking",
            targets: ["GlobalNetworking"]
        )
    ],
    targets: [
        .target(
            name: "GlobalNetworking",
            dependencies: []
        ),
        .testTarget(
            name: "GlobalNetworkingTests",
            dependencies: ["GlobalNetworking"]
        )
    ]
)
