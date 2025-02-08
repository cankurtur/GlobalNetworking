// swift-tools-version:5.6
import PackageDescription

let package = Package(
    name: "GlobalNetworking",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "GlobalNetworking",
            targets: ["GlobalNetworking"])
    ],
    targets: [
        .binaryTarget(
            name: "GlobalNetworking",
            path: "GlobalNetworking.xcframework")
    ])
