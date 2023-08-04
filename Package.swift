// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

// https://github.com/InvadingOctopus/octopuscore

import PackageDescription

let package = Package(
    name: "OctopusCore",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
        .tvOS(.v17)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "OctopusCore",
            targets: ["OctopusCore"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "OctopusCore",
            dependencies: [],
            exclude: [
                ],
            resources: [
                ]
//          , swiftSettings: [                // MARK: - Conditional Compilation Flags
//                .define("LOGCHANGES"),      // Enables the `@LogChanges` property wrapper and other value logging. ⚠️ May decrease performance.
//            ]                               // Remember to uncomment this if you uncomment any of the lines above ^^
        ),
        .testTarget(
            name: "OctopusCoreTests",
            dependencies: ["OctopusCore"]),
    ],
    swiftLanguageVersions: [.v5]
)

