// swift-tools-version:5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Networking",
    platforms: [.iOS("15"), .macOS("10.15")],
	// MARK: - Products
    products: [
        .library(name: "Networking", targets: ["Networking"]),
    ],
	// MARK: - Dependencies
    dependencies: [],
	// MARK: - Targets
    targets: [
        .target(name: "Networking"),
		// MARK: - Target Tests
        .testTarget(name: "NetworkingTests", dependencies: ["Networking"]),
    ]
)
