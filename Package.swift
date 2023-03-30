// swift-tools-version:5.6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Ethel",
    platforms: [
        .macOS(.v12),
        .iOS(.v15),
        .tvOS(.v15),
        .watchOS(.v3)
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "Ethel",
            targets: ["Ethel"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/grype/SwiftBeacon", .upToNextMajor(from: "2.1.0")),
        .package(url: "https://github.com/quick/Nimble", .upToNextMajor(from: "9.2.0")),
        .package(url: "https://github.com/Brightify/Cuckoo", .upToNextMajor(from: "1.5.0"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "Ethel",
            dependencies: [
                .product(name: "Beacon", package: "SwiftBeacon"),
            ]),
        .testTarget(
            name: "EthelTests",
            dependencies: [
                "Ethel",
                "Nimble",
                "Cuckoo"])
    ])
