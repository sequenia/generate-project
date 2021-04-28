// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "projectGenerate",
    platforms: [
        .macOS(.v10_13),
    ],
    products: [
        .executable( name: "projectGenerate", targets: ["projectGenerate"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.4.2"),
        .package(url: "https://github.com/JohnSundell/ShellOut.git", from: "2.0.0"),
        .package(url: "https://github.com/nadjem/Swiftline.git", .branch("master"))
    ],
    targets: [
        .target(
            name: "projectGenerate",
            dependencies: [
                 "Constant",
                 "Utils",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "Swiftline", package: "Swiftline"),
                .product(name: "ShellOut", package: "ShellOut")
             ],
             path: "./Sources/CreateProject"),
        
        .target(
            name: "Constant",
            path: "./Sources/Constant"
        ),
        
        .target(
            name: "Utils",
            path: "./Sources/Utils"
        )
    ]
)
