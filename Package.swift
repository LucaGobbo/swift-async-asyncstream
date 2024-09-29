// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-async-asyncstream",
    platforms: [.iOS(.v15), .macOS(.v12), .watchOS(.v8), .macCatalyst(.v15)],
    products: [.library(name: "AsyncAsyncStream", targets: ["AsyncAsyncStream"])],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-concurrency-extras", from: "1.2.0")
    ],
    targets: [
        .target(
            name: "AsyncAsyncStream",
            dependencies: [
                .product(name: "ConcurrencyExtras", package: "swift-concurrency-extras")

            ]
        ),
        .testTarget(
            name: "AsyncAsyncStreamTests",
            dependencies: ["AsyncAsyncStream"]
        ),
    ],
    swiftLanguageModes: [.v6]
)
