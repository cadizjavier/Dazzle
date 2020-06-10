// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "Dazzle",
    products: [
        .executable(name: "dazzle", targets: ["Dazzle"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.1.0"),
        .package(url: "https://github.com/jpsim/Yams.git", from: "3.0.0"),
        .package(url: "https://github.com/stencilproject/Stencil.git", from: "0.13.0")
    ],
    targets: [
        .target(name: "Dazzle", dependencies: [
            .product(name: "ArgumentParser", package: "swift-argument-parser"),
            .product(name: "Yams", package: "Yams"),
            .product(name: "Stencil", package: "Stencil")
        ])
    ]
)
