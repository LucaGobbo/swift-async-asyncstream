// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-async-asyncstream",
    platforms: [.iOS(.v15), .macOS(.v12), .watchOS(.v8), .macCatalyst(.v15)],
    products: [

        .library(
            name: "AsyncAsyncStream",
            targets: ["AsyncAsyncStream"]),
    ],
    targets: [
        .target(
            name: "AsyncAsyncStream"),
        .testTarget(
            name: "AsyncAsyncStreamTests",
            dependencies: ["AsyncAsyncStream"]),
    ]
)
